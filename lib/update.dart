import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditBookPage extends StatefulWidget {
  final Map<String, dynamic> book;

  EditBookPage({required this.book});

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book['title']);
    _authorController = TextEditingController(text: widget.book['author']);
    _descriptionController = TextEditingController(text: widget.book['description']);
  }

  Future<void> _updateBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text;
    final author = _authorController.text;
    final description = _descriptionController.text;

    final response = await Supabase.instance.client
        .from('books')
        .update({
          'title': title,
          'author': author,
          'description': description,
        })
        .eq('id', widget.book['id']); // Menggunakan ID buku untuk update

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book updated successfully!')),
      );
      Navigator.pop(context, true); // Kembali ke halaman home dan beri tahu ada perubahan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Book')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an author';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _updateBook,
                  child: Text('Update Book'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
