#A naive solution to this problem is to generate all configurations of different pieces and find
# the highest-priced configuration. This solution is exponential in terms of time complexity.
def cutting_rod(prices, n):
    if n == 0:
        return 0
    result = -1
    for i in range(0, n):
        result = max(result, prices[i] + cutting_rod(prices, n - i -1))
    return result


if __name__ == '__main__':
    print("Please enter the lenght of the rod")
    n = int(input("n="))
    prices = []
    print("Please enter the price for every lenght")
    for i in range(0, n):
        p = int(input("p="))
        prices.append(p)
    print("Maximum profit is " + str(cutting_rod(prices, n)))
