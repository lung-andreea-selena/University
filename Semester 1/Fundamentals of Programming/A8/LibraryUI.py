from src.services.books_services import BookServices
from src.services.clients_services import ClientServices
from src.services.rentals_services import RentalServices
from datetime import date
import random


class LibraryUI:
    def __init__(self, books_services, clients_services, rental_services):
        self._books_services = books_services
        self._clients_services = clients_services
        self._rental_services = rental_services

# Books

    def add_book_from_console(self):
        try:
            book_id = int(input('book id='))
            check = self._books_services.check_book_existence_by_id_function(book_id)
            if check:
                print('This book id has already been used for another book')
            else:
                title = str(input('title='))
                author = str(input('author='))
                self._books_services.add_book_function(book_id, title, author)
                print('The book was successfully added in the library!')
        except ValueError:
            print('The input values are not valid')

    def remove_book_from_console(self):
        try:
            book_id = int(input('book id='))
            check = self._books_services.check_book_existence_by_id_function(book_id)
            if check:
                self._books_services.remove_book_function(book_id)
                print('The book was successfully removed from the library!')
            else:
                print("The book id you introduced doesn't exist")
        except ValueError:
            print('The input value is not valid')

    def update_book_from_console(self):
        try:
            book_id = int(input('book id='))
            check = self._books_services.check_book_existence_by_id_function(book_id)
            if check:
                title = str(input('new title='))
                author = str(input('new author='))
                self._books_services.update_book_function(book_id, title, author)
                print('The book was successfully updated in the library!')
            else:
                print("The book id you introduced doesn't exist")
        except ValueError:
            print('The input values are not valid')

    def search_book_by_id_ui(self):
        try:
            print('You can enter the full book id or a partial book id')
            sub_book_id = int(input('book id='))
            list_book_ids = self._books_services.search_book_by_id(sub_book_id)
            list_books = self._books_services.list_of_found_books_id(list_book_ids)
            if len(list_books) > 0:
                for book in list_books:
                    print(str(book))
            else:
                print('No mathing found')
        except ValueError:
            print('The input values are not valid')

    def search_book_by_title_ui(self):
        try:
            print('You can enter the full title of the book or a partial title')
            sub_book_title = str(input('book title='))
            list_book_titles = self._books_services.search_book_by_title(sub_book_title)
            list_books = self._books_services.list_of_found_books_title(list_book_titles)
            if len(list_books) > 0:
                for book in list_books:
                    print(str(book))
            else:
                print('No mathing found')
        except ValueError:
            print('The input values are not valid')

    def search_book_by_author_ui(self):
        try:
            print("You can enter the full name of the author or a partial name")
            sub_book_author = str(input('book author='))
            list_book_authors = self._books_services.search_book_by_author(sub_book_author)
            list_books = self._books_services.list_of_found_books_author(list_book_authors)
            if len(list_books) > 0:
                for book in list_books:
                    print(str(book))
            else:
                print('No mathing found')
        except ValueError:
            print('The input values are not valid')

    def display_books_ui(self):
        list_print = self._books_services.display_books_function()
        for el in list_print:
            print(str(el))


# Clients

    def add_client_from_console(self):
        try:
            client_id = int(input('client id='))
            check = self._clients_services.check_client_existence_by_id_function(client_id)
            if check:
                print('This client id has already been used for another client!')
            else:
                name = str(input('name='))
                self._clients_services.add_client_function(client_id, name)
                print('The client was successfully added!')
        except ValueError:
            print('The input values are not valid!')

    def remove_client_from_console(self):
        try:
            client_id = int(input('client='))
            check = self._clients_services.check_client_existence_by_id_function(client_id)
            if check:
                self._clients_services.remove_client_function(client_id)
                print('The client was successfully removed!')
            else:
                print("This client id doesn't exist!")
        except ValueError:
            print('The input value is not valid')

    def update_client_from_console(self):
        try:
            client_id = int(input('client id='))
            check = self._clients_services.check_client_existence_by_id_function(client_id)
            if check:
                name = str(input('new name='))
                self._clients_services.update_client_function(client_id, name)
                print('The client was successfully updated!')
            else:
                print("This client id doesn't exist!")
        except ValueError:
            print('The input values are not valid')

    def search_client_by_id_ui(self):
        try:
            print('You can enter the full id of the client or a partial id')
            sub_client_id = int(input('client id='))
            list_client_ids = self._clients_services.search_client_by_id(sub_client_id)
            list_clients = self._clients_services.list_of_found_clients_id(list_client_ids)
            if len(list_clients) > 0:
                for client in list_clients:
                    print(str(client))
            else:
                print('No mathing found')
        except ValueError:
            print('The input values are not valid')

    def search_client_by_name_ui(self):
        try:
            print('You can enter the full name of the client or a partial name')
            sub_name = str(input('client name='))
            list_client_names = self._clients_services.search_client_by_name(sub_name)
            list_clients = self._clients_services.list_of_found_clients_name(list_client_names)
            if len(list_clients) > 0:
                for client in list_clients:
                    print(str(client))
            else:
                print('No mathing found')
        except ValueError:
            print('The input values are not valid')

    def display_clients_ui(self):
        list_print = self._clients_services.display_clients_function()
        for el in list_print:
            print(str(el))

