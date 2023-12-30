def main():
    end_of_file = "SILENCE si\nSILENCE1 n1\nSILENCE2 n2\nSILENCE3 n3\nSILENCE4 n4\nSILENCE5 n5\n!ENTER si\n!EXIT si\n"

    words_used = []
    max_words = 60000
    words_count = 0
    with open('master_slovnik_en', 'r', encoding='cp1250') as master_slovnik, open('word_list_N', 'w', encoding='cp1250') as word_list, open('dict', 'w', encoding='cp1250') as dict_f:
        word_list.write("!ENTER\n!EXIT\n")
        while (line := master_slovnik.readline()) and (words_count < max_words):
            dict_f.write(line)
            split = line.split(" ")
            word = split[0]
            if word in words_used:
                continue
            word_list.write(word)
            word_list.write('\n')
            words_used.append(word)
            words_count += 1
        dict_f.write(end_of_file)


if __name__ == "__main__":
    main()
