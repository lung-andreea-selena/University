import random


def random_numbers(n):
    list = []
    for i in range(n):
        list.append(random.randint(0, 100))
    return list


def insertion_sort(list, print_step):
    n = len(list)
    step = 0
    ok=0
    for i in range(0, n):
        j = i
        while list[j] < list[j - 1] and j >= 1:
            aux = list[j]
            list[j] = list[j - 1]
            list[j - 1] = aux
            j = j - 1
        step = step + 1
        if ok==0:
            print(list)
            ok=1
            step=0
        else:
            if print_step == step:
                print(list)
                step=0
    return


def gnome_sort(list, print_step):
    i = 0
    step = 0
    ok=0
    n = len(list)
    while i < n:
        if i == 0:
            i = i + 1
        if list[i] >= list[i - 1]:
            i = i + 1
        else:
            aux = list[i]
            list[i] = list[i - 1]
            list[i - 1] = aux
            i = i - 1
            step = step + 1
            if ok == 0:
                print(list)
                ok = 1
                step = 0
            else:
                if print_step == step:
                    print(list)
                    step = 0
    return


if __name__ == '__main__':
    """ n = int(input('n= '))
    list = []
    list = random_numbers(n)
    insertion_sort(list)
    print(list)
    gnome_sort(list)
    print(list)"""
    choice = 1
    n = -1
    print('Welcome to the menu!')
    while choice != 0:
        print('Please enter a number:')
        print('1. Generate a list of n random numbers')
        print('2. Sort the list using the insertion sort')
        print('3. Sort the list using the gnome sort')
        print('0. Exit the menu')
        choice = int(input('Your choice='))
        if choice == 1:
            print('Please enter how many numbers do you want to have in the list')
            n = int(input('n='))
            list = []
            list = random_numbers(n)
            print('Your numbers are:', list)
            print(' ')
        if choice == 2:
            if n == -1:
                print('Please generate the list first')
            else:
                print('Choose after how many steps of sorting you want to see the list')
                step = int(input('step='))
                insertion_sort(list, step)
            print(' ')
        if choice == 3:
            if n == -1:
                print('Please generate the list first')
            else:
                print('Choose after how many steps of sorting you want to see the list')
                step = int(input('step='))
                gnome_sort(list, step)
            print(' ')
        if choice == 0:
            print('Thank you!')
