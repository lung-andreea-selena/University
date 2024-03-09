from src.domain.complex import ComplexNumbers
import pickle


class ComplexMemoryRepo:
    def __init__(self):
        self._repo = []

    def add_complex_nr_repo(self, number):
        self._repo.append(number)

    def get_list(self):
        return self._repo

    def get_number(self, index):
        return self._repo[index - 1]

    def refresh(self, new_list: list):
        self._repo = new_list


class ComplexTextRepo(ComplexMemoryRepo):
    def __init__(self, file_name='file.txt'):
        super(ComplexTextRepo, self).__init__()
        self._file_name = file_name
        self.load_file()

    def load_file(self):
        lines = []
        try:
            fin = open(self._file_name, "rt")
            lines = fin.readlines()
            fin.close()
            for line in lines:
                real_part = line.split("+")
                imaginary_part = real_part[1].split("i")
                new_nr = ComplexNumbers(int(real_part[0]), int(imaginary_part[0]))
                super().add_complex_nr_repo(new_nr)
        except IOError:
            pass
        except IndexError:
            pass

    def save_file(self):
        fout = open(self._file_name, "wt")
        for nr in self.get_list():
            complex_number_string = str(nr.getter_real()) + "+" + str(nr.getter_imaginary()) + "i" + '\n'
            fout.write(complex_number_string)
        fout.close()

    def add_complex_nr_repo(self, new_nr):
        super().add_complex_nr_repo(new_nr)
        self.save_file()

    def refresh(self, new_list):
        super().refresh(new_list)
        self.save_file()


class ComplexBinaryRepo(ComplexMemoryRepo):
    def __init__(self, file_name='binaryrep.bin'):
        super(ComplexBinaryRepo, self).__init__()
        self._file_name = file_name
        self.load_file()

    def load_file(self):
        try:
            fi = open(self._file_name, "rb")
            o = pickle.load(fi)
            for complex_number in o:
                super().add_complex_nr_repo(complex_number)
            fi.close()
        except EOFError:
            pass

    def add_complex_nr_repo(self, new_complex_number: ComplexNumbers):
        super().add_complex_nr_repo(new_complex_number)
        self._save_file()

    def _save_file(self):
        fo = open(self._file_name, "wb")
        pickle.dump(self.get_list(), fo)
        fo.close()

    def refresh_list_of_complex_numbers(self, new_list):
        super().refresh(new_list)
        self._save_file()