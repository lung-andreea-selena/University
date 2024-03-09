def cutting_rod(price, n):
    val = [0 for x in range(n + 1)]
    val[0] = 0

    for i in range(1, n + 1):
        max_val = -1
        for j in range(i):
            max_val = max(max_val, price[j] + val[i - j - 1])
        val[i] = max_val

    return val[n]

if __name__ == '__main__':
    print("Please enter the lenght of the rod")
    n = int(input("n="))
    prices = []
    print("Please enter the price for every lenght")
    for i in range(0, n):
        p = int(input("p="))
        prices.append(p)
    print("Maximum profit is " + str(cutting_rod(prices, n)))
