#
# The program's functions are implemented here. There is no user interaction in this file, therefore no input/print statements. Functions here
# communicate via function parameters, the return statement and raising of exceptions. 
#
import random
import copy

def random_amount_for_types():
    """
    Random values for types
    :return: The random value
    """
    return random.randint(1, 500)


def create_apartment():
    """
    Creates a dictionary named apartment that will contain the types and their values
    :return: the dictionary
    """
    apartment = {
        "water": random_amount_for_types(),
        "heating": random_amount_for_types(),
        "electricity": random_amount_for_types(),
        "gas": random_amount_for_types(),
        "other": random_amount_for_types()
    }
    return apartment


def get_water(apartment):
    return apartment.get("water")


def set_water(apartment, value):
    apartment.update({"water": value})


def get_heating(apartment):
    return apartment.get("heating")


def set_heating(apartment, value):
    apartment.update({"heating": value})


def get_electricity(apartment):
    return apartment.get("electricity")


def set_electricity(apartment, value):
    apartment.update({"electricity": value})


def get_gas(apartment):
    return apartment.get("gas")


def set_gas(apartment, value):
    apartment.update({"gas": value})


def get_other(apartment):
    return apartment.get("other")


def set_other(apartment, value):
    apartment.update({"other": value})


def list_of_apartments():
    """
    Creates a list of the apartments. A list of dictionaries
    :return: the list
    """
    apartments = []
    for i in range(0, 10):
        apartments.append(create_apartment())
    return apartments


def add_expense(apartments, ap, typ, amount):
    """
    The function that adds expenses
    :param apartments: the list of apartments
    :param ap: the number of the apartment
    :param typ: the type where we add an expense
    :param amount: the amount of the expense
    :return: no returns, only updates the dictionary of the apartment to their new value of the specific type
    """
    if typ == "water":
        set_water(apartments[ap - 1], get_water(apartments[ap - 1]) + amount)
    if typ == "heating":
        set_heating(apartments[ap - 1], get_heating(apartments[ap - 1]) + amount)
    if typ == "electricity":
        set_electricity(apartments[ap - 1], get_electricity(apartments[ap - 1]) + amount)
    if typ == "gas":
        set_gas(apartments[ap - 1], get_gas(apartments[ap - 1]) + amount)
    if typ == "other":
        set_other(apartments[ap - 1], get_other(apartments[ap - 1]) + amount)


def create_list_for_test():
    apartment1 = {
        "water": 100,
        "heating": 200,
        "electricity": 300,
        "gas": 400,
        "other": 500
    }
    apartment2 = {
        "water": 10,
        "heating": 20,
        "electricity": 30,
        "gas": 40,
        "other": 50
    }
    apartment3 = {
        "water": 1,
        "heating": 2,
        "electricity": 3,
        "gas": 4,
        "other": 5
    }
    list_ap = [apartment1, apartment2, apartment3]
    return list_ap


def test_add_expenses():
    list_ap = create_list_for_test()
    g = get_gas(list_ap[0])
    assert g == 400
    add_expense(list_ap, 1, 'gas', 50)
    g = get_gas(list_ap[0])
    assert g == 450


def test_remove_all_expenses():
    list_ap = create_list_for_test()
    w = get_water(list_ap[1])
    assert w == 10
    h = get_heating(list_ap[1])
    assert h == 20
    e = get_electricity(list_ap[1])
    assert e == 30
    g = get_gas(list_ap[1])
    assert g == 40
    o = get_other(list_ap[1])
    assert o == 50
    remove_all_expenses(list_ap, 2)
    w = get_water(list_ap[1])
    assert w == 0
    h = get_heating(list_ap[1])
    assert h == 0
    e = get_electricity(list_ap[1])
    assert e == 0
    g = get_gas(list_ap[1])
    assert g == 0
    o = get_other(list_ap[1])
    assert o == 0


def remove_all_expenses(apartments, ap):
    """
    Removes al expenses for a certain apartment
    :param apartments: list of apartments
    :param ap: the number of the apartment
    :return: nothing, it updates the dictionary
    """
    set_water(apartments[ap - 1], 0)
    set_heating(apartments[ap - 1], 0)
    set_electricity(apartments[ap - 1], 0)
    set_gas(apartments[ap - 1], 0)
    set_other(apartments[ap - 1], 0)


