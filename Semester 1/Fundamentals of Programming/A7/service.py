from src.repository.reposit import ComplexMemoryRepo
from src.domain.complex import ComplexNumbers
import copy
import random


class ComplexService:
    def __init__(self, repo):
        self._repo = repo
        self._undo = [self._repo.get_list()]

    def add_complex_number_function(self, real_part, imaginary_part):
        """
        Adds a complex number with their real part and imaginary part
        :param real_part: real part
        :param imaginary_part: imaginary part
        :return: updates the repository
        """
        complex_nr = ComplexNumbers(real_part, imaginary_part)
        self._repo.add_complex_nr_repo(complex_nr)
        self._undo.append(copy.deepcopy(self._repo.get_list()))

    def display_all(self):
        return self._repo.get_list()

    def filter(self, start, end):
        if start <= end:
            new_list = []
            for e in range(start, end + 1):
                new_list.append(self._repo.get_number(e))
            self._undo.append(copy.deepcopy(new_list))
            self._repo.refresh(copy.deepcopy(new_list))
        else:
            print('The start value should be smaller than the end value')

    def generate_complex_numbers(self):
        if len(self._repo.get_list()) == 0:
            for index in range(0, 10):
                real_part = random.randint(1, 10)
                imaginary_part = random.randint(1, 10)
                new_complex_number = ComplexNumbers(real_part, imaginary_part)
                self._repo.add_complex_nr_repo(new_complex_number)

    def undo(self):
        if len(self._undo) > 1:
            self._undo.pop()
            self._repo.refresh(self._undo[len(self._undo) - 1])
        else:
            print('You can not undo no more')


def test_add_complex_number():
    complex_repo = ComplexMemoryRepo()
    assert len(complex_repo) == 0
    complex_number_1 = ComplexNumbers(8, 9)
    complex_repo.add_complex_nr_repo(complex_number_1)
    complex_number_2 = ComplexNumbers(-2, -15)
    complex_repo.add_complex_nr_repo(complex_number_2)
    assert len(complex_repo) == 2
    assert complex_repo.get_number(1) == complex_number_1
    assert complex_repo.get_number(2) == complex_number_2