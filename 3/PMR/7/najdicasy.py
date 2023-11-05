import numpy as np


def convert_to_minutes_seconds(tim):
    seconds = float(tim) * pow(10, -7)
    minutes = np.floor(seconds/60)
    seconds = np.round(seconds % 60)
    return int(minutes), int(seconds)


minutes_modifier = -4
with open('HTK/recout.mlf', 'r') as file:
    while line := file.readline():
        if line.strip() == "#!MLF!#":
            continue
        if line[0] == '"':
            minutes_modifier += 4
            continue
        if line[0] == ".":
            continue
        line_split = line.split(" ")
        if line_split[2] in ["PREZIDENT", "KOMENTATOR"]:
            min_start, sec_start = convert_to_minutes_seconds(line_split[0])
            min_start += minutes_modifier
            min_end, sec_end = convert_to_minutes_seconds(line_split[1])
            min_end += minutes_modifier
            print(f"{min_start:02d}:{sec_start:02d} - {min_end:02d}:{sec_end:02d} {line_split[2]}")

