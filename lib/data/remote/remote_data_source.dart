import 'dart:convert';
import 'dart:developer';
import 'package:flutter_book_manager/domain/entities/book.dart';
import 'package:http/http.dart' as http;

class RemoteDataSource {
  final String baseUrl = 
    'https://dummy-api-express.vercel.app/api/';

  Future<List<Book>> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl + 'books'));
      log('response: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Book.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }
}
