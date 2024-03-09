from src.repository.books_repo import BooksRepo
from src.services.books_services import BookServices
from src.repository.clients_repo import ClientsRepo
from src.services.clients_services import ClientServices
from src.repository.rentals_repo import RentalsRepo
from src.services.rentals_services import RentalServices
from src.ui.LibraryUI import LibraryUI


def run():
    book_repo = BooksRepo()
    book_service = BookServices(book_repo)
    client_repo = ClientsRepo()
    client_service = ClientServices(client_repo)
    rental_repo = RentalsRepo()
    rental_service = RentalServices(rental_repo)
    ui = LibraryUI(book_service, client_service, rental_service)
    ui.run_ui()


run()
