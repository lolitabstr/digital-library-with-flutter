import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'insert.dart';
import 'update.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  // Buat variabel untuk menyimpan daftar buku
  List<Map<String, dynamic>> books = [];

  @override
  void initState() {
    super.initState();
    fetchBooks(); // Panggil fungsi untuk fetch data buku
  }

  // Fungsi untuk mengambil data buku dari Supabase
  Future<void> fetchBooks() async {
    final response = await Supabase.instance.client
        .from('books')
        .select();

    if (response != null) {
      setState(() {
        books = List<Map<String, dynamic>>.from(response);
      });
    } else {
      // Tampilkan error jika ada
      print('Error fetching books: ${response}');
    }
  }

  // Fungsi untuk menghapus buku dari Supabase
  Future<void> deleteBook(int id) async {
    final response = await Supabase.instance.client
        .from('books')
        .delete()
        .eq('id', id); // Menentukan ID buku yang ingin dihapus

    if (response == null) {
      // Jika berhasil, hapus buku dari daftar dan perbarui tampilan
      setState(() {
        books.removeWhere((book) => book['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.error!.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Buku'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchBooks, // Tombol untuk refresh data
          ),
        ],
      ),
      body: books.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  title: Text(book['title'] ?? 'No Title'),
                  subtitle: Text(book['description'] ?? 'No Description'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol edit
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Arahkan ke halaman EditBookPage dengan mengirimkan data buku
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBookPage(book: book),
                            ),
                          ).then((_) {
                            fetchBooks(); // Refresh data setelah kembali dari halaman edit
                          });
                        },
                      ),
                      // Tombol delete
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Konfirmasi sebelum menghapus buku
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Book'),
                                content: Text('Are you sure you want to delete this book?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await deleteBook(book['id']);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddBookPage()),
                );
            },
            child: Icon(Icons.add),
        ),
    );
  }
}