def remove_all_typ_expenses(apartments, typ):
    """
    Removes all expenses for a certain type for all apartments
    :param apartments: list of apartments
    :param typ: the type of expense
    :return: noting because it updates
    """
    if typ == 'water':
        for i in range(0, 10):
            set_water(apartments[i], 0)
    if typ == 'heating':
        for i in range(0, 10):
            set_heating(apartments[i], 0)
    if typ == 'electricity':
        for i in range(0, 10):
            set_electricity(apartments[i], 0)
    if typ == 'gas':
        for i in range(0, 10):
            set_gas(apartments[i], 0)
    if typ == 'other':
        for i in range(0, 10):
            set_other(apartments[i], 0)


def remove_all_expenses_from_to(apartments, start_ap, end_ap):
    """
    Removes all expenses for the apartments from start_ap to end_ap
    :param apartments: list of apartments
    :param start_ap: the apartment where it starts
    :param end_ap: the apartment where it ends
    :return: nothing, it just updates
    """
    for i in range(start_ap, end_ap + 1):
        remove_all_expenses(apartments, i)


def replace_expense_type(apartments, ap, typ, amount):
    """
    Replace the expense for a certain apartment and type with the amount that we gave
    :param apartments: list of apartments
    :param ap: the number of the apartment
    :param typ: type
    :param amount: amount that we replace with
    :return: nothing, just updates
    """
    if typ == "water":
        set_water(apartments[ap - 1], amount)
    if typ == "heating":
        set_heating(apartments[ap - 1], amount)
    if typ == "electricity":
        set_electricity(apartments[ap - 1], amount)
    if typ == "gas":
        set_gas(apartments[ap - 1], amount)
    if typ == "other":
        set_other(apartments[ap - 1], amount)


def returning_the_ap_dict(apartments, ap):
    apartment = apartments[ap]
    return apartment


def l_lower(apartments, amount):
    list_lower = []
    for i in range(0, 10):
        sum = get_water(apartments[i]) + get_electricity(apartments[i]) + get_heating(apartments[i]) + get_gas(
            apartments[i]) + get_other(apartments[i])
        if sum < amount:
            list_lower.append("apartment " + str(i + 1) + " " + "= " + str(sum))
    return list_lower


def l_equals(apartments, amount):
    list_equals = []
    for i in range(0, 10):
        sum = get_water(apartments[i]) + get_electricity(apartments[i]) + get_heating(apartments[i]) + get_gas(
            apartments[i]) + get_other(apartments[i])
        if sum == amount:
            list_equals.append("apartment " + str(i + 1) + " " + "= " + str(sum))
    return list_equals


def l_upper(apartments, amount):
    list_upper = []
    for i in range(0, 10):
        sum = get_water(apartments[i]) + get_electricity(apartments[i]) + get_heating(apartments[i]) + get_gas(
            apartments[i]) + get_other(apartments[i])
        if sum > amount:
            list_upper.append("apartment " + str(i + 1) + " " + "= " + str(sum))
    return list_upper


def filter_typ(apartments, typ):
    if typ == "water":
        for i in range(0, 10):
            set_heating(apartments[i], 0)
            set_electricity(apartments[i], 0)
            set_gas(apartments[i], 0)
            set_other(apartments[i], 0)
    if typ == "heating":
        for i in range(0, 10):
            set_water(apartments[i], 0)
            set_electricity(apartments[i], 0)
            set_gas(apartments[i], 0)
            set_other(apartments[i], 0)
    if typ == "electricity":
        for i in range(0, 10):
            set_heating(apartments[i], 0)
            set_water(apartments[i], 0)
            set_gas(apartments[i], 0)
            set_other(apartments[i], 0)
    if typ == "gas":
        for i in range(0, 10):
            set_heating(apartments[i], 0)
            set_electricity(apartments[i], 0)
            set_water(apartments[i], 0)
            set_other(apartments[i], 0)
    if typ == "other":
        for i in range(0, 10):
            set_heating(apartments[i], 0)
            set_electricity(apartments[i], 0)
            set_gas(apartments[i], 0)
            set_water(apartments[i], 0)


def filter_value(apartments, value):
    for i in range(0, 10):
        w = get_water(apartments[i])
        if w >= value:
            set_water(apartments[i], 0)

        e = get_electricity(apartments[i])
        if e >= value:
            set_electricity(apartments[i], 0)

        h = get_heating(apartments[i])
        if h >= value:
            set_heating(apartments[i], 0)

        g = get_gas(apartments[i])
        if g >= value:
            set_gas(apartments[i], 0)

        o = get_other(apartments[i])
        if o >= value:
            set_other(apartments[i], 0)