from src.repository.rentals_repo import RentalsRepo
from src.domain.rentals import Rentals
from datetime import datetime


class RentalServices:
    def __init__(self, repo):
        self._repo = repo

    def add_rental_function(self, rental_id, book_id, client_id, rented_date, returned_date):
        rental = Rentals(rental_id, book_id, client_id, rented_date, returned_date)
        self._repo.add_rental_repo(rental)

    def display_rentals_function(self):
        return self._repo.get_list_rentals()

    def update_returned_date_function(self, book_id, returned_date):
        self._repo.update_returned_date_by_id(book_id, returned_date)

    def check_book_availability_function(self, book_id):
        check = self._repo.search_book_by_id(book_id)
        if check:  # if the book is in the rentals_repo => a possibility to not be available => check returned date
            rented_date = self._repo.get_rented_date_by_book_id(book_id)
            returned_date = self._repo.get_returned_date_by_book_id(book_id)
            if returned_date == 0:
                return False
            else:
                rented_date_dt = datetime.strptime(rented_date, "%d/%m/%Y")
                returned_date_dt = datetime.strptime(returned_date, "%d/%m/%Y")
                if rented_date_dt > returned_date_dt:
                    return False
                else:
                    return True
        else:
            return True
