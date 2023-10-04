import os
import glob
import re


def main():
    path = "test_SI/**/*.wav"
    with open('file_list', 'w') as file:
        for filename in glob.glob(path, recursive=True):
            fullpath_lab = os.path.abspath(filename)
            file.write(fullpath_lab + "\n")


if __name__ == "__main__":
    main()
