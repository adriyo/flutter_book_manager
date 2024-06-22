import 'package:flutter_book_manager/domain/entities/book.dart';
import 'package:flutter_book_manager/data/local/local_data_source.dart';
import 'package:flutter_book_manager/data/remote/remote_data_source.dart';
import 'package:flutter_book_manager/domain/repositories/book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;

  BookRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<void> fetchBooks() async {
    final List<Book> remoteBooks = await remoteDataSource.fetchBooks();
    if (remoteBooks.isNotEmpty) {
      await localDataSource.saveBooks(remoteBooks);
    }
  }

  @override
  Future<List<Book>> getBooks() async {
    return localDataSource.fetchBooks();
  }

  @override
  Future<void> saveBook(Book book) async {
    localDataSource.saveBook(book);
  }

  @override
  Future<void> deleteBook(int id) async {
    return localDataSource.deleteBook(id);
  }

  @override
  Future<void> saveBooks(List<Book> books) async {
    await localDataSource.saveBooks(books);
  }
}
