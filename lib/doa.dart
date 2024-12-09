import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HadithPage extends StatefulWidget {
  @override
  _HadithPageState createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage> {
  List booksList = [];

  @override
  void initState() {
    super.initState();
    ambilDaftarBukuHadits();
  }

  // Fungsi untuk mengambil daftar buku dari API
  Future<void> ambilDaftarBukuHadits() async {
    final response = await http.get(Uri.parse('https://api.hadith.gading.dev/books'));

    if (response.statusCode == 200) {
      setState(() {
        booksList = json.decode(response.body); // Menyimpan daftar buku
      });
    } else {
      throw Exception('Gagal memuat daftar buku hadits');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Buku Hadits'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: booksList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: booksList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(booksList[index]['name']),
                    subtitle: Text('ID: ${booksList[index]['id']}'),
                  );
                },
              ),
      ),
    );
  }
}
