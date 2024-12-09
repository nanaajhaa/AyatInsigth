import 'dart:convert';
import 'package:flutter/material.dart';
import 'tafsir.dart';
import 'package:http/http.dart' as http;

class QuranPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quran', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pink, // Warna pink untuk AppBar
        elevation: 2, // Bayangan ringan untuk AppBar
      ),
      body: SingleChildScrollView(
        child: QuranListView(),
      ),
    );
  }
}

class QuranListView extends StatefulWidget {
  @override
  _QuranListViewState createState() => _QuranListViewState();
}

class _QuranListViewState extends State<QuranListView> {
  List surah = [];

  @override
  void initState() {
    super.initState();
    ambilDaftarSurah();
  }

  Future<void> ambilDaftarSurah() async {
    final response = await http.get(Uri.parse('https://equran.id/api/v2/surat'));
    if (response.statusCode == 200) {
      setState(() {
        surah = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Gagal memuat daftar surah');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0), // Margin lebih kecil
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daftar Surah',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink), // Header warna pink
          ),
          SizedBox(height: 10), // Jarak antar elemen lebih kecil
          surah.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: surah.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5.0), // Margin antar card lebih kecil
                      elevation: 2.0, // Bayangan ringan
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Sudut kotak lebih kecil
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10.0), // Padding dalam card lebih kecil
                        title: Text(
                          surah[index]['namaLatin'],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.pink), // Teks judul warna pink
                        ),
                        subtitle: Text(
                          '${surah[index]['jumlahAyat']} Ayat • ${surah[index]['tempatTurun']}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]), // Subtitle lebih kecil
                        ),
                        trailing: CircleAvatar(
                          radius: 12, // Ukuran lingkaran lebih kecil
                          backgroundColor: Colors.pink, // Warna lingkaran pink
                          child: Text(
                            surah[index]['nomor'].toString(),
                            style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold), // Nomor lebih kecil
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TafsirDetailPage(surah[index]['nomor']),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
