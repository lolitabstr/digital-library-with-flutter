import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'insert.dart';
import 'update.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

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

    setState(() {
      books = List<Map<String, dynamic>>.from(response);
    });
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
        const SnackBar(content: Text('Book deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $response')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchBooks, // Tombol untuk refresh data
          ),
        ],
      ),
      body: books.isEmpty
          ? const Center(child: CircularProgressIndicator()) // CirucularProgressIndicator adalah widget untuk menampilkan loading indikator
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  // Menampilkan gambar di sisi kiri ListTile
                  // leading: book['ava'] != null 
                  // ? Image.network(
                  //   book['ava'], // URL gambar dari Supabase
                  //   width: 50,        // Lebar gambar
                  //   height: 50,       // Tinggi gambar
                  //   fit: BoxFit.cover, // Menjaga agar gambar sesuai dalam kotak
                  // )
                  // : const Icon(Icons.book, size: 50), // Ikon default jika URL gambar kosong
                  title: Text(book['title'] ?? 'No Title', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book['author'] ?? 'No Author', style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                      Text(book['description'] ?? 'No Description', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol edit
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
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
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Konfirmasi sebelum menghapus buku
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Book'),
                                content: const Text('Are you sure you want to delete this book?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await deleteBook(book['id']);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Delete'),
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
                  MaterialPageRoute(builder: (context) => const AddBookPage()),
                );
              },
              child: const Icon(Icons.add),
        ),
    );
  }
}
