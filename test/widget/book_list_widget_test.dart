import 'package:flutter/material.dart';
import 'package:flutter_book_manager/domain/entities/book.dart';
import 'package:flutter_book_manager/presentation/pages/book_list_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BookListWidget displays books correctly', (WidgetTester tester) async {
    final books = [
      Book(id: 1, title: 'Book 1', description: 'Description 1'),
      Book(id: 2, title: 'Book 2', description: 'Description 2'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BookListWidget(books: books, onEdit: (book) {}, onDelete: (id) {}),
        ),
      ),
    );

    expect(find.text('Book 1'), findsOneWidget);
    expect(find.text('Book 2'), findsOneWidget);
  });

  testWidgets('BookListWidget calls onEdit and onDelete', (WidgetTester tester) async {
    final books = [
      Book(id: 1, title: 'Book 1', description: 'Description 1'),
    ];

    var editCalled = false;
    var deleteCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BookListWidget(
            books: books,
            onEdit: (book) {
              editCalled = true;
            },
            onDelete: (id) {
              deleteCalled = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    expect(editCalled, true);

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    expect(deleteCalled, true);
  });
}
