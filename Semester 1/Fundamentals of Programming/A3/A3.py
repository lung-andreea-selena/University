import random
import timeit
from texttable import Texttable
def random_numbers(n):
    list = []
    for i in range(n):
        list.append(random.randint(0, 100))
    return list


def insertion_sort(list):
    n = len(list)
    for i in range(0, n):
        j = i
        while list[j] < list[j - 1] and j >= 1:
            aux = list[j]
            list[j] = list[j - 1]
            list[j - 1] = aux
            j = j - 1
    return list

def sort_worst(list):
    n = len(list)
    for i in range(0, n):
        j = i
        while list[j] > list[j - 1] and j >= 1:
            aux = list[j]
            list[j] = list[j - 1]
            list[j - 1] = aux
            j = j - 1
    return list

def worst_case_ins(list):
    worst=[]
    worst=sort_worst(list)
    t1=timeit.default_timer()
    insertion_sort(worst)
    t2=timeit.default_timer()
    execution_time=t2-t1
    return execution_time

def average_case_ins(list):
    t1=timeit.default_timer()
    insertion_sort(list)
    t2=timeit.default_timer()
    execution_time=t2-t1
    return execution_time

def best_case_ins(list):
    best = []
    best = sort_best(list)
    t1 = timeit.default_timer()
    insertion_sort(best)
    t2 = timeit.default_timer()
    execution_time = t2 - t1
    return execution_time

def sort_best(list):
    n = len(list)
    for i in range(0, n):
        j = i
        while list[j] < list[j - 1] and j >= 1:
            aux = list[j]
            list[j] = list[j - 1]
            list[j - 1] = aux
            j = j - 1
    return list

def gnome_sort(list):
    i = 0
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
    return list
def worst_case_gnome(list):
    worst=[]
    worst=sort_worst(list)
    t1=timeit.default_timer()
    gnome_sort(worst)
    t2=timeit.default_timer()
    execution_time=t2-t1
    return execution_time

def average_case_gnome(list):
    t1=timeit.default_timer()
    gnome_sort(list)
    t2=timeit.default_timer()
    execution_time=t2-t1
    return execution_time

def best_case_gnome(list):
    best = []
    best = sort_best(list)
    t1 = timeit.default_timer()
    gnome_sort(best)
    t2 = timeit.default_timer()
    execution_time = t2 - t1
    return execution_time

def build_result_table_ins():
    table = Texttable()
    table.add_row(['Length', 'Worst Case', 'Best Case', 'Average Case'])
    for term in [500, 1000, 2000, 4000, 8000]:
        start_worst = timeit.default_timer()
        insertion_sort(worst_case_ins(term))
        end_worst = timeit.default_timer()
        start_best = timeit.default_timer()
        insertion_sort(best_case_ins(term))
        end_best = timeit.default_timer()
        start_average = timeit.default_timer()
        insertion_sort(average_case_ins(term))
        end_average = timeit.default_timer()
        table.add_row([term, end_worst - start_worst,end_best - start_best,end_average - start_average])
    return table
def build_result_table_gnome():
    table = Texttable()
    table.add_row(['Length', 'Worst Case', 'Best Case', 'Average Case'])
    for term in [500, 1000, 2000, 4000, 8000]:
        start_worst = timeit.default_timer()
        gnome_sort(worst_case_gnome(term))
        end_worst = timeit.default_timer()
        start_best = timeit.default_timer()
        gnome_sort(best_case_gnome(term))
        end_best = timeit.default_timer()
        start_average = timeit.default_timer()
        gnome_sort(average_case_gnome(term))
        end_average = timeit.default_timer()
        table.add_row([term, end_worst - start_worst,end_best - start_best,end_average - start_average])
    return table

