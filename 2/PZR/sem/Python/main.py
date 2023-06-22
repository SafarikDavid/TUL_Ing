import os
from time import sleep, time

import numpy
from PyQt5.QtWidgets import QApplication, QMainWindow, QWidget, QPushButton, QVBoxLayout, QLineEdit, QHBoxLayout, \
    QGridLayout, QSizePolicy, QProgressBar
from PyQt5.QtCore import Qt, QThread, QObject, pyqtSignal, QTimer

import sounddevice as sd

import numpy as np
from sklearn import preprocessing
import python_speech_features as psf
import soundfile as sf
from tslearn.metrics import dtw


Fs = 16000
nBits = 16
nChannels = 1
recDur = 2
winlen_millis = .025
winlen = int(Fs * winlen_millis)
winstep_millis = .01
winstep = int(Fs * winstep_millis)
numcep = 13
nfft = 512
n_windows = int((Fs * recDur - winstep) / winstep)-1
k_extremas = 10
boundary_percentage = 0.5
boundary_shift = 10

classes_dict = {0: "zero",
                1: "one",
                2: "two",
                3: "three",
                4: "four",
                5: "five",
                6: "six",
                7: "seven",
                8: "eight",
                9: "nine",
                10: "plus",
                11: "minus",
                12: "multiply",
                13: "divide",
                14: "dot",
                15: "equal",
                16: "clear",
                17: "back",
                18: "unknown"}

train_data_root = "train"
train_data_end = ".wav"
train_features = []
train_classes = []

distance_threshold = 40.
sleep_after_recognition = 0.5


def load_train_data():
    for path, _, files in os.walk(train_data_root):
        for file in files:
            if file.endswith(train_data_end):
                file_path = os.path.join(path, file)
                data, sr = sf.read(file_path)
                if sr != Fs:
                    raise Exception("Unsupported sampling rate.")
                train_features.append(extract_features(data))
                train_classes.append(int(file[0:2]))


def extract_features(audio):
    """
    Method for MFCC39 feature extraction from speech signal
    :param audio:
    :return:
    """
    cutout = cutout_active_voice(audio)
    mfcc_feature = psf.mfcc(cutout, Fs, winlen=winlen_millis, winstep=winstep_millis, numcep=numcep, nfft=nfft, appendEnergy=False, winfunc=numpy.hamming)
    mfcc_feature = preprocessing.scale(mfcc_feature)
    delta1 = psf.delta(mfcc_feature, 1)
    delta2 = psf.delta(delta1, 1)
    combined = np.hstack((mfcc_feature, delta1, delta2))
    return combined


def cutout_active_voice(audio):
    """
    Method to cut out active part of speech signal
    :param audio:
    :return:
    """
    audio_norm = audio - np.mean(audio)

    windows = np.array([audio_norm[i*winstep:i*winstep+winlen] for i in range(0, n_windows)])
    windows = windows.reshape([n_windows, winlen])
    energy = np.log(np.sum(windows*windows, axis=1))

    result = np.argpartition(energy, k_extremas)
    mean_min_energy = np.mean(energy[result[:k_extremas]])

    result = np.argpartition(energy, -k_extremas)
    mean_max_energy = np.mean(energy[result[-k_extremas:]])

    word_threshold = mean_min_energy + np.abs(mean_max_energy - mean_min_energy) * boundary_percentage

    word_start = 0
    word_end = len(energy)-1
    while (energy[word_start]) < word_threshold:
        word_start = word_start + 1
    while (energy[word_end]) < word_threshold:
        word_end = word_end - 1
    word_start = np.maximum(word_start - boundary_shift, 0)
    word_end = np.minimum(word_end + boundary_shift, len(energy)-1)

    return audio[word_start*winstep:word_end*winstep+winlen]


def recognize_command(feature_mat):
    min_distance = sys.float_info.max
    min_idx = -1
    for idx, train_feat in enumerate(train_features):
        distance = dtw(feature_mat, train_feat)
        if distance < min_distance:
            min_distance = distance
            min_idx = idx
    print(f"{classes_dict[train_classes[min_idx]]} | dist: {min_distance}")
    if min_distance > distance_threshold:
        return 18
    else:
        return train_classes[min_idx]


class AudioWorker(QObject):
    progress = pyqtSignal(int)
    command = pyqtSignal(str)

    def run(self):
        while True:
            self.progress.emit(0)
            sig = sd.rec(int(recDur * Fs), samplerate=Fs, channels=nChannels)

            start_time = time()
            duration_s = recDur

            while 1:
                elapsed_time = time() - start_time
                self.progress.emit(int(elapsed_time*(100/recDur)))
                current_location = elapsed_time / float(duration_s)
                if current_location >= 1:
                    break
                sleep(.01)
            sd.wait()

            self.command.emit(classes_dict[recognize_command(extract_features(sig))])

            sleep(sleep_after_recognition)


