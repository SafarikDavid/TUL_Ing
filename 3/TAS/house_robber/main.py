def rob(nums):
    n = len(nums)

    # Base cases
    if n == 0:
        return 0, []

    elif n == 1:
        return nums[0], [0]

    # Initialize an array to store the maximum amount of money that can be robbed at each house
    dp = [0] * n

    # Initialize an array to store the indices of the robbed houses
    rob_indices = []

    # The maximum amount of money that can be robbed at the first house is the money in the first house
    dp[0] = nums[0]
    rob_indices.append(0)

    # The maximum amount of money that can be robbed at the second house is the maximum of the money in the first and second houses
    dp[1] = max(nums[0], nums[1])
    if dp[1] == nums[1]:
        rob_indices.append(1)

    # Iterate from the third house onwards
    for i in range(2, n):
        # The maximum amount of money that can be robbed at the current house is the maximum of the money in the current house plus the money two houses before
        # or the maximum amount of money robbed at the previous house
        if nums[i] + dp[i - 2] > dp[i - 1]:
            dp[i] = nums[i] + dp[i - 2]
            rob_indices.append(i)
        else:
            dp[i] = dp[i - 1]

    # The final answer is the maximum amount of money that can be robbed at the last house and the indices of the robbed houses
    return dp[n - 1], rob_indices


def main():
    # right answer in 127
    # musi bejt jeste vratit ktery domy ukrast
    # vede to na rekurzi
    house_values = [5, 7, 9, 1, 10, 100, 101, 13]
    value, house_numbers = rob(house_values)
    print(f'Max number to rob is {value}')
    print(f'Houses to rob are {house_numbers}')


if __name__ == '__main__':
    main()
