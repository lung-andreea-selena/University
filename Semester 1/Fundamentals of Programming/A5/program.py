#
# Write the implementation for A5 in this file
#


#
# Write below this comment 
# Functions to deal with complex numbers -- list representation
# -> There should be no print or input statements in this section 
# -> Each function should do one thing only
# -> Functions communicate using input parameters and their return values


def list_real(list_complex):
    list_real = []
    for i in range(0, len(list_complex)):
        r = get_real(list_complex[i])
        list_real.append(r)
    return list_real


def list_img(list_complex):
    list_img = []
    for i in range(0, len(list_complex)):
        img = get_imaginary(list_complex[i])
        list_img.append(img)
    return list_img


def turn_into_big_list(list_of_list):
    listt = []
    for i in list_of_list:
        listt.append(i[0])
        listt.append(i[1])
    return listt


def from_big_list_to_list_of_lists(listt):
    complex_nr_list = []
    for i in range(0, len(listt) - 1, 2):
        r = listt[i]
        img = listt[i + 1]
        z = create_complex_number(r, img)
        complex_nr_list.append(z)
    return complex_nr_list


def set_A(list_complex):
    listr = list_real(list_complex)
    listi = list_img(list_complex)
    lmax = 1
    start = 1
    end = 1
    n = len(list_complex)
    for i in range(0, n - 1):
        l = 1
        for j in range(i + 1, n):
            if listr[i] == listr[j] and listi[i] == listi[j]:
                if lmax < l:
                    lmax = l
                    start = i
                    end = j - 1
                break
            else:
                l = l + 1
    list_print = []
    for i in range(start, end + 1):
        list_p = []
        list_p.append(listr[i])
        list_p.append(listi[i])
        list_print.append(list_p)
    return list_print


def set_B(list_complex):
    listr = list_real(list_complex)
    size = len(listr)
    max_so_far = -1000
    max_ending_here = 0
    start = 0
    end = 0
    s = 0
    for i in range(0, size):
        max_ending_here += listr[i]
        if max_so_far < max_ending_here:
            max_so_far = max_ending_here
            start = s
            end = i
        if max_ending_here < 0:
            max_ending_here = 0
            s = i + 1
    list_print = []
    for i in range(start, end + 1):
        list_print.append(listr[i])
    return list_print


#
# Write below this comment 
# Functions to deal with complex numbers -- dict representation
# -> There should be no print or input statements in this section 
# -> Each function should do one thing only
# -> Functions communicate using input parameters and their return values
#

def dictionaries_with_complex_numbers(listcomplex):
    list_dic = []
    for i in range(0, len(listcomplex)):
        z = dict(real=get_real(listcomplex[i]), imaginary=get_imaginary(listcomplex[i]))
        list_dic.append(z)
    return list_dic


def real_numbers_from_dic(list_dic):
    list_r = []
    for i in range(0, len(list_dic)):
        z = list_dic[i]
        list_r.append(z.get('real'))
    return list_r


def imaginary_numbers_from_dic(list_dic):
    list_i = []
    for i in range(0, len(list_dic)):
        z = list_dic[i]
        list_i.append(z.get('imaginary'))
    return list_i


def set_A_dic(list_dic):
    listr = real_numbers_from_dic(list_dic)
    listi = imaginary_numbers_from_dic(list_dic)
    lmax = 1
    start = 1
    end = 1
    n = len(list_dic)
    for i in range(0, n - 1):
        l = 1
        for j in range(i + 1, n):
            if listr[i] == listr[j] and listi[i] == listi[j]:
                if lmax < l:
                    lmax = l
                    start = i
                    end = j - 1
                break
            else:
                l = l + 1
    list_print = []
    for i in range(start, end + 1):
        list_p = []
        list_p.append(listr[i])
        list_p.append(listi[i])
        list_print.append(list_p)
    return list_print


def set_B_dic(list_dic):
    listr = real_numbers_from_dic(list_dic)
    size = len(listr)
    max_so_far = -1000
    max_ending_here = 0
    start = 0
    end = 0
    s = 0
    for i in range(0, size):
        max_ending_here += listr[i]
        if max_so_far < max_ending_here:
            max_so_far = max_ending_here
            start = s
            end = i
        if max_ending_here < 0:
            max_ending_here = 0
            s = i + 1
    list_print = []
    for i in range(start, end + 1):
        list_print.append(listr[i])
    return list_print


