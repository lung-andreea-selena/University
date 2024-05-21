import { Component, OnInit } from '@angular/core';
import { GenericService } from '../generic.service';
import { Router, RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-add-book',
  standalone: true,
  templateUrl: './addBook.component.html',
  styleUrls: ['./addBook.component.css'],
  imports: [FormsModule, CommonModule, RouterModule],
})
export class AddBookComponent implements OnInit {
  constructor(private service: GenericService, private router: Router) {}

  ngOnInit(): void {}
  addBook(
    author: string,
    title: string,
    pages: string,
    genre: string,
    is_lent: string
  ): void {
    this.service
      .addBook(author, title, Number(pages), genre, Boolean(is_lent))
      .subscribe(() => {
        this.router.navigate(['show-books']).then((_) => {});
      });
  }
  onCancel(): void {
    this.router.navigate(['show-books']).then((_) => {});
  }
}
