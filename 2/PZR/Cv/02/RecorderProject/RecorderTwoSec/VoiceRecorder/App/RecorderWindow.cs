using NAudio.Wave;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Threading;
using System.Windows.Forms;
using WaveFormRendererLib;
using static VoiceRecorder.Settings;

namespace VoiceRecorder
{
    public partial class RecorderWindow : Form
    {
        private Recorder recorder;
        private Player player;

        private List<string> words = new List<string>();
        private int wordsCount;
        private int current;

        private bool showSaveFileDialog = true;
        public RecorderWindow()
        {
            //Checks if input exists
            if (!File.Exists(WordList))
            {
                MessageBox.Show(ErrorMessageText, ErrorMessageLabel, MessageBoxButtons.OK, MessageBoxIcon.Error);
                this.Close();
            }

            recorder = new Recorder();
            player = new Player();
            player.OnPlaybackStop += PlaybackStopped;
            recorder.OnStopRecording += RecordingStopped;
            FormClosing += (s, a) => { recorder.StopRecord(true); };
            words = File.ReadAllText(WordList).Replace(Environment.NewLine, "\n").Split('\n').ToList();
            wordsCount = words.Count;
            current = 0;
            InitializeComponent();
            ShowCurrentWord();
        }

        private void PlaybackStopped()
        {
            if (showSaveFileDialog) {
                recordingIndication.Text = string.Empty;
                DialogResult dialogResult = MessageBox.Show(SaveMessageText, SaveMessageLabel, MessageBoxButtons.YesNo);
                if (dialogResult == DialogResult.Yes)
                {
                    string outputFileName = words[current];
                    var path = Path.Combine(RootOutputFolder, GetFolderName.FolderToSaveTo, outputFileName);
                    //File.WriteAllText(path + ".txt", words[current]);

                    //Moves temp wave file to the right folder
                    if (File.Exists(path + ".wav"))
                    {
                        File.Delete(path + ".wav");
                    }
                    File.Move(Path.Combine(RootOutputFolder, TempRecordName), path + ".wav");

                    current++;
                }
                else
                {
                    File.Delete(Path.Combine(RootOutputFolder, TempRecordName));
                }
                pictureBox.Image = null;
                ShowCurrentWord();
            }
            showSaveFileDialog = true;
        }

        private void ShowCurrentWord()
        {
            pictureBox.Image = null;
            WordBackButton.Enabled = true;
            WordForwardButton.Enabled = true;
            if (current < wordsCount)
            {
                currentWordCount.Text = $"{current + 1}/{wordsCount}";
                Word.Text = words[current];
                Record.Enabled = true;
                //var path = Path.Combine(RootOutputFolder, GetFolderName.FolderToSaveTo, (current + 1).ToString("D3") + ".wav");
                var path = Path.Combine(RootOutputFolder, GetFolderName.FolderToSaveTo, words[current] + ".wav");
                if (File.Exists(path))
                {
                    RenderWaveForm(path);
                }
            }
            else
            {
                Word.Text = RecordingFinishedText;
                Record.Enabled = false;
            }
        }

        private void TrimWav(string path, string tempFilePath)
        {
            AudioFileReader reader = new AudioFileReader(path);
            WavFileUtils.TrimWavFile(path, tempFilePath, new TimeSpan(0), reader.TotalTime - new TimeSpan(0, 0, 0, recordLength, 0));
            reader.Close();
            if (File.Exists(path))
            {
                File.Delete(path);
            }
            File.Move(tempFilePath, path);
        }

        private void RecordingStopped()
        {
            TrimWav(Path.Combine(RootOutputFolder, TempRecordName), Path.Combine(RootOutputFolder, "temp.wav"));

            recordingIndication.ForeColor = Color.Black;
            recordingIndication.Text = PlaybackInProgressText;

            player.Play(Path.Combine(RootOutputFolder, TempRecordName));

            RenderWaveForm(Path.Combine(RootOutputFolder, TempRecordName));
        }

        private void RenderWaveForm(string audioFilePath)
        {
            AveragePeakProvider averagePeakProvider = new AveragePeakProvider(4); // e.g. 4

            SoundCloudOriginalSettings myRendererSettings = new SoundCloudOriginalSettings();
            myRendererSettings.Width = pictureBox.Width;
            myRendererSettings.TopHeight = pictureBox.Height / 2;
            myRendererSettings.BottomHeight = pictureBox.Height / 2;

            WaveFormRenderer renderer = new WaveFormRenderer();

            pictureBox.Image = renderer.Render(audioFilePath, averagePeakProvider, myRendererSettings);
        }

        private void Record_Click(object sender, EventArgs e)
        {
            Record.Enabled = false;
            WordBackButton.Enabled = false;
            WordForwardButton.Enabled = false;
            recordingIndication.ForeColor = Color.Red;
            recordingIndication.Text = RecordingInProgressText;
            Thread.Sleep(sleepBeforeRecordStart);
            recorder.StartRecord(TempRecordName);
            StartProgressBar();
        }

        private void StartProgressBar()
        {
            backgroundWorker1.WorkerReportsProgress = true;
            backgroundWorker1.RunWorkerAsync();
        }

        private void RecorderWindow_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.Control == true && e.KeyCode == Keys.Space)
            {
                Record.PerformClick();
            }
        }

        private void WordBackButton_Click(object sender, EventArgs e)
        {
            if (current - 1 >= 0)
            {
                current--;
                ShowCurrentWord();
            }
        }

        private void WordForwardButton_Click(object sender, EventArgs e)
        {
            if (current + 1 < wordsCount)
            {
                current++;
                ShowCurrentWord();
            }
        }

        private void backgroundWorker1_DoWork(object sender, System.ComponentModel.DoWorkEventArgs e)
        {
            for (int i = progressBar1.Minimum + 1; i <= progressBar1.Maximum; i++)
            {
                backgroundWorker1.ReportProgress(i);
                Thread.Sleep(recordLength);
            }
        }

        private void backgroundWorker1_ProgressChanged(object sender, System.ComponentModel.ProgressChangedEventArgs e)
        {
            progressBar1.SetProgressNoAnimation(e.ProgressPercentage);
            progressPercentage.Text = e.ProgressPercentage.ToString();
        }

        private void backgroundWorker1_RunWorkerCompleted(object sender, System.ComponentModel.RunWorkerCompletedEventArgs e)
        {
            progressBar1.Value = progressBar1.Minimum;
            progressPercentage.Text = "Progress";
        }

        private void currentWordCount_Click(object sender, EventArgs e)
        {
            showSaveFileDialog = false;
            var path = Path.Combine(RootOutputFolder, GetFolderName.FolderToSaveTo, words[current] + ".wav");
            if (File.Exists(path))
            {
                player.Play(path);
            }
        }
    }

    public static class ExtensionMethods
    {
        /// <summary>
        /// Sets the progress bar value, without using 'Windows Aero' animation.
        /// This is to work around a known WinForms issue where the progress bar 
        /// is slow to update. 
        /// </summary>
        public static void SetProgressNoAnimation(this ProgressBar pb, int value)
        {
            // To get around the progressive animation, we need to move the 
            // progress bar backwards.
            if (value == pb.Maximum)
            {
                // Special case as value can't be set greater than Maximum.
                pb.Maximum = value + 1;     // Temporarily Increase Maximum
                pb.Value = value + 1;       // Move past
                pb.Maximum = value;         // Reset maximum
            }
            else
            {
                pb.Value = value + 1;       // Move past
            }
            pb.Value = value;               // Move to correct value
        }
    }
}
