import 'home_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Fungsi untuk menyimpan buku ke Supabase
  Future<void> _addBook() async {
    // Validasi form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Ambil nilai dari controller
    final title = _titleController.text;
    final author = _authorController.text;
    final description = _descriptionController.text;

    // Kirim data ke tabel 'books' di Supabase
    final response = await Supabase.instance.client
        .from('books')
        .insert({
          'title': title,
          'author': author,
          'description': description,
        });

    if (response != null) {
      // Jika ada error, tampilkan pesan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response}')),
      );
    } else {
      // Jika sukses, tampilkan pesan dan kosongkan form
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book added successfully!')),
      );
      _titleController.clear();
      _authorController.clear();
      _descriptionController.clear();

      // Kembali ke halaman utama dan kirimkan status true
      Navigator.pop(context, true);

      // Refresh daftar buku
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BookListPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Book'),
      ),
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
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBook,
                child: Text('Add Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
