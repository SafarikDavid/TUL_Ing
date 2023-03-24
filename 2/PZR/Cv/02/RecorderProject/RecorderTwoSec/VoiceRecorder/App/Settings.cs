using System;
using System.IO;

namespace VoiceRecorder
{
    public static class Settings
    {
        //Recording settings
        public static readonly int Fs = 16000;
        public static readonly int nChannels = 1;
        public static readonly int bitDepth = 16;
        public static readonly int recordLength = 2;
        public static readonly int totalBytes = (Fs * bitDepth * recordLength * nChannels) / 8;
        public static readonly int sleepBeforeRecordStart = 200;

        //Paths
        //public static readonly string OutputFolder = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "NAudio");
        public static readonly string RootOutputFolder = "Data";

        public static readonly string WordList = Path.Combine("Resources", "SeznamSlovProNahravani.txt");

        public static readonly string TempRecordName = "recorded.wav";

        //Dialog
        public static readonly string ProceedAnywayLabel = "Adresar neni prazdny";
        public static readonly string ProceedAnywayText = "Presto pokracovat?";

        public static readonly string ErrorMessageLabel = "Chyba";
        public static readonly string ErrorMessageText = "Neni vstup";

        public static readonly string SaveMessageLabel = "Ulozit?";
        public static readonly string SaveMessageText = "Je nahravka v poradku?";

        public static readonly string PlaybackInProgressText = "Prehravam...";
        public static readonly string RecordingInProgressText = "Nahravam...";

        public static readonly string RecordingFinishedText = "Nahravani dokonceno!";
    }
}
