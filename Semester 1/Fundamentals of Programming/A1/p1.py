# Solve the problem from the first set here
def smallest_number_with_same_digits_as_n(n):
    list = []
    while n != 0:
        u = int(n % 10)
        list.append(u)
        n = n // 10
    list.sort()
    m = 0
    p = 1
    for digit in list:
        if digit == 0:
            p = p * 10
            ok = 1
        else:
            if ok == 1:
                m = digit * p
                ok = 0
            else:
                m = m * 10 + digit
    return m


if __name__ == '__main__':
    n = int(input('n= '))
    print('m=', smallest_number_with_same_digits_as_n(n))
