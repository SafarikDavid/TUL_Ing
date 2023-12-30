import re


def main():
    test_words = []
    with open("HTK60/testref.mlf", 'r', encoding='cp1250') as test_MLF:
        _ = test_MLF.readline()
        while line := test_MLF.readline():
            if ("." in line) or ('"' in line):
                continue
            test_words.append(line.strip())
    test_words = set(test_words)
    train_words = []
    with open("word_list_N", 'r', encoding='cp1250') as word_list:
        while line := word_list.readline():
            if ("!ENTER" in line) or ("!EXIT" in line):
                continue
            train_words.append(line.strip())
    train_words = set(train_words)
    recognized_words = []
    with open("HTK60/recout.mlf", 'r', encoding='cp1250') as recout:
        _ = recout.readline()
        while line := recout.readline():
            if (line[0] == ".") or ('"' in line):
                continue
            split = line.split(" ")
            word = split[2]
            if word.isupper() or "!" in word:
                continue
            recognized_words.append(word.strip())
    recognized_words = set(recognized_words)
    print(100 * (1 - len(test_words.intersection(recognized_words)) / len(test_words)))
    print(100 * (1 - len(test_words.intersection(train_words)) / len(test_words)))


if __name__ == "__main__":
    main()
