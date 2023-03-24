using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace VoiceRecorder
{
    public partial class GetFolderName : Form
    {
        public GetFolderName()
        {
            InitializeComponent();
        }

        public static string FolderToSaveTo { get; protected set; }

        private void Ok_Click(object sender, EventArgs e)
        {
            if (textBox.Text.Length > 0)
            {
                FolderToSaveTo = textBox.Text.ToUpper();
                var path = Path.Combine(Settings.RootOutputFolder, FolderToSaveTo);
                bool dirExists = Directory.Exists(path);
                bool isEmpty = dirExists && Directory.GetFiles(path).Length <= 0;
                if (dirExists)
                {
                    if (isEmpty)
                    {
                        Close();
                    }
                    else
                    {
                        //MessageBox.Show("Directory already exists and has data stored!");
                        DialogResult dialogResult = MessageBox.Show(Settings.ProceedAnywayText, Settings.ProceedAnywayLabel, MessageBoxButtons.YesNo);
                        if(dialogResult == DialogResult.Yes)
                        {
                            Close();
                        }
                        else
                        {
                            FolderToSaveTo = null;
                        }
                    }
                }
                else
                {
                    Directory.CreateDirectory(path);
                    Close();
                }
            }
        }

        private void GetFolderName_Load(object sender, EventArgs e)
        {

        }
    }
}
