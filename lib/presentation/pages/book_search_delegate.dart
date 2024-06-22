import 'package:flutter/material.dart';
import 'package:flutter_book_manager/domain/entities/book.dart';
import 'package:flutter_book_manager/presentation/notifiers/book_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookSearchDelegate extends SearchDelegate<Book?> {
  final WidgetRef ref;
  final Function(Book) navigateToDetail;

  BookSearchDelegate({required this.ref, required this.navigateToDetail});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }
 
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final books = ref.read(bookNotifierProvider).books.where((book) {
      return book.title.toLowerCase().contains(query.toLowerCase()) ||
          book.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (books.isEmpty) {
      return Center(child: Text('No results found.'));
    }

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.description),
          onTap: () {
            navigateToDetail(book);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final books = ref.read(bookNotifierProvider).books.where((book) {
      return book.title.toLowerCase().contains(query.toLowerCase()) ||
          book.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.description),
          onTap: () {
            query = book.title;
            navigateToDetail(book);
          },
        );
      },
    );
  }
}
