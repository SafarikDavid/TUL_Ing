import glob
import re


def odstran_diakritiku(text):
    diakritika = {
        'á': 'a', 'č': 'c', 'ď': 'd', 'é': 'e', 'ě': 'e',
        'í': 'i', 'ň': 'n', 'ó': 'o', 'ř': 'r', 'š': 's',
        'ť': 't', 'ú': 'u', 'ů': 'u', 'ý': 'y', 'ž': 'z',
        'Á': 'A', 'Č': 'C', 'Ď': 'D', 'É': 'E', 'Ě': 'E',
        'Í': 'I', 'Ň': 'N', 'Ó': 'O', 'Ř': 'R', 'Š': 'S',
        'Ť': 'T', 'Ú': 'U', 'Ů': 'U', 'Ý': 'Y', 'Ž': 'Z',
    }
    text_bez_diakritiky = ''.join(diakritika.get(char, char) for char in text)
    return text_bez_diakritiky


def main():
    conversion_table = {}
    with open("alphabet48-CZ.abc", 'r', encoding='cp1250') as file:
        alphabet_raw = file.readlines()
    alphabet_raw = alphabet_raw[1:]
    for conversion_raw in alphabet_raw:
        split = re.sub(" +", " ", conversion_raw)
        split = split.strip().split(" ")
        conversion_table[split[1]] = split[2]
    print(conversion_table)

    dictionary_words = []
    with open('dictionary.txt', 'r', encoding='cp1250') as file:
        [dictionary_words.append(odstran_diakritiku(line.strip().lower())) for line in file.readlines()]
    print(dictionary_words)

    g2p_words = []
    with open('dictionary_G2P.txt', 'r', encoding='cp1250') as file:
        [g2p_words.append(''.join(conversion_table.get(char, char) + ' ' for char in line.strip()).strip()) for line in
         file.readlines()]
    print(g2p_words)

    with open('dict', 'w', encoding='cp1250') as file:
        for dic_word, g2p_word in zip(dictionary_words, g2p_words):
            file.write(f'{dic_word} {g2p_word}\n')
        file.write("SILENCE si\nSILENCE1 n1\nSILENCE2 n2\nSILENCE3 n3\nSILENCE4 n4\nSILENCE5 n5\n!ENTER si\n!EXIT si")


if __name__ == "__main__":
    main()
