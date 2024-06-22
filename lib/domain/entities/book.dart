import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final int? id;
  final String title;
  final String description;

  Book({
    this.id,
    required this.title,
    required this.description,
  });

  Book copyWith({int? id, String? title, String? description}) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [id, title, description];
}
