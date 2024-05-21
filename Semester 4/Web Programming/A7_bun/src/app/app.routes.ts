import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ShowBooksComponent } from './show-books/showBooks.component';
import { DeleteBookComponent } from './delete-book/deleteBook.component';
import { AddBookComponent } from './add-book/addBook.component';
import { UpdateBookComponent } from './update-book/updateBook.component';

export const routes: Routes = [
  { path: '', redirectTo: '/show-books', pathMatch: 'full' },
  { path: 'show-books', component: ShowBooksComponent },
  { path: 'delete-book', component: DeleteBookComponent },
  { path: 'add-book', component: AddBookComponent },
  { path: 'update-book', component: UpdateBookComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
