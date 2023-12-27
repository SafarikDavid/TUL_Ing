import glob


def main():
    words = []
    for path in glob.glob('*/*.txt'):
        with open(path, 'r', encoding='cp1250') as file:
            while line := file.readline():
                [words.append(word) for word in line.strip().lower().split(' ')]
    words = set(words)
    words.remove('')
    print(words)
    print(len(words))
    with open('dictionary.txt', 'w', encoding='cp1250') as file:
        for word in words:
            file.write(f"{word}\n")


if __name__ == "__main__":
    main()
