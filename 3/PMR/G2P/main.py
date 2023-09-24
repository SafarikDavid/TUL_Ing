import re


def apply_rule_old(text, str_from, str_to, condition):
    condition_left = re.split("_", condition)[0]
    condition_left = re.sub("-", " ", condition_left)

    condition_right = re.split("_", condition)[1]
    condition_right = re.sub("-", " ", condition_right)
    str_out = ""
    from_len = len(str_from)
    for i in range(0, len(text)):
        if text[i:i + from_len] != str_from:
            str_out += text[i]
            continue
        if len(condition_left) <= 0 and len(condition_right) <= 0:
            str_out += str_to
            continue
    return str_out


def phonetic_rule(rule):
    split_rule = re.split("/", rule)
    split_left_side = re.split("→", re.sub(" ", "", split_rule[0]))
    condition = re.sub(" ", "", split_rule[1])
    str_from = split_left_side[0]
    str_to = split_left_side[1]
    return str_from, str_to, condition


def apply_rule(text, str_from, str_to, condition):
    condition = re.sub(r"-", " ", condition)
    condition = re.sub(r",", "", condition)
    condition = re.sub(r"<", "[", condition)
    condition = re.sub(r">", "]", condition)

    condition_left = re.split(r"_", condition)[0]
    condition_right = re.split(r"_", condition)[1]

    sub_pattern = r"("+condition_left+")"+str_from+"("+condition_right+")"

    return re.sub(sub_pattern, "\\1"+str_to+"\\2", text)


def main():
    rule = "ch → X / <a,e,i,o,u>_"
    text = "chichi chi ch i ch ich"
    from_regex, to_regex, condition = phonetic_rule(rule)
    print(apply_rule(text, from_regex, to_regex, condition))


if __name__ == '__main__':
    main()