#
# Write below this comment 
# Functions that deal with subarray/subsequence properties
# -> There should be no print or input statements in this section 
# -> Each function should do one thing only
# -> Functions communicate using input parameters and their return values
#
def create_complex_number(real, imaginary):
    z = [real, imaginary]
    return z


def get_real(z):
    return z[0]


def get_imaginary(z):
    return z[1]


def set_real(z, real):
    z[0] = real


def set_imaginary(z, imaginary):
    z[1] = imaginary


def convert_to_string(z):
    real = get_real(z)
    imaginary = get_imaginary(z)
    s = f'{real}'
    if imaginary != 0:
        s = s + f' + {imaginary}i'
    return s


# Write below this comment
# UI section
# Write all functions that have input or print statements here
# Ideally, this section should not contain any calculations relevant to program functionalities
#


def already_generated_complex_numbers():
    complex_nr_list = [2, 3, -8, 5, 2, 3, -7, 9, 6, 3, 7, 2, 6, 8, 2, 3, 4, 2, 4, 9]
    return complex_nr_list


def read_list():
    complex_nr_list = []
    n = int(input("The number of elements is: "))
    for i in range(n):
        r = int(input("Real part: "))
        img = int(input("Imaginary part: "))
        z = create_complex_number(r, img)
        complex_nr_list.append(z)
    return complex_nr_list


if __name__ == "__main__":
    choice = 1
    print("Hello and welcome to the menu!")
    while choice != 0:
        print('Please enter a number:')
        print('1. Enter n complex numbers (in z = a + bi)')
        print('2. Work with the already introduced complex numbers')
        print('3. Work with complex numbers using lists')
        print('4. Work with complex numbers using dictionaries')
        print('5. Display the entire list of numbers')
        print('6. Display the length and elements of the longest subarray of distinct numbers')
        print("7. The length and elements of a maximum subarray sum, when considering each number's real part")
        print('0. Exit the menu')
        choice = int(input('Your choice='))
        if choice == 1:
            list1 = read_list()
            c = 1
        if choice == 2:
            list_two = already_generated_complex_numbers()
            list2 = from_big_list_to_list_of_lists(list_two)
            c = 2
        if choice == 3:
            a = 3
            print(
                'You will work with complex numbers using lists. Now choose what you want to do with them by choosing option 5,6 or 7')
        if choice == 4:
            a = 4
            print(
                'You will work with complex numbers using dictionaries. Now choose what you want to do with them by choosing option 5,6 or 7')
        if choice == 5:
            if c == 2:
                for i in range(0, len(list2)):
                    s = convert_to_string(list2[i])
                    print(s)
            if c == 1:
                for i in range(0, len(list1)):
                    s = convert_to_string(list1[i])
                    print(s)
        if choice == 6:
            if c == 2 and a == 3:
                list_print = set_A(list2)
                print('The length of the longest subarray is:', len(list_print))
                print('The elements are:', list_print)
            if c == 1 and a == 3:
                list_print = set_A(list1)
                print('The length of the longest subarray is:', len(list_print))
                print('The elements are:', list_print)
            if c == 2 and a == 4:
                ld = dictionaries_with_complex_numbers(list2)
                list_print_dic = set_A_dic(ld)
                print('The length of the longest subarray is:', len(list_print_dic))
                print('The elements are:', list_print_dic)
            if c == 1 and a == 4:
                ld = dictionaries_with_complex_numbers(list1)
                list_print_dic = set_A_dic(ld)
                print('The length of the longest subarray is:', len(list_print_dic))
                print('The elements are:', list_print_dic)

        if choice == 7:
            if c == 2 and a == 3:
                list_printb = set_B(list2)
                print('The length is:', len(list_printb))
                print('The elements of the real parts are', list_printb)
            if c == 1 and a == 3:
                list_printb = set_B(list1)
                print('The length is:', len(list_printb))
                print('The elements of the real parts are', list_printb)
            if c == 2 and a == 4:
                lb = dictionaries_with_complex_numbers(list2)
                list_print_dic_b = set_B_dic(lb)
                print('The length is:', len(list_print_dic_b))
                print('The elements of the real parts are', list_print_dic_b)
            if c == 1 and a == 4:
                lb = dictionaries_with_complex_numbers(list1)
                list_print_dic_b = set_B_dic(lb)
                print('The length is:', len(list_print_dic_b))
                print('The elements of the real parts are', list_print_dic_b)
