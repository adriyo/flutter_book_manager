import 'package:flutter_book_manager/domain/entities/book.dart';

abstract class BookRepository {
  Future<void> fetchBooks();
  Future<List<Book>> getBooks();
  Future<void> saveBook(Book book);
  Future<void> deleteBook(int id);
  Future<void> saveBooks(List<Book> books);
}