# Rentals

    def add_rental_from_console(self):
        try:
            rental_id = random.randint(100000, 999999)
            book_id = int(input('book id='))
            check_book = self._books_services.check_book_existence_by_id_function(book_id)
            if check_book:
                client_id = int(input('client_id='))
                check_client = self._clients_services.check_client_existence_by_id_function(client_id)
                if check_client:
                    today = date.today()
                    rental_date = today.strftime("%d/%m/%Y")
                    returned_date = 0
                    check = self._rental_services.check_book_availability_function(book_id)
                    if check:
                        self._rental_services.add_rental_function(rental_id, book_id, client_id, rental_date,
                                                                  returned_date)
                        print("Thank you for your rental!")
                    else:
                        print("The book is not available")
                else:
                    print("This client id doesn't exist!")
            else:
                print("The book id you introduced doesn't exist")
        except ValueError:
            print('The input values are not valid')

    def returned_date(self):
        try:
            book_id = int(input('book_id='))
            check = self._books_services.check_book_existence_by_id_function(book_id)
            if check:
                day = int(input('day='))
                month = int(input('month='))
                year = int(input('year='))
                date_r = date(year, month, day)
                returned_day = date_r.strftime("%d/%m/%Y")
                self._rental_services.update_returned_date_function(book_id, returned_day)
                print('The book was successfully returned! Thank you!')
            else:
                print("The book id you introduced doesn't exist")

        except ValueError as er:
            print(er)

    def display_rentals_ui(self):
        list_print = self._rental_services.display_rentals_function()
        for el in list_print:
            print(str(el))

# Menus

    def main_menu(self):
        print("1. Manage books")
        print("2. Manage clients")
        print("3. Rent a book")
        print("4. Return a book")
        print("5. List rentals")
        print("6. Search for books")
        print("7. Search for clients")
        print("8. Create statistics")
        print("0. Exit")

    def menu_manage_books(self):
        print("1. Add a book")
        print("2. Remove a book")
        print("3. Update a book")
        print("4. List all books")
        print("0. Exit to main menu")

    def menu_manage_clients(self):
        print("1. Add a client")
        print("2. Remove a client")
        print("3. Update a client")
        print("4. List all clients")
        print("0. Exit to main menu")

    def menu_search_clients(self):
        print("Search client by:")
        print("1. Client id")
        print("2. Client name")
        print("0. Exit to main menu")

    def menu_search_books(self):
        print("Search book by:")
        print("1. Book id")
        print("2. Book title")
        print("3. Book author")
        print("0. Exit to main menu")

    def menu_statistics(self):
        print("Which statistic do you want to see?")
        print("1. Most rented books")
        print("2. Most active clients")
        print("3. Most rented authors")
        print("0. Exit to main menu")

    def run_ui(self):
        self._books_services.generate_books()
        self._clients_services.generate_clients()
        while True:
            print(' ')
            print('--- MAIN MENU ---')
            self.main_menu()
            try:
                main = int(input('Choice='))
                if main == 1:
                    while True:
                        print('')
                        print('--- MANAGING BOOKS MENU ---')
                        self.menu_manage_books()
                        second = int(input('Next Choice='))
                        if second == 1:
                            self.add_book_from_console()
                        elif second == 2:
                            self.remove_book_from_console()
                        elif second == 3:
                            self.update_book_from_console()
                        elif second == 4:
                            self.display_books_ui()
                        elif second == 0:
                            break
                        else:
                            print('! The choice is not valid !')
                elif main == 2:
                    while True:
                        print('')
                        print('--- MANAGING CLIENTS MENU ---')
                        self.menu_manage_clients()
                        second = int(input('Next Choice='))
                        if second == 1:
                            self.add_client_from_console()
                        elif second == 2:
                            self.remove_client_from_console()
                        elif second == 3:
                            self.update_client_from_console()
                        elif second == 4:
                            self.display_clients_ui()
                        elif second == 0:
                            break
                        else:
                            print('! The choice is not valid !')
                elif main == 3:
                    self.add_rental_from_console()
                elif main == 4:
                    self.returned_date()
                elif main == 5:
                    print("rental id | book id | client id | rented date | returned date ")
                    self.display_rentals_ui()
                elif main == 6:
                    while True:
                        print('')
                        print('--- MENU FOR BOOK SEARCHING ---')
                        self.menu_search_books()
                        second = int(input('Next choice='))
                        if second == 1:
                            self.search_book_by_id_ui()
                        elif second == 2:
                            self.search_book_by_title_ui()
                        elif second == 3:
                            self.search_book_by_author_ui()
                        elif second == 0:
                            break
                elif main == 7:
                    while True:
                        print('')
                        print('--- MENU FOR CLIENT SEARCHING ---')
                        self.menu_search_clients()
                        second = int(input('Next choice='))
                        if second == 1:
                            self.search_client_by_id_ui()
                        elif second == 2:
                            self.search_client_by_name_ui()
                        elif second == 0:
                            break
                elif main == 8:
                    while True:
                        print('')
                        print('--- MENU FOR STATISTICS ---')
                        self.menu_statistics()
                        second = int(input('Next choice= '))
                        if second == 1:
                            self.display_books_ui()

                elif main == 0:
                    print('Thank you and see you soon!')
                    break
                else:
                    print('! The choice is not valid !')
            except ValueError:
                print('The input value must be an integer')
