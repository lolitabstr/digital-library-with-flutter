// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // Variabel untuk menyimpan URL gambar yang berhasil diunggah
  // Uint8List? _selectedImageBytes;
  // String? _imageUrl;

// Fungsi untuk memilih gambar
  // Future<void> _pickImage() async {
  //   final result = await FilePicker.platform.pickFiles(type: FileType.image);
  //   if (result != null && result.files.single.bytes != null) {
  //     setState(() {
  //       _selectedImageBytes = result.files.single.bytes;
  //       _imageUrl = result.files.single.name;
  //     });
  //   }
  // }

// Fungsi untuk mengunggah gambar ke Supabase
// Future<String?> _uploadImage() async {
//   if (_selectedImageBytes == null || _imageUrl == null) return null;

//     final storageResponse = await Supabase.instance.client.storage
//         .from('book_images')
//         .uploadBinary(_imageUrl!, _selectedImageBytes!);

//     if (storageResponse != null) {
//       print('Error uploading image: ${storageResponse}');
//       return null;
//     }

//     // Mendapatkan URL publik gambar yang diupload
//     final publicUrl = Supabase.instance.client.storage
//         .from('book_images')
//         .getPublicUrl(_imageUrl!);
//     return publicUrl;
// }


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

  // Upload gambar dan dapatkan URL-nya
  // final imageUrl = await _uploadImage();

  // Kirim data ke tabel 'books' di Supabase
  final response = await Supabase.instance.client
      .from('books')
      .insert({
        'title': title,
        'author': author,
        'description': description,
        // 'book_images': imageUrl, // Menyimpan URL gambar ke database
      });
      
      if (response != null) {
        // Jika ada error, tampilkan pesan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response}')),
        );
      } else {
        // Jika sukses, tampilkan pesan dan kosongkan form
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book added successfully!')),
        );
        _titleController.clear();
        _authorController.clear();
        _descriptionController.clear();
        // _imageUrl = null;

        // Kembali ke halaman utama dan kirimkan status true
        Navigator.pop(context, true);

        // Refresh daftar buku
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BookListPage()),
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Area untuk memilih gambar
              // _selectedImageBytes != null
              //     ? Image.memory(_selectedImageBytes!, height: 150)
              //     : const Text('No image selected'),
              // ElevatedButton(
              //   onPressed: _pickImage,
              //   child: const Text('Pick Image'),
              // ),
              // const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBook,
                child: const Text('Add Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
