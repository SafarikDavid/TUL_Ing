import glob
import re


def main():
    words = []
    with open('dict', 'r', encoding='cp1250') as file:
        while line := file.readline():
            words.append(line.split(' ')[0])
    words.remove("!ENTER")
    words.remove("!EXIT")
    with open('grammar', 'w', encoding='UTF-8') as file:
        file.write('$word = ')
        for word in words[:-1]:
            file.write(f'{word} | ')
        file.write(f'{words[-1]};\n')
        file.write('( !ENTER < $word > !EXIT )')


if __name__ == "__main__":
    main()
