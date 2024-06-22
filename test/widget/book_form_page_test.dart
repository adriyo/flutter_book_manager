import 'package:flutter/material.dart';
import 'package:flutter_book_manager/main.dart';
import 'package:flutter_book_manager/presentation/pages/book_form_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_book_repository.dart';

void main() {
  testWidgets('Add new book test', (WidgetTester tester) async {
    final fakeRepository = FakeBookRepository();
    fakeRepository.fetchBooks();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [bookRepositoryProvider.overrideWithValue(fakeRepository)],
        child: MaterialApp(
          home: BookFormPage(),
        ),
      ),
    );

    expect(find.text('Add Book'), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a title'), findsOneWidget);
    expect(find.text('Please enter a description'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Test Title');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'Test Description');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle(Duration(seconds: 3));

    expect(find.text('Please enter a title'), findsNothing);
    expect(find.text('Please enter a description'), findsNothing);

    final books = fakeRepository.books;
    expect(books.length, 3);
    expect(books.map((i) => i.title), contains('Test Title'));
    expect(books.map((i) => i.description), contains('Test Description'));
  });

  testWidgets('Edit existing book test', (WidgetTester tester) async {
    final fakeRepository = FakeBookRepository();
    final book = fakeRepository.initialBooks[0];
    fakeRepository.fetchBooks();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [bookRepositoryProvider.overrideWithValue(fakeRepository)],
        child: MaterialApp(
          home: BookFormPage(
            book: book,
          ),
        ),
      ),
    );

    expect(find.text('Edit Book'), findsOneWidget);
    expect(find.text(book.title), findsOneWidget);
    expect(find.text(book.description), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Updated Title');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'Updated Description');
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle(Duration(seconds: 3));

    final books = fakeRepository.books;
    expect(books.length, 2);
    expect(books.map((i) => i.title), contains('Updated Title'));
    expect(books.map((i) => i.description), contains('Updated Description'));
  });
}
