import re


def main():
    with open('sentences_bez_dia', 'r', encoding='cp1250') as sentences:
        idx = 1
        while line := sentences.readline():
            txt_path = f'Spojovatelka/spojovatelka-{idx:02}.lab'
            line = re.sub("[.]", '', line)
            line = line.upper()
            line = re.sub(' ', '\n', line)
            with open(txt_path, 'w', encoding='cp1250') as file_lab:
                file_lab.write(line)
            idx += 1


if __name__ == "__main__":
    main()
