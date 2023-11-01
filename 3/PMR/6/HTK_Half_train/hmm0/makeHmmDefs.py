import os
import glob
import re


def main():
    with open("names", 'r', encoding="utf-8") as file:
        names = [name.strip() for name in file.readlines()]
    with open("proto-1s-39f", 'r') as file:
        proto_text = file.read()
    with open("hmmdefs", 'w') as file:
        for name in names:
            file.write(re.sub("proto-1s-39f", name, proto_text))

if __name__ == "__main__":
    main()
