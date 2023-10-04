import os
import glob
import re


def main():
    phn_dic = {"0": "NULA\n",
               "1": "JEDNA\n",
               "2": "DVA\n",
               "3": "TRI\n",
               "4": "CTYRI\n",
               "5": "PET\n",
               "6": "SEST\n",
               "7": "SEDM\n",
               "8": "OSM\n",
               "9": "DEVET\n"}

    path = "test_SI/**/*.wav"
    for filename in glob.glob(path, recursive=True):
        phn_path = re.sub(".wav", '.lab', filename)
        with open(phn_path, 'w', encoding='cp1250') as file:
            file.write(phn_dic[filename[-15]])


if __name__ == "__main__":
    main()
