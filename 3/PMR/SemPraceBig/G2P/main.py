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

    if str_to == "A":
        # copy of text
        out = text[:]
        for letter in str_from:
            sub_pattern = r"(" + condition_left + ")" + letter + "(" + condition_right + ")"
            letter_change = spodoba_znelosti.get(letter)
            if letter_change is None: continue
            out = re.sub(sub_pattern, "\\1" + letter_change + "\\2", out)
        return out

    sub_pattern = r"(" + condition_left + ")" + str_from + "(" + condition_right + ")"

    return re.sub(sub_pattern, "\\1" + str_to + "\\2", text)


def main():
    # text = ("chaluha ůpě wolf qantum vykalený výklad běhá pěvec vědec dědic tětiva někdy měnič díra titěra nikdy kresba pětset xavier marie mariji biologie hrad vůz Radka drozd"
    #         " kresba kdo leckde keř břicho tři přímo pařba \n gong banka tramvaj nymfa triumf amfóra emvej \n "
    #         "pět set větší beskydský mladší podzemí ledzkde kamikadze džordž lodžije džungle")
    # text = 'Spolek byl založen devatenáctého listopadu roku devatenáct set třicet dva'
    # text = 'Sejdeme se v naší restauraci ve čtvrt na sedm večer'
    # text = 'Kdy dnes odjíždí poslední vlak nebo autobus z Liberce do Pardubic'
    # text = 'Na konferenci senátor rovněž kritizoval současné právní prostředí'
    # text = 'Výkon brankáře znamenal pro hokejové družstvo dobré umístění v tabulce'
    # text = 'Dnes bude oblačno až polojasno, místy možno očekávat přeháňky'
    # text = 'Najdeš to ve zdrojovém kódu HTML, stačí hledat řetězec mp3'

    short_sentences = {}

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

    transcription = []
    text_arr = []
    with open('text.txt', 'r', encoding='cp1250') as file:
        while line := file.readline():
            text_arr.append(line)
    sentence_idx = 1
    for line in text_arr:
        text = line[:]
        text = text.strip()
        text = text.lower()
        text = ' ' + text + ' '
        text = re.sub('[,.]', '', text)

        if len(re. findall(r'\w+', text)) < 10:
            short_sentences[sentence_idx] = text
        sentence_idx += 1

        for rule in rules:
            for key in substitutes.keys():
                rule = re.sub(key, substitutes[key], rule)
            text = apply_rule(text, rule)
        text = re.sub(' ', '_', text)
        text = text.strip()
        text = text.strip('_')
        # text = '-' + text + '-'
        transcription.append(text)
        # print(text)
    with open('transcription.txt', 'w', encoding='cp1250') as file:
        for line in transcription:
            file.write(line)
            file.write('\n')
    print(short_sentences)


if __name__ == '__main__':
    main()
