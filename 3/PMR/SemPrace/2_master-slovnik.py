def main():
    with open('master-slovnik', 'w', encoding='cp1250') as master_slovnik, open('word_list', 'r', encoding='cp1250') as word_list, open('transcription', 'r', encoding='cp1250') as transcription:
        while True:
            word = word_list.readline().replace('\n', '')
            trans = transcription.readline().replace('\n', '')
            if word == '' or trans == '':
                break
            master_slovnik.write(f"{word} {trans}\n")


if __name__ == "__main__":
    main()
