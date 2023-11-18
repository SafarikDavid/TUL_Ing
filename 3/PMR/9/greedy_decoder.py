import glob
import os.path
import pickle
from itertools import groupby

import numpy as np


def remove_diacritic(text):
    diacritic_dic = {
        'á': 'a', 'č': 'c', 'ď': 'd', 'é': 'e', 'ě': 'e',
        'í': 'i', 'ň': 'n', 'ó': 'o', 'ř': 'r', 'š': 's',
        'ť': 't', 'ú': 'u', 'ů': 'u', 'ý': 'y', 'ž': 'z',
        'Á': 'A', 'Č': 'C', 'Ď': 'D', 'É': 'E', 'Ě': 'E',
        'Í': 'I', 'Ň': 'N', 'Ó': 'O', 'Ř': 'R', 'Š': 'S',
        'Ť': 'T', 'Ú': 'U', 'Ů': 'U', 'Ý': 'Y', 'Ž': 'Z',
    }
    text_without_diacritics = ''.join(diacritic_dic.get(char, char) for char in text)
    return text_without_diacritics


def remove_consecutive_duplicates(input_string):
    result_string = ''.join(k for k, _ in groupby(input_string))
    return result_string


def greedy_decode(path_to_prob):
    char_map = {
        0: ' ',
        1: 'a',
        2: 'á',
        3: 'b',
        4: 'c',
        5: 'č',
        6: 'd',
        7: 'ď',
        8: 'e',
        9: 'é',
        10: 'ě',
        11: 'f',
        12: 'g',
        13: 'h',
        14: 'ch',
        15: 'i',
        16: 'í',
        17: 'j',
        18: 'k',
        19: 'l',
        20: 'm',
        21: 'n',
        22: 'ň',
        23: 'o',
        24: 'ö',
        25: 'ó',
        26: 'p',
        27: 'q',
        28: 'r',
        29: 'ř',
        30: 's',
        31: 'š',
        32: 't',
        33: 'ť',
        34: 'ü',
        35: 'u',
        36: 'ú',
        37: 'ů',
        38: 'v',
        39: 'w',
        40: 'x',
        41: 'y',
        42: 'ý',
        43: 'z',
        44: 'ž',
        45: ''
    }
    decoded = ''
    data = pickle.load(open(path_to_prob, 'rb'))
    for row in data:
        max_index = np.argmax(row)
        decoded += char_map[max_index]
    decoded = remove_consecutive_duplicates(decoded)
    return decoded


def main():
    with open('recout.mlf', 'w') as file:
        file.write('#!MLF!#\n')
        for path in glob.glob('data/**/*.prob', recursive=True):
            decoded_text = remove_diacritic(greedy_decode(path))
            absolute_path = os.path.abspath(path.replace('.prob', '.rec')).replace('\\', '/')
            file.write(f'"{absolute_path}"\n')
            file.write(decoded_text.strip().replace(' ', '\n'))
            file.write('\n.\n')


if __name__ == '__main__':
    main()
