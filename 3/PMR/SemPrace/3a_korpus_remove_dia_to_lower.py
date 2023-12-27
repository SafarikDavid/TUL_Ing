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
    with open('train_text_korpus.txt', 'r', encoding='cp1250') as korpus, open('korpus_new.txt', 'w', encoding='cp1250') as korpus_new:
        while line := korpus.readline():
            line = line.replace("\n", "").lower().strip()
            line = re.sub(r" +", " ", line)
            line = re.sub("=", "rovná se", line)
            line = remove_diacritic(line)
            korpus_new.write(line)
            korpus_new.write('\n')


if __name__ == "__main__":
    main()
