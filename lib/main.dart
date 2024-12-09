import 'dart:convert';
import 'package:flutter/material.dart';
import 'quran.dart';
import 'qiblat.dart';
import 'Juz.dart';
import 'doa.dart';
import 'tafsir.dart';
import 'detail_surat.dart';

void main() {
  runApp(AplikasiSaya());
}

class AplikasiSaya extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayarUtama(),
    );
  }
}

class LayarUtama extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink, // Mengubah warna AppBar menjadi pink
        title: Text("Layar Utama"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _bagianAtas(),
            _kutipanDoa(),
            _daftarJuz(context),
            _fiturBawah(context),
          ],
        ),
      ),
    );
  }

  // Widget untuk bagian atas dengan gambar
  Widget _bagianAtas() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://cendekiamuslim.or.id/uploads/images/202401/image_870x_65b86d303fa7b.jpg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
    );
  }

  // Widget untuk menampilkan kutipan doa
  Widget _kutipanDoa() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.pink, width: 2),
      ),
      child: Text(
        "Wahai yang Maha Pengasih lagi Maha Penyayang,\n"
        "Wahai yang menjadikan Al-Quran sebagai sebaik-baik pedoman,\n"
        "Ya Allah, tanpa kekuatan dari-Mu aku lemah,\n"
        "Tanpa petunjuk dari-Mu aku tersesat.",
        style: TextStyle(
          fontSize: 18,
          color: Colors.pink[800],
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Widget untuk menampilkan daftar Juz
  Widget _daftarJuz(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
            30,
            (index) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HalamanJuzPage(
                      juz: (index + 1).toString(),
                      edition: 'indo',
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.pink, width: 2), // Mengubah border ke pink
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Juz ${index + 1}',
                    style: TextStyle(
                      color: Colors.pink, // Mengubah teks ke pink
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan fitur-fitur di bagian bawah
  Widget _fiturBawah(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.pink.withOpacity(0.9), // Mengubah latar belakang bawah menjadi pink
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _itemFitur(context, Icons.book, 'Quran', QuranPage()),
          _itemFitur(context, Icons.explore, 'Waktu Sholat', WaktuSholatPage()),
          _itemFitur(
              context, Icons.volunteer_activism, 'Juz', HalamanJuzPage(juz: '1', edition: 'indo')),
          _itemFitur(context, Icons.notifications, 'Hadits', HadithPage()),
        ],
      ),
    );
  }

  // Widget untuk menampilkan item fitur
  Widget _itemFitur(BuildContext context, IconData icon, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30, color: Colors.white),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 10, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
