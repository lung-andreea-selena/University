import { Component, OnInit } from '@angular/core';
import { GenericService } from '../generic.service';
import { Book } from '../book';
import { Router, RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-show-books',
  standalone: true,
  templateUrl: './showBooks.component.html',
  styleUrls: ['./showBooks.component.css'],
  imports: [CommonModule, FormsModule, RouterModule],
})
export class ShowBooksComponent implements OnInit {
  books: Array<Book> = [];

  constructor(private service: GenericService, private router: Router) {}

  ngOnInit(): void {
    this.refresh('', '');
  }

  refresh(genre: string, author: string): void {
    this.service
      .fetchBooks(genre, author)
      .subscribe((books) => (this.books = books));
  }

  navigateToDelete(bookId: number): void {
    console.log('Navigating to delete book with ID:', bookId);
    this.router
      .navigate(['delete-book'], { queryParams: { id: bookId } })
      .then((_) => {});
  }

  navigateToAdd(): void {
    this.router.navigate(['add-book']).then((_) => {});
  }

  navigateToUpdate(bookId: number): void {
    console.log('Navigating to delete book with ID:', bookId);
    this.router
      .navigate(['update-book'], { queryParams: { id: bookId } })
      .then((_) => {});
  }
}
