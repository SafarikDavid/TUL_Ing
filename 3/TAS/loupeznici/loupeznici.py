import random

import numpy as np


def divide_coins(coins):
    total_value = sum(coins)
    target_value = total_value // 2

    # Initialize a table to store intermediate results
    dp = [[False] * (target_value + 1) for _ in range(len(coins) + 1)]

    # Base case: If the target value is 0, then any set of coins is valid
    for i in range(len(coins) + 1):
        dp[i][0] = True

    # Fill the table using dynamic programming
    for i in range(1, len(coins) + 1):
        for j in range(1, target_value + 1):
            dp[i][j] = dp[i - 1][j]
            if j >= coins[i - 1]:
                dp[i][j] = dp[i][j] or dp[i - 1][j - coins[i - 1]]

    # Find the maximum value that can be achieved in the first pile
    max_value_first_pile = 0
    for j in range(target_value, -1, -1):
        if dp[len(coins)][j]:
            max_value_first_pile = j
            break

    # Calculate the values of the two piles
    pile1 = []
    pile2 = []
    i, j = len(coins), max_value_first_pile
    while i > 0 and j > 0:
        if dp[i][j] and not dp[i - 1][j]:
            pile1.append(coins[i - 1])
            j -= coins[i - 1]
        else:
            pile2.append(coins[i - 1])
        i -= 1

    return pile1, pile2


def main():
    # dva loupeznici vykradli automat na napoje kde je koruny hodnoty 1,2,5, chceme je rozdelit rovnomerne
    # chci rozdelit veci na dve hromadky tak, aby byly co nejvic pul napul
    coins = []
    temp_coins = [1] * 1
    coins += temp_coins
    temp_coins = [2] * 1
    coins += temp_coins
    temp_coins = [5] * 1
    coins += temp_coins
    temp_coins = [10] * 1
    coins += temp_coins
    temp_coins = [20] * 1
    coins += temp_coins
    temp_coins = [50] * 7
    coins += temp_coins
    random.shuffle(coins)
    pile1, pile2 = divide_coins(coins)
    if len(coins) != len(pile2) + len(pile1):
        print("Nesedej pocty")
    print(f'Pile 1 is {pile1}\n = {np.sum(pile1)}\nPile 2 is {pile2}\n = {np.sum(pile2)}')
    return


if __name__ == "__main__":
    main()
