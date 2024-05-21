import { Injectable } from '@angular/core';
import {
  HttpClient,
  HttpErrorResponse,
  HttpHeaders,
} from '@angular/common/http';

import { Observable, of, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { Book } from './book';

@Injectable({
  providedIn: 'root',
})
export class GenericService {
  httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json',
    }),
  };
  private backendUrl = 'http://localhost/Ajax+php_books';

  constructor(private http: HttpClient) {}

  fetchBooks(genre: string, author: string): Observable<Book[]> {
    return this.http
      .get<Book[]>(
        `
        ${this.backendUrl}/showBooks.php?genre=${genre}&author=${author}`
      )
      .pipe(catchError(this.handleError<Book[]>('fetchBooks', [])));
  }

  deleteBook(bookId: number): Observable<any> {
    return this.http
      .post(
        `${this.backendUrl}/deleteBookBackend.php`,
        {
          id: bookId,
        },
        this.httpOptions
      )
      .pipe(
        catchError((error: HttpErrorResponse) => {
          let errorMessage = 'An error occurred while deleting the book.';
          if (error.error instanceof ErrorEvent) {
            // Client-side error
            errorMessage = error.error.message;
          } else {
            // Server-side error
            errorMessage =
              'Server returned error code ' +
              error.status +
              ': ' +
              error.statusText;
          }
          console.error(errorMessage);
          return throwError(errorMessage);
        })
      );
  }

  addBook(
    authorr: string,
    titlee: string,
    pagess: number,
    genree: string,
    is_lentt: boolean
  ): Observable<any> {
    return this.http
      .post(
        `${this.backendUrl}/addBook.php`,
        {
          author: authorr,
          title: titlee,
          pages: pagess,
          genre: genree,
          is_lent: is_lentt,
        },
        this.httpOptions
      )
      .pipe(catchError(this.handleError<any>('addBook')));
  }

  updateBook(
    bookId: number,
    author: string,
    title: string,
    pages: number,
    genre: string,
    is_lent: boolean
  ): Observable<any> {
    const payload = {
      bookid: bookId,
      author: author,
      title: title,
      pages: pages,
      genre: genre,
      is_lent: is_lent,
    };

    console.log('Sending update payload:', payload); // Log the payload

    return this.http
      .post(
        `${this.backendUrl}/updateBookBackend.php`,
        {
          bookId: bookId,
          author: author,
          title: title,
          pages: pages,
          genre: genre,
          is_lent: is_lent,
        },
        this.httpOptions
      )
      .pipe(
        catchError((error: HttpErrorResponse) => {
          let errorMessage = 'An error occurred while updating the book.';
          if (error.error instanceof ErrorEvent) {
            // Client-side error
            errorMessage = error.error.message;
          } else {
            // Server-side error
            errorMessage =
              'Server returned error code ' +
              error.status +
              ': ' +
              error.statusText;
          }
          console.error(errorMessage);
          return throwError(errorMessage);
        })
      );
  }

  private handleError<T>(
    operation = 'operation',
    result?: T
  ): (error: any) => Observable<T> {
    return (error: any): Observable<T> => {
      console.error(error);
      return of(result as T);
    };
  }
}
