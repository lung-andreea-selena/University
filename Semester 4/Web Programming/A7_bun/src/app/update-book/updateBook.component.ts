import { Component, OnInit } from '@angular/core';
import { GenericService } from '../generic.service';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-update-book',
  templateUrl: './updateBook.component.html',
  styleUrls: ['./updateBook.component.css'],
})
export class UpdateBookComponent implements OnInit {
  constructor(
    private service: GenericService,
    private router: Router,
    private route: ActivatedRoute
  ) {}

  ngOnInit(): void {
    // Initialization logic
  }

  updateBook(
    author: string,
    title: string,
    pages: string,
    genre: string,
    is_lent: string
  ): void {
    const id = this.route.snapshot.queryParams['id'];
    console.log(id);
    if (!id) {
      console.error('Book ID is missing.');
      return;
    }

    this.service
      .updateBook(id, author, title, Number(pages), genre, Boolean(is_lent))
      .subscribe(
        (response) => {
          if (response.status === 'success') {
            console.log('Book updated successfully.');
            this.router.navigate(['show-books']);
          } else {
            console.error('Failed to update book:', response.message);
            // Handle error here, e.g., display an error message to the user
          }
        },
        (error) => {
          console.error('Error updating book:', error);
          // Handle error here, e.g., display an error message to the user
        }
      );
  }

  onCancel(): void {
    this.router.navigate(['show-books']);
  }
}
