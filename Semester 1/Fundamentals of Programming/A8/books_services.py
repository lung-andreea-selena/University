from src.domain.books import Books
from src.repository.books_repo import BooksRepo
import random


class BookServices:
    def __init__(self, repo):
        self._repo = repo

    def add_book_function(self, book_id, title, author):
        """
        This function receives the book id, tittle and author from ui and creates an object book and adds it in the repo
        :param book_id: book id
        :param title: title of the book
        :param author: author of the book
        :return: nothing
        """
        book = Books(book_id, title, author)
        self._repo.add_book_repo(book)

    def remove_book_function(self, book_id):
        """
        This function removes a book based on the book id that is written in ui
        :param book_id: the book id
        :return: nothing
        """
        book = self._repo.get_book_by_id(book_id)
        self._repo.remove_book_repo(book)

    def update_book_function(self, book_id, title, author):
        """
        Updates the title and author based of a book based on the book id
        :param book_id: book id
        :param title: title
        :param author: author
        :return: nothing
        """
        self._repo.update_book_by_id(book_id, title, author)

    def check_book_existence_by_id_function(self, book_id):
        check = self._repo.check_book_existence_by_id(book_id)
        if check:  # this book id is already used and exists
            return True
        else:
            return False  # this book id does not exist and the id is not used

    def search_book_by_id(self, sub_book_id):
        list_book_ids = []
        sub_book_id_str = str(sub_book_id)
        for index in range(0, self._repo.length_repo()):
            book_id = self._repo.get_book_id_repo(index)
            book_id_str = str(book_id)
            if sub_book_id_str in book_id_str:
                list_book_ids.append(book_id)
        return list_book_ids

    def list_of_found_books_id(self, list_book_ids):
        list_books = []
        for book_id in list_book_ids:
            book = self._repo.get_book_by_id(book_id)
            list_books.append(book)
        return list_books

    def search_book_by_title(self, sub_title):
        list_book_titles = []
        for index in range(0, self._repo.length_repo()):
            title = self._repo.get_book_title_repo(index)
            if sub_title.lower() in title.lower():
                list_book_titles.append(title)
        return list_book_titles

    def list_of_found_books_title(self, list_book_titles):
        list_books = []
        for title in list_book_titles:
            book = self._repo.get_book_by_title(title)
            list_books.append(book)
        return list_books

    def search_book_by_author(self, sub_author):
        list_book_authors = []
        for index in range(0, self._repo.length_repo()):
            author = self._repo.get_book_author_repo(index)
            if sub_author.lower() in author.lower():
                list_book_authors.append(author)
        return list_book_authors

    def list_of_found_books_author(self, list_book_authors):
        list_books = []
        for author in list_book_authors:
            book = self._repo.get_book_by_author(author)
            list_books.append(book)
        return list_books

    def display_books_function(self):
        return self._repo.get_list()

    def generate_books(self):
        if len(self._repo.get_list()) == 0:
            book = Books(random.randint(100000, 999999), 'Maze Runner', 'James Dashner')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'The Scorch Trials', 'James Dashner')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'The Death Cure', 'James Dashner')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'The Daily Laws', 'Robert Greene')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'The Art of Seduction', 'Robert Greene')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'Atomic Habits', 'James Clear')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'Ugly Love', 'Colleen Hoover')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'It ends with us', 'Coollen Hoover')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'Milk and Honey', 'Rupi Kaur')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'The sun and her flowers', 'Rupi Kaur')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'My Dark Vanessa', 'Kate Elizabeth')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'The Binding', 'Bridget Collins')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'Her Last Mistake', 'Carla Kovach')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'The body', 'Bill Bryson')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'The shining', 'Stephen King')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'It', 'Stephen King')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'Misery', 'Stephen King')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'The Fault in Our Stars', 'John Green')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'Looking for Alaska', 'John Green')
            self._repo.add_book_repo(book)
            book = Books(random.randint(100000, 999999), 'A World of Curiosities', 'Louise Penny')
            self._repo.add_book_repo(book)
