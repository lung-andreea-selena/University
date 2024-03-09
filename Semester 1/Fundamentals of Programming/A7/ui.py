from src.services.service import ComplexService


class ComplexUI:
    def __init__(self, service):
        self._service = service

    def add_from_console_complex_nr(self):
        try:
            real_part = int(input('Real part='))
            imaginary_part = int(input('Imaginary part='))
            self._service.add_complex_number_function(real_part, imaginary_part)
        except ValueError:
            print('The values should be integers')

    def display_list(self):
        list_print = self._service.display_all()
        for el in list_print:
            print(str(el))

    def filter(self):
        try:
            start = int(input('start='))
            end = int(input('end='))
            self._service.filter(start, end)
        except ValueError:
            print('The values should be integers and positive')

    def undo_ui(self):
        self._service.undo()

    def print_menu(self):
        print('1. Add a complex number')
        print('2. Display the list of complex numbers')
        print("3. Filter the list so that it contains only the numbers between indices `start` and `end`")
        print('4. Undo the last operation that modified program data')
        print('5. Exit')

    def run(self):
        self._service.generate_complex_numbers()
        while True:
            self.print_menu()
            choice = int(input('Choice='))
            if choice == 1:
                self.add_from_console_complex_nr()
            elif choice == 5:
                return False
            elif choice == 2:
                self.display_list()
            elif choice == 3:
                self.filter()
            elif choice == 4:
                self.undo_ui()
            else:
                print('The choice is not valid')
