using NAudio.Wave;
using System;
using System.IO;

namespace VoiceRecorder
{
    public class Player
    {
        public Action OnPlaybackStop;

        private WaveOutEvent outputDevice;
        private AudioFileReader audioFile;

        public Player()
        {
            if (outputDevice == null)
            {
                outputDevice = new WaveOutEvent();
                outputDevice.PlaybackStopped += OnPlaybackStopped;
            }
        }

        public void Play(string path)
        {
            if (audioFile == null)
            {
                audioFile = new AudioFileReader(path);
                outputDevice.Init(audioFile);
            }
            outputDevice.Play();
        }

        private void OnPlaybackStopped(object sender, StoppedEventArgs e)
        {
            audioFile?.Dispose();
            audioFile = null;
            OnPlaybackStop?.Invoke();
        }
    }
}
