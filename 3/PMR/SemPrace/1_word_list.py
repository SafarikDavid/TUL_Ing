import re


def remove_non_czech_diacritic(text):
    diacritic_dic = {
        'ü': 'u', 'Ü': 'U', 'ä': 'a', 'Ä': 'A', 'ö': 'o',
        'Ö': 'O', 'ß': 'ss', 'ł': 'l', 'ń': 'n', 'ę': 'e',
        'ś': 's', 'ć': 'c', 'ź': 'z', 'ż': 'z', 'ą': 'a',
    }
    text_without_diacritics = ''.join(diacritic_dic.get(char, char) for char in text)
    return text_without_diacritics


def main():
    text = ""
    word_rates = {}
    n_words = 0
    with open("train_text_korpus.txt", 'r', encoding="cp1250") as file:
        while line := file.readline():
            line = line.replace("\n", "").lower().strip()
            line = re.sub(r" +", " ", line)
            line = re.sub("=", "rovná se", line)
            if len(line) < 1:
                continue
            line = remove_non_czech_diacritic(line)
            split = line.split(" ")
            text += line
            for word in split:
                n_words += 1
                if word not in word_rates.keys():
                    word_rates[word] = 1
                else:
                    word_rates[word] += 1
    sorted_word_rates = dict(sorted(word_rates.items(), key=lambda x: x[1], reverse=True))
    with open("word_list", 'w', encoding="cp1250") as file:
        for word in sorted_word_rates.keys():
            file.write(word)
            file.write('\n')


if __name__ == "__main__":
    main()
