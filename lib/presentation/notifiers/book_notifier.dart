import 'package:flutter_book_manager/domain/entities/book.dart';
import 'package:flutter_book_manager/domain/repositories/book_repository.dart';
import 'package:flutter_book_manager/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookNotifier extends StateNotifier<UiState> {
  final BookRepository repository;

  BookNotifier({
    required this.repository,
  }) : super(UiState(books: [])) {
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 5));
    await repository.fetchBooks();
    final books = await repository.getBooks();
    state = state.copyWith(isLoading: false, books: books);
  }

  Future<void> saveBook(Book book) async {
    await repository.saveBook(book);
    state = state.copyWith(books: await getBooks());
  }

  Future<void> deleteBook(int id) async {
    await repository.deleteBook(id);
    state = state.copyWith(books: await getBooks());
  }

  Future<List<Book>> getBooks() async {
    return repository.getBooks();
  }

  Future<void> saveBooks(List<Book> books) async {
    await repository.saveBooks(books);
    state = state.copyWith(books: await getBooks());
  }
}

final bookNotifierProvider =
    StateNotifierProvider<BookNotifier, UiState>((ref) {
  return BookNotifier(repository: ref.watch(bookRepositoryProvider));
});

class UiState {
  final bool isLoading;
  final List<Book> books;

  UiState({this.isLoading = false, required this.books});

  UiState copyWith({bool? isLoading, List<Book>? books}) {
    return UiState(
      isLoading: isLoading ?? this.isLoading,
      books: books ?? this.books,
    );
  }
}
