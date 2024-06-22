import 'package:flutter/material.dart';
import 'package:flutter_book_manager/domain/entities/book.dart';

class BookListWidget extends StatelessWidget {
  final List<Book> books;
  final Function(Book) onEdit;
  final Function(int) onDelete;

  BookListWidget({
    required this.books,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: kFloatingActionButtonMargin + 50),
      itemCount: books.length,
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemBuilder: (context, index) {
        final book = books[index];
        return ListTile(
          title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            book.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => onEdit(book),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => onDelete(book.id!),
              ),
            ],
          ),
        );
      },
    );
  }
}
