import re


def remove_diacritic(text):
    diacritic_dic = {
        'á': 'a', 'č': 'c', 'ď': 'd', 'é': 'e', 'ě': 'e',
        'í': 'i', 'ň': 'n', 'ó': 'o', 'ř': 'r', 'š': 's',
        'ť': 't', 'ú': 'u', 'ů': 'u', 'ý': 'y', 'ž': 'z',
        'Á': 'A', 'Č': 'C', 'Ď': 'D', 'É': 'E', 'Ě': 'E',
        'Í': 'I', 'Ň': 'N', 'Ó': 'O', 'Ř': 'R', 'Š': 'S',
        'Ť': 'T', 'Ú': 'U', 'Ů': 'U', 'Ý': 'Y', 'Ž': 'Z',
        'ü': 'u', 'Ü': 'U', 'ä': 'a', 'Ä': 'A', 'ö': 'o',
        'Ö': 'O', 'ß': 'ss', 'ł': 'l', 'ń': 'n', 'ę': 'e',
        'ś': 's', 'ć': 'c', 'ź': 'z', 'ż': 'z', 'ą': 'a',
        '&': 'a', 'ľ': 'l', ';': '', 'ç': 's',
    }
    text_without_diacritics = ''.join(diacritic_dic.get(char, char) for char in text)
    return text_without_diacritics


def main():
    conversion_table = {}
    with open("alphabet48-CZ.abc", 'r', encoding='cp1250') as file:
        alphabet_raw = file.readlines()
    alphabet_raw = alphabet_raw[1:]
    for conversion_raw in alphabet_raw:
        split = re.sub(" +", " ", conversion_raw)
        split = split.strip().split(" ")
        conversion_table[split[1]] = split[2]

    with open('master-slovnik', 'r', encoding='cp1250') as ms_cz, open('master_slovnik_en', 'w', encoding='cp1250') as ms_en:
        while line := ms_cz.readline():
            split = line.split(" ")
            graphem = split[0]
            phone = split[1].strip()
            graphem = remove_diacritic(graphem.lower().strip())
            ms_en.write(graphem + ' ')
            for character in phone:
                conversion_to = conversion_table.get(character)
                if conversion_to is None:
                    ms_en.write(character + ' ')
                else:
                    ms_en.write(conversion_to + ' ')
            ms_en.write('\n')


if __name__ == "__main__":
    main()
