import glob
import re


def main():
    conversion_table = {}
    with open("alphabet48-CZ.abc", 'r', encoding='cp1250') as file_phn:
        alphabet_raw = file_phn.readlines()
    alphabet_raw = alphabet_raw[1:]
    for conversion_raw in alphabet_raw:
        split = re.sub(" +", " ", conversion_raw)
        split = split.strip().split(" ")
        conversion_table[split[1]] = split[2]

    phn_file_path = 'phonetics'
    lab_file_path = "labatics"
    text_out = []
    with open(phn_file_path, 'r', encoding='cp1250') as file_phn:
        with open(lab_file_path, 'w', encoding='cp1250') as file_lab:
            while text := file_phn.readline():
                text = re.sub("[_\n]", '', text)
                for idx, char in enumerate(text):
                    conversion_to = conversion_table.get(char)
                    if conversion_to is None:
                        file_lab.write(char)
                    else:
                        file_lab.write(conversion_to)
                    if idx >= len(text)-1:
                        file_lab.write('')
                    else:
                        file_lab.write(' ')
                file_lab.write("\n")


if __name__ == "__main__":
    main()
