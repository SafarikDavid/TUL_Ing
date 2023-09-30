import os
import glob
import re


def main():
    file_name_format = 'data/{num:03}.wav'
    path = "data/*.wav"
    for filename in glob.glob(path):
        wav_number = int(re.sub('\D', '', filename))
        my_source = filename
        my_dest = file_name_format.format(num=wav_number)
        # rename() function will
        # rename all the files
        os.rename(my_source, my_dest)


if __name__ == "__main__":
    main()
