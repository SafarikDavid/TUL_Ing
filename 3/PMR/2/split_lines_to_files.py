def main():
    idx = 1
    file_name_format = 'data/{num:03}.txt'
    with open('text.txt', 'r', encoding='cp1250') as input_file:
        while line := input_file.readline():
            with open(file_name_format.format(num=idx), 'w', encoding='cp1250') as output_file:
                output_file.write(line.strip())
            idx += 1

    idx = 1
    file_name_format = 'data/{num:03}.phn'
    with open('transcription.txt', 'r', encoding='cp1250') as input_file:
        while line := input_file.readline():
            with open(file_name_format.format(num=idx), 'w', encoding='cp1250') as output_file:
                output_file.write(line.strip())
            idx += 1


if __name__ == "__main__":
    main()
