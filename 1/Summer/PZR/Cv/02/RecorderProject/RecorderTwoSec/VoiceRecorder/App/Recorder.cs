using NAudio.Wave;
using System;
using System.IO;
using static VoiceRecorder.Settings;

namespace VoiceRecorder
{
    public class Recorder
    {
        public Action OnStopRecording;
        WaveFileWriter writer = null;
        string outputFilePath;

        //private int totalBytes = (Fs * bitDepth * recordLength * nChannels) / 8;

        WaveIn waveIn = new WaveIn();

        private void Init()
        {
            waveIn = new WaveIn();
            waveIn.WaveFormat = new WaveFormat(Fs, bitDepth, nChannels);

            waveIn.DataAvailable += (s, a) =>
            {
                //if (writer.Position > waveIn.WaveFormat.AverageBytesPerSecond * 1.8)

                writer.Write(a.Buffer, 0, a.BytesRecorded);
                if(writer.Position >= totalBytes)
                {
                    StopRecord();
                }
            };

            waveIn.RecordingStopped += (s, a) =>
            {
                writer?.Dispose();
                writer = null;
                OnStopRecording?.Invoke();
            };
        }

        public void StartRecord(string fileName)
        {
            Init();
            outputFilePath = Path.Combine(RootOutputFolder, fileName);
            if (!Directory.Exists(RootOutputFolder))
            {
                Directory.CreateDirectory(RootOutputFolder);
            }
            writer = new WaveFileWriter(outputFilePath, waveIn.WaveFormat);
            waveIn.StartRecording();
        }

        public void StopRecord(bool force = false)
        {
            waveIn.StopRecording();
            if (force)
            {
                waveIn?.Dispose();
            }
        }
    }
}
