namespace VoiceRecorder
{
    partial class RecorderWindow
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.Record = new System.Windows.Forms.Button();
            this.Word = new System.Windows.Forms.Label();
            this.pictureBox = new System.Windows.Forms.PictureBox();
            this.currentWordCount = new System.Windows.Forms.Label();
            this.recordingIndication = new System.Windows.Forms.Label();
            this.WordBackButton = new System.Windows.Forms.Button();
            this.WordForwardButton = new System.Windows.Forms.Button();
            this.progressBar1 = new System.Windows.Forms.ProgressBar();
            this.backgroundWorker1 = new System.ComponentModel.BackgroundWorker();
            this.progressPercentage = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // Record
            // 
            this.Record.Font = new System.Drawing.Font("Microsoft Sans Serif", 20.25F);
            this.Record.Location = new System.Drawing.Point(12, 12);
            this.Record.Name = "Record";
            this.Record.Size = new System.Drawing.Size(119, 133);
            this.Record.TabIndex = 0;
            this.Record.Text = "Record";
            this.Record.UseVisualStyleBackColor = true;
            this.Record.Click += new System.EventHandler(this.Record_Click);
            // 
            // Word
            // 
            this.Word.AutoSize = true;
            this.Word.Font = new System.Drawing.Font("Microsoft Sans Serif", 85.4F);
            this.Word.Location = new System.Drawing.Point(137, 12);
            this.Word.Name = "Word";
            this.Word.Size = new System.Drawing.Size(327, 128);
            this.Word.TabIndex = 1;
            this.Word.Text = "Word";
            // 
            // pictureBox
            // 
            this.pictureBox.Location = new System.Drawing.Point(12, 209);
            this.pictureBox.Name = "pictureBox";
            this.pictureBox.Size = new System.Drawing.Size(1409, 735);
            this.pictureBox.TabIndex = 3;
            this.pictureBox.TabStop = false;
            // 
            // currentWordCount
            // 
            this.currentWordCount.AutoSize = true;
            this.currentWordCount.Location = new System.Drawing.Point(45, 156);
            this.currentWordCount.Name = "currentWordCount";
            this.currentWordCount.Size = new System.Drawing.Size(48, 13);
            this.currentWordCount.TabIndex = 4;
            this.currentWordCount.Text = "000/000";
            this.currentWordCount.Click += new System.EventHandler(this.currentWordCount_Click);
            // 
            // recordingIndication
            // 
            this.recordingIndication.AutoSize = true;
            this.recordingIndication.Font = new System.Drawing.Font("Microsoft Sans Serif", 16.25F);
            this.recordingIndication.ForeColor = System.Drawing.SystemColors.InfoText;
            this.recordingIndication.Location = new System.Drawing.Point(154, 146);
            this.recordingIndication.Name = "recordingIndication";
            this.recordingIndication.Size = new System.Drawing.Size(0, 26);
            this.recordingIndication.TabIndex = 5;
            // 
            // WordBackButton
            // 
            this.WordBackButton.Location = new System.Drawing.Point(12, 151);
            this.WordBackButton.Name = "WordBackButton";
            this.WordBackButton.Size = new System.Drawing.Size(27, 23);
            this.WordBackButton.TabIndex = 1;
            this.WordBackButton.TabStop = false;
            this.WordBackButton.Text = "<";
            this.WordBackButton.UseVisualStyleBackColor = true;
            this.WordBackButton.Click += new System.EventHandler(this.WordBackButton_Click);
            // 
            // WordForwardButton
            // 
            this.WordForwardButton.Location = new System.Drawing.Point(104, 151);
            this.WordForwardButton.Name = "WordForwardButton";
            this.WordForwardButton.Size = new System.Drawing.Size(27, 23);
            this.WordForwardButton.TabIndex = 2;
            this.WordForwardButton.TabStop = false;
            this.WordForwardButton.Text = ">";
            this.WordForwardButton.UseVisualStyleBackColor = true;
            this.WordForwardButton.Click += new System.EventHandler(this.WordForwardButton_Click);
            // 
            // progressBar1
            // 
            this.progressBar1.Location = new System.Drawing.Point(12, 180);
            this.progressBar1.MarqueeAnimationSpeed = 2;
            this.progressBar1.Name = "progressBar1";
            this.progressBar1.Size = new System.Drawing.Size(1409, 23);
            this.progressBar1.Step = 1;
            this.progressBar1.TabIndex = 6;
            // 
            // backgroundWorker1
            // 
            this.backgroundWorker1.DoWork += new System.ComponentModel.DoWorkEventHandler(this.backgroundWorker1_DoWork);
            this.backgroundWorker1.ProgressChanged += new System.ComponentModel.ProgressChangedEventHandler(this.backgroundWorker1_ProgressChanged);
            this.backgroundWorker1.RunWorkerCompleted += new System.ComponentModel.RunWorkerCompletedEventHandler(this.backgroundWorker1_RunWorkerCompleted);
            // 
            // progressPercentage
            // 
            this.progressPercentage.AutoSize = true;
            this.progressPercentage.Location = new System.Drawing.Point(1373, 164);
            this.progressPercentage.Name = "progressPercentage";
            this.progressPercentage.Size = new System.Drawing.Size(48, 13);
            this.progressPercentage.TabIndex = 7;
            this.progressPercentage.Text = "Progress";
            // 
            // RecorderWindow
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.Window;
            this.ClientSize = new System.Drawing.Size(1433, 956);
            this.Controls.Add(this.progressPercentage);
            this.Controls.Add(this.progressBar1);
            this.Controls.Add(this.WordForwardButton);
            this.Controls.Add(this.WordBackButton);
            this.Controls.Add(this.recordingIndication);
            this.Controls.Add(this.currentWordCount);
            this.Controls.Add(this.pictureBox);
            this.Controls.Add(this.Word);
            this.Controls.Add(this.Record);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Name = "RecorderWindow";
            this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
            this.Text = "Recorder";
            this.KeyUp += new System.Windows.Forms.KeyEventHandler(this.RecorderWindow_KeyUp);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button Record;
        private System.Windows.Forms.Label Word;
        private System.Windows.Forms.PictureBox pictureBox;
        private System.Windows.Forms.Label currentWordCount;
        private System.Windows.Forms.Label recordingIndication;
        private System.Windows.Forms.Button WordBackButton;
        private System.Windows.Forms.Button WordForwardButton;
        private System.Windows.Forms.ProgressBar progressBar1;
        private System.ComponentModel.BackgroundWorker backgroundWorker1;
        private System.Windows.Forms.Label progressPercentage;
    }
}