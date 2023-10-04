import os
import glob
import re


def main():
    phn_dic = {"0": "-nula-",
               "1": "-jedna-",
               "2": "-dva-",
               "3": "-tŘi-",
               "4": "-čtiři-",
               "5": "-pjet-",
               "6": "-šest-",
               "7": "-sedm-",
               "8": "-osm-",
               "9": "-devjet-"}

    path = "test_SD/*.wav"
    for filename in glob.glob(path):
        phn_path = re.sub(".wav", '.phn', filename)
        with open(phn_path, 'w', encoding='cp1250') as file:
            file.write(phn_dic[filename[-15]])


if __name__ == "__main__":
    main()
