import os
import glob
import re


def main():
    alphabet = ['_']

    with open('alphabet48-CZ.abc', 'r', encoding='cp1250') as alphabet_file:
        alphabet_file.readline()
        while line := alphabet_file.readline():
            alphabet.append(re.sub(" +", " ", line).split(" ")[1])

    chars_to_sil = alphabet[-7:]

    path = "Stanek/**/*.phn"
    for filename in glob.glob(path, recursive=True):
        fullpath_phn = os.path.abspath(filename)
        with open(fullpath_phn, 'r', encoding='cp1250') as phn_file:
            line = phn_file.readline().strip()
            updated_line = ''
            for char in line:
                if char not in alphabet:
                    print(char)
                    print(fullpath_phn)
                if char in chars_to_sil:
                    updated_line += '-'
                else:
                    updated_line += char
        with open(fullpath_phn, 'w', encoding='cp1250') as phn_file:
            phn_file.write(updated_line)


if __name__ == "__main__":
    main()
