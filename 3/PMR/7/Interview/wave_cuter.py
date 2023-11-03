from pydub import AudioSegment
import math


class SplitWavAudioMubin():
    def __init__(self, folder, filename):
        self.folder = folder
        self.filename = filename
        self.filepath = folder + '\\' + filename

        self.audio = AudioSegment.from_wav(self.filepath)

    def get_duration(self):
        return self.audio.duration_seconds

    def single_split(self, from_min, to_min, split_filename):
        t1 = from_min * 60 * 1000
        t2 = to_min * 60 * 1000
        split_audio = self.audio[t1:t2]
        split_audio.export(self.folder + '\\' + split_filename, format="wav")

    def multiple_split(self, min_per_split):
        total_minutes = math.ceil(self.get_duration() / 60)
        for i in range(0, total_minutes, min_per_split):
            split_new_name = str(i) + '_' + self.filename
            self.single_split(i, i + min_per_split, split_new_name)
            print(str(i) + ' Done')
            if i == total_minutes - min_per_split:
                print('All split successfully')


def main():
    folder = '.'
    file = 'DINT0104.wav'
    split_wav = SplitWavAudioMubin(folder, file)
    split_wav.multiple_split(min_per_split=4)


if __name__ == "__main__":
    main()
