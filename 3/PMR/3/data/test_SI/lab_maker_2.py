import os
import glob
import re


def main():
    phn_dic = {"0": "si\nNULA\nsi",
               "1": "si\nJEDNA\nsi",
               "2": "si\nDVA\nsi",
               "3": "si\nTRI\nsi",
               "4": "si\nCTYRI\nsi",
               "5": "si\nPET\nsi",
               "6": "si\nSEST\nsi",
               "7": "si\nSEDM\nsi",
               "8": "si\nOSM\nsi",
               "9": "si\nDEVET\nsi"}

    path = "test_SD/*.wav"
    for filename in glob.glob(path):
        phn_path = re.sub(".wav", '.lab', filename)
        with open(phn_path, 'w', encoding='cp1250') as file:
            file.write(phn_dic[filename[-15]])


if __name__ == "__main__":
    main()
