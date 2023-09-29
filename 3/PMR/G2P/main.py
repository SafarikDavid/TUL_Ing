import re


spodoba_znelosti = {}


def phonetic_rule(rule):
    split_rule = re.split("/", rule)
    split_left_side = re.split("->", re.sub(" ", "", split_rule[0]))
    # condition = re.sub("(<[a-zA-Z, ]*)( )([a-zA-Z, ]*>)", "\1\2", split_rule[1])
    condition = re.sub(" ", "", split_rule[1])
    condition = condition.strip()
    str_from = split_left_side[0]
    str_to = split_left_side[1]
    return str_from, str_to, condition


def apply_rule(text, rule):
    str_from, str_to, condition = phonetic_rule(rule)

    str_from = re.sub(r"-", " ", str_from)
    str_from = re.sub(r",", "", str_from)
    str_from = re.sub(r"<", "[", str_from)
    str_from = re.sub(r">", "]", str_from)

    condition = re.sub(r"-", " ", condition)
    condition = re.sub(r",", "", condition)
    condition = re.sub(r"<", "[", condition)
    condition = re.sub(r">", "]", condition)

    condition_left = re.split(r"_", condition)[0]
    condition_right = re.split(r"_", condition)[1]

    sub_pattern = r"(" + condition_left + ")" + str_from + "(" + condition_right + ")"

    if str_to == "A":
        return text

    return re.sub(sub_pattern, "\\1" + str_to + "\\2", text)


def main():
    text = "chaluha ůpě wolf qantum vykalený výklad běhá pěvec vědec dědic tětiva někdy měnič díra titěra nikdy"

    spodoba_znelosti_raw = ''
    substitutes = {}
    substitutes_raw = []
    rules = []
    # load rules
    with open('pravidla.txt', 'r', encoding="utf-8") as file:
        while line := file.readline():
            if len(line.rstrip()) > 0:
                if line[0] == 'A':
                    spodoba_znelosti_raw = line.rstrip()
                    spodoba_znelosti_raw = spodoba_znelosti_raw.split(":")[1]
                    for sz in spodoba_znelosti_raw.split(','):
                        left, right = sz.split('-')
                        spodoba_znelosti[left] = right
                # append to substitutes if line contains ':'
                elif ":" in line:
                    substitutes_raw.append(line.rstrip())
                # else append to rules
                else:
                    rules.append(line.rstrip())
    # process raw substitutes
    for sub_raw in substitutes_raw:
        left, right = sub_raw.split(":")
        substitutes[left] = right
    for rule in rules:
        for key in substitutes.keys():
            rule = re.sub(key, substitutes[key], rule)
        text = apply_rule(text, rule)
    text = re.sub(' ', '_', text)
    print(text)


if __name__ == '__main__':
    main()