class Calculator(QMainWindow):
    def __init__(self):
        super().__init__()

        self.initUI()

    def initUI(self):
        self.setWindowTitle("Python App")
        self.setGeometry(100, 100, 457, 427)

        central_widget = QWidget()
        self.setCentralWidget(central_widget)

        vbox = QVBoxLayout(central_widget)
        vbox.setContentsMargins(0, 0, 0, 0)

        self.progressBar = QProgressBar()
        self.progressBar.setOrientation(Qt.Horizontal)
        self.progressBar.setValue(0)
        vbox.addWidget(self.progressBar)

        self.text = QLineEdit()
        self.text.setReadOnly(True)
        self.text.setAlignment(Qt.AlignRight)
        vbox.addWidget(self.text)

        grid_layout = QGridLayout()

        buttons = [
            ('ZPATKY', self.B_BackButtonPushed),
            ('SMAZAT', self.B_ClearButtonPushed),
            ('-', self.B_MinusButtonPushed),
            ('+', self.B_PlusButtonPushed),
            ('7', self.B7ButtonPushed),
            ('8', self.B8ButtonPushed),
            ('9', self.B9ButtonPushed),
            ('/', self.B_DivideButtonPushed),
            ('4', self.B4ButtonPushed),
            ('5', self.B5ButtonPushed),
            ('6', self.B6ButtonPushed),
            ('*', self.B_MultiplyButtonPushed),
            ('1', self.B1ButtonPushed),
            ('2', self.B2ButtonPushed),
            ('3', self.B3ButtonPushed),
            ('=', self.B_EqualButtonPushed),
            ('0', self.B0ButtonPushed),
            ('.', self.B_DotButtonPushed)
        ]

        positions = [(i, j) for i in range(5) for j in range(4)]

        for position, button in zip(positions, buttons):
            text, callback = button
            btn = QPushButton(text)
            btn.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
            btn.clicked.connect(callback)
            grid_layout.addWidget(btn, *position)

        vbox.addLayout(grid_layout)

    def run_audio_worker(self):
        """
        Runs AudioWorker
        :return:
        """
        self.thread = QThread()
        self.worker = AudioWorker()
        self.worker.moveToThread(self.thread)
        self.thread.started.connect(self.worker.run)
        self.worker.progress.connect(self.acceptProgress)
        self.worker.command.connect(self.accept_command)
        self.thread.start()

    def accept_command(self, command):
        """
        Evaluates command
        :param command:
        :return:
        """
        if command == classes_dict[0]:
            self.B0ButtonPushed()
            return
        if command == classes_dict[1]:
            self.B1ButtonPushed()
            return
        if command == classes_dict[2]:
            self.B2ButtonPushed()
            return
        if command == classes_dict[3]:
            self.B3ButtonPushed()
            return
        if command == classes_dict[4]:
            self.B4ButtonPushed()
            return
        if command == classes_dict[5]:
            self.B5ButtonPushed()
            return
        if command == classes_dict[6]:
            self.B6ButtonPushed()
            return
        if command == classes_dict[7]:
            self.B7ButtonPushed()
            return
        if command == classes_dict[8]:
            self.B8ButtonPushed()
            return
        if command == classes_dict[9]:
            self.B9ButtonPushed()
            return
        if command == classes_dict[10]:
            self.B_PlusButtonPushed()
            return
        if command == classes_dict[11]:
            self.B_MinusButtonPushed()
            return
        if command == classes_dict[12]:
            self.B_MultiplyButtonPushed()
            return
        if command == classes_dict[13]:
            self.B_DivideButtonPushed()
            return
        if command == classes_dict[14]:
            self.B_DotButtonPushed()
            return
        if command == classes_dict[15]:
            self.B_EqualButtonPushed()
            return
        if command == classes_dict[16]:
            self.B_ClearButtonPushed()
            return
        if command == classes_dict[17]:
            self.B_BackButtonPushed()
            return

    def acceptProgress(self, progress):
        self.progressBar.reset()
        self.progressBar.setValue(int(progress))

    def B0ButtonPushed(self):
        q = self.text.text()
        self.text.setText(q + '0')

    def B_DotButtonPushed(self):
        q = self.text.text()
        self.text.setText(q + '.')

    def B3ButtonPushed(self):
        q = self.text.text()
        self.text.setText(q + '3')

    def B2ButtonPushed(self):
        q = self.text.text()
        self.text.setText(q + '2')

    def B1ButtonPushed(self):
        q = self.text.text()
        self.text.setText(q + '1')

    def B_MultiplyButtonPushed(self):
        q = self.text.text()
        self.text.setText(q + '*')

    def B6ButtonPushed(self):
        q = self.text.text()
        self.text.setText(q + '6')

    def B5ButtonPushed(self):
        q = self.text.text()
        self.text.setText(q + '5')

    def B4ButtonPushed(self):
        q = self.text.text()
        self.text.setText(q + '4')

    def B_DivideButtonPushed(self):
        q = self.text.text()
        self.text.setText(q + '/')

    def B9ButtonPushed(self):
        q = self.text.text()
        self.text.setText(q + '9')

    def B8ButtonPushed(self):
        q = self.text.text()
        self.text.setText(q + '8')

    def B7ButtonPushed(self):
        q = self.text.text()
        self.text.setText(q + '7')

    def B_PlusButtonPushed(self):
        q = self.text.text()
        self.text.setText(q + '+')

    def B_MinusButtonPushed(self):
        q = self.text.text()
        self.text.setText(q + '-')

    def B_ClearButtonPushed(self):
        self.text.clear()

    def B_BackButtonPushed(self):
        q = self.text.text()
        self.text.setText(q[:-1])

    def B_EqualButtonPushed(self):
        q = self.text.text()
        try:
            result = eval(q)
            self.text.setText(str(result))
        except:
            self.text.setText('Error')


if __name__ == '__main__':
    import sys

    load_train_data()

    app = QApplication(sys.argv)
    ex = Calculator()
    ex.show()
    ex.run_audio_worker()
    sys.exit(app.exec_())
