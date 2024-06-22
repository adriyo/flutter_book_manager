import 'package:flutter_book_manager/domain/entities/book.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class LocalDataSource {
  final Future<Database> database;

  LocalDataSource({required this.database});

  Future<List<Book>> fetchBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  Future<void> addBook(Book book) async {
    final db = await database;
    await db.insert('books', book.toMap());
  }

  Future<void> updateBook(Book book) async {
    final db = await database;
    await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<void> deleteBook(int id) async {
    final db = await database;
    await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Book?> findById(int id) async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Book.fromMap(maps.first);
  }

  Future<void> saveBooks(List<Book> books) async {
    final db = await database;
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var book in books) {
        batch.insert('books', book.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      await batch.commit();
    });
  }

  Future<void> saveBook(Book book) async {
    if (book.id == null) {
      await addBook(book);
    } else {
      await updateBook(book);
    }
  }
}
