def main():
    with open('sentences', 'r', encoding='cp1250') as sentences:
        idx = 1
        while line := sentences.readline():
            txt_path = f'Spojovatelka/spojovatelka-{idx:02}.txt'
            with open(txt_path, 'w', encoding='cp1250') as file_txt:
                file_txt.write(line)
            idx += 1


if __name__ == "__main__":
    main()
