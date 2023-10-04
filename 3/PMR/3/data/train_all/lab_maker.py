import glob
import re


def main():
    conversion_table = {}
    with open("alphabet48-CZ.abc", 'r', encoding='cp1250') as file:
        alphabet_raw = file.readlines()
    alphabet_raw = alphabet_raw[1:]
    for conversion_raw in alphabet_raw:
        split = re.sub(" +", " ", conversion_raw)
        split = split.strip().split(" ")
        conversion_table[split[1]] = split[2]

    phn_files_paths = glob.glob('Svarovsky/*.phn')
    for phn_file_path in phn_files_paths:
        text_out = []
        with open(phn_file_path, 'r', encoding='cp1250') as file:
            text = file.readline()
        text = re.sub("[_\n]", '', text)
        lab_file_path = re.sub('.phn', '.lab', phn_file_path)
        with open(lab_file_path, 'w', encoding='cp1250') as file:
            for char in text:
                conversion_to = conversion_table.get(char)
                if conversion_to is None:
                    file.write('0 0 ' + char + '\n')
                else:
                    file.write('0 0 ' + conversion_to + '\n')


if __name__ == "__main__":
    main()
