from src.domain.rentals import Rentals


class RentalsRepo:
    def __init__(self):
        self._repo = []

    def add_rental_repo(self, rental):
        self._repo.append(rental)

    def get_list_rentals(self):
        return self._repo

    def get_rented_date_by_book_id(self, book_id):
        for i in range(len(self._repo)-1, -1, -1):
            b = self._repo[i]
            if b.getter_book_id() == book_id:
                rented_date = b.getter_rented_date()
                return rented_date

    def get_returned_date_by_book_id(self, book_id):
        for i in range(len(self._repo) - 1, -1, -1):
            b = self._repo[i]
            if b.getter_book_id() == book_id:
                returned_date = b.getter_returned_date()
                return returned_date

    def update_returned_date_by_id(self, book_id, returned_date):
        for r in self._repo:
            if r.getter_book_id() == book_id:
                r.setter_returned_date(returned_date)

    def search_book_by_id(self, book_id):
        for b in self._repo:
            if b.getter_book_id() == book_id:
                return True
        return False
