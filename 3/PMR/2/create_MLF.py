import os
import glob
import re


def main():
    path = "data/*.lab"
    with open('train.mlf', 'w') as file_mlf:
        file_mlf.write("#!MLF!#\n")
        for filename in glob.glob(path):
            fullpath_lab = os.path.abspath(filename)
            with open(fullpath_lab, 'r', encoding='cp1250') as file_lab:
                lab_text = file_lab.readlines()
            file_mlf.write('"' + fullpath_lab + '"' + '\n')
            for line in lab_text:
                file_mlf.write(line)
            file_mlf.write('.\n')


if __name__ == "__main__":
    main()
