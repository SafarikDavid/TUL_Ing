import os
import glob
import re


def main():
    out_lines = []
    path = "data/*.wav"
    for filename in glob.glob(path):
        fullpath_wav = os.path.abspath(filename)
        fullpath_mfc = re.sub('.wav', '.mfc', fullpath_wav)
        out_lines.append(fullpath_wav + ' ' + fullpath_mfc)
    with open('HTK/param.list', 'w') as file:
        for line in out_lines:
            file.write(line)
            file.write('\n')


if __name__ == "__main__":
    main()
