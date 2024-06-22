import 'package:flutter_book_manager/domain/entities/book.dart';
import 'package:flutter_book_manager/presentation/notifiers/book_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_book_repository.dart';

void main() {
  late FakeBookRepository fakeRepository;
  late BookNotifier bookNotifier;

  setUp(() {
    fakeRepository = FakeBookRepository();
    bookNotifier = BookNotifier(repository: fakeRepository);
  });

  test('should handle fetchBooks given non empty books', () async {
    await bookNotifier.fetchBooks();
    expect(bookNotifier.state.books, isNotEmpty);
    expect(bookNotifier.state.isLoading, false);
  });

  test('should handle fetchBooks given exception', () async {
    fakeRepository.setError();
    await bookNotifier.fetchBooks();
    expect(bookNotifier.state.books, isEmpty);
  });

  test('should add a book and update state', () async {
    final book = Book(title: 'New Book', description: 'Description');
    await bookNotifier.saveBook(book);
    final resultBooks = await bookNotifier.state.books;
    expect(resultBooks[0].id, 1);
    expect(resultBooks[0].title, book.title);
  });

  test('should update a book and update state', () async {
    final book = Book(title: 'New Book', description: 'Description');
    await bookNotifier.saveBook(book);

    final updatedBook =
        Book(id: 1, title: 'Updated Book', description: 'Updated Description');
    await bookNotifier.saveBook(updatedBook);

    expect(bookNotifier.state.books, contains(updatedBook));
    expect(bookNotifier.state.books, isNot(contains(book)));
  });

  test('should delete a book and update state', () async {
    final book = Book(title: 'New Book', description: 'Description');
    await bookNotifier.saveBook(book);

    await bookNotifier.deleteBook(bookNotifier.state.books.first.id!);

    expect(bookNotifier.state.books, isEmpty);
  });
}
