import os
import glob
import re


def main():
    path = "train_all/**/*.wav"
    with open('param_list', 'w') as file:
        for filename in glob.glob(path, recursive=True):
            fullpath_wav = os.path.abspath(filename)
            fullpath_mfc = re.sub(".wav", ".mfc", fullpath_wav)
            file.write(fullpath_wav + " " + fullpath_mfc + "\n")


if __name__ == "__main__":
    main()
