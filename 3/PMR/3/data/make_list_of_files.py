import os
import glob
import re


def main():
    path = "train_all/**/*.wav"
    with open('file_list', 'w') as file:
        for filename in glob.glob(path, recursive=True):
            fullpath_wav = os.path.abspath(filename)
            file.write(fullpath_wav + "\n")


if __name__ == "__main__":
    main()
