import 'package:flutter/material.dart';
import 'package:flutter_book_manager/domain/entities/book.dart';
import 'package:flutter_book_manager/presentation/notifiers/book_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookFormPage extends ConsumerStatefulWidget {
  final Book? book;

  BookFormPage({this.book});

  @override
  _BookFormPageState createState() => _BookFormPageState();
}

class _BookFormPageState extends ConsumerState<BookFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _title = widget.book?.title ?? '';
    _description = widget.book?.description ?? '';
    _titleController = TextEditingController(text: widget.book?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.book?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'Add Book' : 'Edit Book'),
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final book = Book(
                  id: widget.book?.id,
                  title: _title,
                  description: _description,
                );
                await ref.read(bookNotifierProvider.notifier).saveBook(book);
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              Expanded(
                child: TextFormField(
                  maxLines: null,
                  expands: true,
                  initialValue: _description,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
