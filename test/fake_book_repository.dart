import 'package:flutter_book_manager/domain/entities/book.dart';
import 'package:flutter_book_manager/domain/repositories/book_repository.dart';

class FakeBookRepository extends BookRepository {
  final List<Book> _books = [];
  final List<Book> initialBooks = [
    Book(id: 1, title: 'Book 1', description: 'Description 1'),
    Book(id: 2, title: 'Book 2', description: 'Description 2'),
  ];

  List<Book> get books => _books;
  bool _isError = false;

  @override
  Future<void> saveBook(Book book) async {
    if (book.id == null) {
      await _addBook(book);
    } else {
      await _updateBook(book);
    }
  }

  Future<void> _addBook(Book book) async {
    final id = _books.length + 1;
    final newBook = book.copyWith(id: id);
    _books.add(newBook);
  }

  Future<void> _updateBook(Book updatedBook) async {
    final index = _books.indexWhere((book) => book.id == updatedBook.id);
    if (index != -1) {
      _books[index] = updatedBook;
    }
  }

  @override
  Future<void> deleteBook(int id) async {
    _books.removeWhere((book) => book.id == id);
  }

  @override
  Future<void> fetchBooks() async {
    if (_isError) return;
    _setInitialBooks();
  }

  @override
  Future<List<Book>> getBooks() async {
    return _books;
  }

  @override
  Future<void> saveBooks(List<Book> books) async {
    _books.addAll(books);
  }

  void setError() {
    _isError = true;
  }

  void _setInitialBooks() {
    for (var book in initialBooks) {
      if (!_books.any((b) => b.id == book.id)) {
        _books.add(book);
      }
    }
  }
}
