# Solve the problem from the second set here
def palindrome_of_n(n):
    palindrome = 0
    while n != 0:
        u = int(n % 10)
        palindrome = palindrome * 10 + u
        n = n // 10
    return palindrome


if __name__ == '__main__':
    n = int(input('n='))
    print('Palindrome of',n, 'is',palindrome_of_n(n))
