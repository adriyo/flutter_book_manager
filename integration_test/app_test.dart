import 'package:flutter/material.dart';
import 'package:flutter_book_manager/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/fake_book_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full app test', (WidgetTester tester) async {
    final fakeRepository = FakeBookRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [bookRepositoryProvider.overrideWithValue(fakeRepository)],
        child: MyApp(),
      ),
    );

    // Fetch books
    expect(find.text('Book List'), findsOne);
    await tester.pumpAndSettle(Duration(seconds: 2));
    expect(find.text(fakeRepository.books[0].title), findsOneWidget);

    // Add new book
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'New Book');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'New Book Description');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsAtLeastNWidgets(3));
    expect(find.text('New Book'), findsOneWidget);

    // Update the book
    var listTile = find.ancestor(
      of: find.text('New Book'),
      matching: find.byType(ListTile),
    );
    final editIcon = find.descendant(
      of: listTile,
      matching: find.byIcon(Icons.edit),
    );

    expect(editIcon, findsOneWidget);
    await tester.tap(editIcon);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Updated Book');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'Updated Description');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.text('Updated Book'), findsOneWidget);

    // Delete all books one by one
    while (find.byType(ListTile).evaluate().isNotEmpty) {
      listTile = find.byType(ListTile).first;
      final deleteIcon = find.descendant(
        of: listTile,
        matching: find.byIcon(Icons.delete),
      );

      expect(deleteIcon, findsOneWidget);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();
    }

    // Verify empty state 
    expect(find.byType(ListTile), findsNothing);
    expect(find.text('No books available'), findsOneWidget);
  });
}
