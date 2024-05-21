import { Component, OnInit } from '@angular/core';
import { GenericService } from '../generic.service';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-delete-book',
  standalone: true,
  templateUrl: './deleteBook.component.html',
  styleUrls: ['./deleteBook.component.css'],
  imports: [CommonModule, FormsModule, RouterModule],
})
export class DeleteBookComponent implements OnInit {
  constructor(
    private service: GenericService,
    private router: Router,
    private route: ActivatedRoute
  ) {}

  ngOnInit(): void {}

  onYes(): void {
    const bookId = this.route.snapshot.queryParams['id'];
    if (!bookId) {
      console.error('Book ID is missing');
      return;
    }
    this.service.deleteBook(bookId).subscribe(
      () => {
        console.log('Book deleted successfully.');
        this.router.navigate(['show-books']);
      },
      (error) => {
        console.error('Error deleting book:', error);
        // You can handle the error here, e.g., display an error message to the user
      }
    );
  }

  onNo(): void {
    this.router.navigate(['show-books']).then((_) => {});
  }
}
