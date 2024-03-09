class Books:
    def __init__(self, book_id, title, author):
        self._book_id = book_id
        self._title = title
        self._author = author

    def getter_book_id(self):
        return self._book_id

    def getter_title(self):
        return self._title

    def getter_author(self):
        return self._author

    def setter_book_id(self, value):
        self._book_id = value

    def setter_title(self, value):
        self._title = value

    def setter_author(self, value):
        self._author = value

    def __str__(self):
        return str(self._book_id) + ' | ' + str(self._title).ljust(24) + ' | ' + str(self._author)