if __name__ == '__main__':
    choice = 1
    n = -1
    print('Welcome to the menu!')
    while choice != 0:
        print('Please enter a number:')
        print('1. Generate a list of n random numbers')
        print('2. Sort the list using the insertion sort')
        print('3. Sort the list using the gnome sort')
        print('4. Show the tables')
        print('0. Exit the menu')
        choice = int(input('Your choice='))
        if choice == 1:
            print('Please choose how many numbers will have the input list')
            n = int(input('n='))
            list = []
            list = random_numbers(n)
            list_second=[]
            list_second=random_numbers(2*n)
            list_third=[]
            list_third=random_numbers(4*n)
            list_fourth=[]
            list_fourth=random_numbers(8*n)
            list_fifth=[]
            list_fifth=random_numbers(16*n)
        if choice == 2:
            if n == -1:
                print('Please generate the list first')
            else:
                print('Choose of which case you want to see the complexity')
                print('1. Worst case')
                print('2. Average case')
                print('3. Best case')
                second_choice=(int(input('Your choice of complexity=')))
                if second_choice==1:
                    ex_time=worst_case_ins(list)
                    print('For',n,'numbers in list the time is ',ex_time)
                    ex_time=worst_case_ins(list_second)
                    print('For', 2*n, 'numbers in list the time is ', ex_time)
                    ex_time=worst_case_ins(list_third)
                    print('For', 4 * n, 'numbers in list the time is ', ex_time)
                    ex_time=worst_case_ins(list_fourth)
                    print('For', 8 * n, 'numbers in list the time is ', ex_time)
                    ex_time=worst_case_ins(list_fifth)
                    print('For', 16 * n, 'numbers in list the time is ', ex_time)

                if second_choice==2:
                    ex_time=average_case_ins(list)
                    print('For', n, 'numbers in list the time is ', ex_time)
                    ex_time=average_case_ins(list_second)
                    print('For', 2 * n, 'numbers in list the time is ', ex_time)
                    ex_time=average_case_ins(list_third)
                    print('For', 4 * n, 'numbers in list the time is ', ex_time)
                    ex_time=average_case_ins(list_fourth)
                    print('For', 8 * n, 'numbers in list the time is ', ex_time)
                    ex_time=average_case_ins(list_fifth)
                    print('For', 16 * n, 'numbers in list the time is ', ex_time)

                if second_choice==3:
                    ex_time = best_case_ins(list)
                    print('For', n, 'numbers in list the time is ', ex_time)
                    ex_time = best_case_ins(list_second)
                    print('For', 2 * n, 'numbers in list the time is ', ex_time)
                    ex_time = best_case_ins(list_third)
                    print('For', 4 * n, 'numbers in list the time is ', ex_time)
                    ex_time = best_case_ins(list_fourth)
                    print('For', 8 * n, 'numbers in list the time is ', ex_time)
                    ex_time = best_case_ins(list_fifth)
                    print('For', 16 * n, 'numbers in list the time is ', ex_time)
            print(' ')
        if choice == 3:
            if n == -1:
                print('Please generate the list first')
            else:
                print('Choose of which case you want to see the complexity')
                print('1. Worst case')
                print('2. Average case')
                print('3. Best case')
                second_choice = (int(input('Your choice of complexity=')))
                if second_choice == 1:
                    ex_time = worst_case_gnome(list)
                    print('For', n, 'numbers in list the time is ', ex_time)
                    ex_time = worst_case_gnome(list_second)
                    print('For', 2 * n, 'numbers in list the time is ', ex_time)
                    ex_time = worst_case_gnome(list_third)
                    print('For', 4 * n, 'numbers in list the time is ', ex_time)
                    ex_time = worst_case_gnome(list_fourth)
                    print('For', 8 * n, 'numbers in list the time is ', ex_time)
                    ex_time = worst_case_gnome(list_fifth)
                    print('For', 16 * n, 'numbers in list the time is ', ex_time)

                if second_choice == 2:
                    ex_time = average_case_gnome(list)
                    print('For', n, 'numbers in list the time is ', ex_time)
                    ex_time = average_case_gnome(list_second)
                    print('For', 2 * n, 'numbers in list the time is ', ex_time)
                    ex_time = average_case_gnome(list_third)
                    print('For', 4 * n, 'numbers in list the time is ', ex_time)
                    ex_time = average_case_gnome(list_fourth)
                    print('For', 8 * n, 'numbers in list the time is ', ex_time)
                    ex_time = average_case_gnome(list_fifth)
                    print('For', 16 * n, 'numbers in list the time is ', ex_time)
                if second_choice == 3:
                    ex_time = best_case_gnome(list)
                    print('For', n, 'numbers in list the time is ', ex_time)
                    ex_time = best_case_gnome(list_second)
                    print('For', 2 * n, 'numbers in list the time is ', ex_time)
                    ex_time = best_case_gnome(list_third)
                    print('For', 4 * n, 'numbers in list the time is ', ex_time)
                    ex_time = best_case_gnome(list_fourth)
                    print('For', 8 * n, 'numbers in list the time is ', ex_time)
                    ex_time = best_case_gnome(list_fifth)
                    print('For', 16 * n, 'numbers in list the time is ', ex_time)
        print(' ')
        if choice==4:
            print('Insertion sort')
            print(build_result_table_ins().draw())
            print(' ')
            print('Gnome sort')
            print('Gnome sort')
            print(build_result_table_gnome().draw())
        if choice == 0:
            print('Thank you!')