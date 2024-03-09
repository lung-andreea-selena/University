# I need to put n points with random coordinates(1,10) in a dictionary
# and then with the backtracking method to generate the collinear points by calculating the area of the points
# formula: [(x1y2-x2y1)+(x2y3-y2x3)...+(xny1-ynx1)]/2
# if the formula!=0 => the points are not collinear

import random


def random_coordinates_x():
    x = random.randint(1, 10)
    return x


def random_coordinates_y():
    y = random.randint(1, 10)
    return y


def points_generator(n):
    points = {}
    for i in range(1, n + 1):
        x = random_coordinates_x()
        y = random_coordinates_y()
        points["Point" + str(i)] = list()
        points["Point" + str(i)].append(x)
        points["Point" + str(i)].append(y)
    return points


def list_of_points(points):
    list_principal = []
    list_principal.extend(points.keys())
    # print(list_principal)
    return list_principal


def check_col(listp, k, points):
    area = 0
    for pt in range(0, len(listp) - 1):
        pt1 = points[listp[pt]]
        pt2 = points[listp[pt + 1]]
        area += pt1[0] * pt2[1] - pt2[0] * pt1[1] # x1y2 - x2y1
    if area == 0:
        return True
    else:
        return False


def valid(list_p):
    seen = []
    max = -1
    for el in list_p:
        if el in seen:
            return False
        if int(el[5:]) <= max:
            return False
        seen.append(el)
        max = int(el[5:])
    return True


def backtracking_recursive(step, n, list_check, list_points, points):
    if step >= n:
        return
    if len(list_check) <= step:
        list_check.append(0)
    for i in range(0, n):
        list_check[step] = list_points[i]
        if valid(list_check):
            if len(list_check) >= 3:
                if check_col(list_check, len(list_check), points):
                    print(list_check)
            backtracking_recursive(step + 1, n, list_check, list_points, points)
    list_check.pop(len(list_check) - 1)


if __name__ == '__main__':
    print("Please choose how many points do you want to generate")
    n = int(input("n="))
    points_bt =points_generator(n)
    list_points = []
    list_points = list_of_points(points_bt)
    ok=False
    backtracking_recursive(0, n,[], list_points, points_bt)
