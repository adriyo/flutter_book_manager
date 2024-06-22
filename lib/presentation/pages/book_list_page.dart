import 'package:flutter/material.dart';
import 'package:flutter_book_manager/domain/entities/book.dart';
import 'package:flutter_book_manager/presentation/notifiers/book_notifier.dart';
import 'package:flutter_book_manager/presentation/pages/book_form_page.dart';
import 'package:flutter_book_manager/presentation/pages/book_list_widget.dart';
import 'package:flutter_book_manager/presentation/pages/book_search_delegate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(bookNotifierProvider);
    final bookNotifier = ref.read(bookNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Book List'),
        actions: [
          IconButton(
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: BookSearchDelegate(
                  ref: ref,
                  navigateToDetail: (book) {
                    navigateToDetail(context: context, book: book);
                  },
                ),
              );
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: _buildContent(
        context: context,
        uiState: uiState,
        onDelete: (id) {
          bookNotifier.deleteBook(id);
        },
        onEdit: (book) {
          navigateToDetail(context: context, book: book);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(context: context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void navigateToDetail({required BuildContext context, Book? book = null}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookFormPage(book: book),
      ),
    );
  }
}

Widget _buildContent(
    {required BuildContext context,
    required UiState uiState,
    required Function(Book) onEdit,
    required Function(int) onDelete}) {
  final books = uiState.books;
  if (uiState.isLoading) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  if (books.isEmpty) {
    return Center(child: Text('No books available'));
  }
  return BookListWidget(
    books: books,
    onEdit: onEdit,
    onDelete: onDelete,
  );
}
