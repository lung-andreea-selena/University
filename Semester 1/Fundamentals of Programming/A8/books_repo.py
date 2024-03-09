from src.domain.books import Books


class BooksRepo:
    def __init__(self):
        self._repo = []

    def add_book_repo(self, book):
        self._repo.append(book)

    def remove_book_repo(self, book):
        self._repo.remove(book)

    def get_list(self):
        return self._repo

    def length_repo(self):
        return len(self._repo)

    def get_book_id_repo(self, index):
        book = self._repo[index]
        book_id = book.getter_book_id()
        return book_id

    def get_book_title_repo(self, index):
        book = self._repo[index]
        title = book.getter_title()
        return title

    def get_book_author_repo(self, index):
        book = self._repo[index]
        author = book.getter_author()
        return author

    def get_book_by_id(self, book_id):
        for b in self._repo:
            if b.getter_book_id() == book_id:
                return b

    def get_book_by_title(self, title):
        for b in self._repo:
            if b.getter_title() == title:
                return b

    def get_book_by_author(self, author):
        for b in self._repo:
            if b.getter_author() == author:
                return b

    def update_book_by_id(self, book_id, title, author):
        for b in self._repo:
            if b.getter_book_id() == book_id:
                b.setter_title(title)
                b.setter_author(author)

    def check_book_existence_by_id(self, book_id):
        for b in self._repo:
            if b.getter_book_id() == book_id:
                return True
        return False
