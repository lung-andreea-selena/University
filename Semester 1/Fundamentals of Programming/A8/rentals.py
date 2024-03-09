class Rentals:
    def __init__(self, rental_id, book_id, client_id, rented_date, returned_date):
        self._rental_id = rental_id
        self._book_id = book_id
        self._client_id = client_id
        self._rented_date = rented_date
        self._returned_date = returned_date

    def getter_rental_id(self):
        return self._rental_id

    def getter_book_id(self):
        return self._book_id

    def getter_client_id(self):
        return self._client_id

    def getter_rented_date(self):
        return self._rented_date

    def getter_returned_date(self):
        return self._returned_date

    def setter_rental_id(self, value):
        self._rental_id = value

    def setter_book_id(self, value):
        self._book_id = value

    def setter_client_id(self, value):
        self._client_id = value

    def setter_rented_date(self, value):
        self._rented_date = value

    def setter_returned_date(self, value):
        self._returned_date = value

    def __str__(self):
        return str(self._rental_id).ljust(9) + ' | ' + str(self._book_id).ljust(7) + ' | ' + str(self._client_id).ljust(9) + ' | ' + str(
            self._rented_date).ljust(11) + ' | ' + str(self._returned_date)

