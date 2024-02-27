# Solve the problem from the third set here
def greatest_perfect_number_smaller_than_n(n):
    if n <= 6:
        print('A perfect number that is smaller than', n, 'does not exist')
    else:
        perf = 0
        i = 2
        while perf < n:
            perf = (2 ** (i - 1)) * (2 ** i - 1)
            i = i + 1
        i = i - 2
        perf = (2 ** (i - 1)) * (2 ** i - 1)
        return perf


# I used the form perfect_number=(2^(i-1))*(2^i-1)
if __name__ == '__main__':
    n = int(input('n='))
    print(greatest_perfect_number_smaller_than_n(n))
