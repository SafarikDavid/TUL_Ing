import os
import glob
import re


def main():
    path = "**/*.wav"
    with open('mfc_list', 'w') as file:
        for filename in glob.glob(path, recursive=True):
            fullpath_wav = os.path.abspath(filename)
            fullpath_wav = re.sub('.wav', '.mfc', fullpath_wav)
            file.write(fullpath_wav + "\n")


if __name__ == "__main__":
    main()
