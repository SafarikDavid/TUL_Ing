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
    labs_idx = 0
    with open("korpus_new.txt", 'r', encoding='cp1250') as input_f, open('labs', 'w', encoding='cp1250') as labs:
        labs.write("#!MLF!#\n")
        while line := input_f.readline():
            line = line.replace("\n", "").lower().strip()
            line = re.sub(r" +", " ", line)
            line = re.sub("=", "rovná se", line)
            line = remove_diacritic(line)
            if len(line) < 1:
                continue
            split = line.split(" ")
            labs.write(f'"{labs_idx}.lab"\n')
            for word in split:
                labs.write(word)
                labs.write('\n')
            labs.write('.\n')
            labs_idx += 1


if __name__ == "__main__":
    main()
