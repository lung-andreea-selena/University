#
# This is the program's UI module. The user interface and all interaction with the user (print and input statements) are found here
#
import functions
import copy


def possible_commands():
    print('Possible commands are:')
    print('* add <apartment> <type> <amount>')
    print('* remove <apartment>')
    print('* remove <start apartment> to <end apartment>')
    print('* remove <type>')
    print('* replace <apartment> <type> with <amount>')
    print('* list')
    print('* list < <amount>')
    print('* list = <amount>')
    print('* list > <amount>')
    print('* filter <type>')
    print('* filter <value>')
    print('* undo')
    print('* exit')


def main():
    functions.test_add_expenses()
    functions.test_remove_all_expenses()
    list_of_apartments = functions.list_of_apartments()
    list_for_undo = copy.deepcopy(list_of_apartments)
    undo_list = [list_for_undo]
    possible_commands()
    while True:
        command = str(input("command="))
        command = command.split(' ')
        if command[0] == 'add':
            if len(command) == 4:
                try:
                    apartment = int(command[1])
                    typ = str(command[2])
                    amount = int(command[3])
                except ValueError:
                    print("The values do not correspond. It has to be add <ap> <type> <amount>.")
                try:
                    if apartment > 10 or apartment <= 0:
                        print("This apartment does not exist. There are only 10 from 1 to 10.")
                    else:
                        functions.add_expense(list_of_apartments, apartment, typ, amount)
                        list_for_undo = copy.deepcopy(list_of_apartments)
                        undo_list.append(list_for_undo)
                except UnboundLocalError:
                    print('Error')
            else:
                print("This command does not exist.")
        elif command[0] == 'remove':
            if len(command) == 2:
                flag = True  # true if the second can be an integer=> remove <ap>
                try:
                    int(command[1])
                except ValueError:
                    flag = False  # if false => remove <type>
                if flag:
                    apartment = int(command[1])
                    if apartment > 10 or apartment <= 0:
                        print("This apartment does not exist. There are only 10 from 1 to 10.")
                    else:
                        functions.remove_all_expenses(list_of_apartments, apartment)
                        list_for_undo = copy.deepcopy(list_of_apartments)
                        undo_list.append(list_for_undo)
                elif command[1] == 'water' or command[1] == 'heating' or command[1] == 'electricity' or command[
                    1] == 'gas' or command[1] == 'other':
                    typ = str(command[1])
                    functions.remove_all_typ_expenses(list_of_apartments, typ)
                    list_for_undo = copy.deepcopy(list_of_apartments)
                    undo_list.append(list_for_undo)
                else:
                    print("This type does not exist.")
            elif len(command) == 4:
                if command[2] == 'to':
                    try:
                        start = int(command[1])
                        end = int(command[3])
                    except ValueError:
                        print("Value error for the start and end apartments.")
                    try:
                        if start <= end:
                            functions.remove_all_expenses_from_to(list_of_apartments, start, end)
                            list_for_undo = copy.deepcopy(list_of_apartments)
                            undo_list.append(list_for_undo)
                        else:
                            print('The start and end input apartments are not valid')
                    except UnboundLocalError:
                        print('Error')
                else:
                    print("The command does not exist.")
            else:
                print("The command does not exist.")
        elif command[0] == "replace":
            if len(command) == 5:
                if command[3] == "with":
                    try:
                        apartment = int(command[1])
                        typ = str(command[2])
                        amount = int(command[4])
                    except ValueError:
                        print("The values do not correspond. It has to be replace <ap> <type> with <amount>.")
                    try:
                        if apartment > 10 or apartment <= 0:
                            print("This apartment does not exist. There are only 10 from 1 to 10.")
                        else:
                            functions.replace_expense_type(list_of_apartments, apartment, typ, amount)
                            list_for_undo = copy.deepcopy(list_of_apartments)
                            undo_list.append(list_for_undo)
                    except UnboundLocalError:
                        print('Error')
                else:
                    print("The command is not valid")
            else:
                print("The command is not valid")
        elif command[0] == 'list':
            if len(command) == 1:
                for i in range(0, 10):
                    print("apartment", i + 1, functions.returning_the_ap_dict(list_of_apartments, i))
            elif len(command) == 2:
                try:
                    apartment = int(command[1])
                except ValueError:
                    print("Value does not correspond, is has to be list <ap>")
                try:
                    if apartment > 10 or apartment <= 0:
                        print("This apartment does not exist. There are only 10 from 1 to 10.")
                    else:
                        print("apartment", apartment,
                              functions.returning_the_ap_dict(list_of_apartments, apartment - 1))
                except UnboundLocalError:
                    print('Error')
            elif len(command) == 3:
                if command[1] == '<':
                    try:
                        amount = int(command[2])
                    except ValueError:
                        print("Value does not correspond, is has to be list < <amount>")
                    try:
                        list_lower = functions.l_lower(list_of_apartments, amount)
                        if len(list_lower) == 0:
                            print('No apartment has the total expenses <', amount)
                        else:
                            print(list_lower)
                    except UnboundLocalError:
                        print('Error')
                elif command[1] == '=':
                    try:
                        amount = int(command[2])
                    except ValueError:
                        print("Value does not correspond, is has to be list = <amount>")
                    try:
                        list_equals = functions.l_equals(list_of_apartments, amount)
                        if len(list_equals) == 0:
                            print('No apartment has the total expenses =', amount)
                        else:
                            print(list_equals)
                    except UnboundLocalError:
                        print('Error')
                elif command[1] == '>':
                    try:
                        amount = int(command[2])
                    except ValueError:
                        print("Value does not correspond, is has to be list > <amount>")
                    try:
                        list_upper = functions.l_upper(list_of_apartments, amount)
                        if len(list_upper) == 0:
                            print('No apartment has the total expenses >', amount)
                        else:
                            print(list_upper)
                    except UnboundLocalError:
                        print('Error')
                else:
                    print("The command is not valid")
        elif command[0] == 'filter':
            if len(command) == 2:
                flag = True  # true if the second can be an integer=> filter <value>
                try:
                    int(command[1])
                except ValueError:
                    flag = False  # if false => filter <type>
                if flag:
                    value = int(command[1])
                    functions.filter_value(list_of_apartments, value)
                    list_for_undo = copy.deepcopy(list_of_apartments)
                    undo_list.append(list_for_undo)
                elif command[1] == 'water' or command[1] == 'heating' or command[1] == 'electricity' or command[
                    1] == 'gas' or command[1] == 'other':
                    typ = str(command[1])
                    functions.filter_typ(list_of_apartments, typ)
                    list_for_undo = copy.deepcopy(list_of_apartments)
                    undo_list.append(list_for_undo)
                else:
                    print('This type does not exist')
            else:
                print('The command is not valid')
        elif command[0] == 'undo':
            try:
                list_of_apartments = undo_list.pop(-2)
            except IndexError:
                print('You did the undo for all the operations')
        elif command[0] == 'exit' and len(command) == 1:
            return False
        else:
            print('The command is not valid')


if __name__ == "__main__":
    main()
