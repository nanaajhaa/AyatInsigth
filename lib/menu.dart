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
  const AplikasiSaya({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink, // Mengganti tema dengan warna pink
        scaffoldBackgroundColor: Colors.pink[50], // Latar belakang menggunakan warna pink terang
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.pink[100], // Menggunakan warna pink
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Gambar dari URL
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://infaqberkah.id/wp-content/uploads/2023/08/1426962971.jpg'),
                  ),
                  SizedBox(height: 10),
                  // Teks di bawah gambar
                  Text(
                    'TPQ Nurul Huda',
                    style: TextStyle(
                      color: Colors.yellow[100],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  // Tombol "Masuk"
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.yellow[100], // Warna tombol
                      foregroundColor: Colors.pink, // Warna teks tombol
                    ),
                    onPressed: () {
                      // Navigasi ke layar utama
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LayarUtama()),
                      );
                    },
                    child: Text(
                      'Masuk',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            // Menambahkan bayangan masjid di bagian bawah
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.network(
                'https://cdn.pixabay.com/photo/2021/03/12/01/27/mosque-6088456_1280.png',
                fit: BoxFit.cover,
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LayarUtama extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink, // Warna appBar diubah jadi pink
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LandingPage()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _bagianAtas(),
            _daftarJuz(context),
            _fiturBawah(context),
          ],
        ),
      ),
    );
  }

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
                  border: Border.all(color: Colors.pink, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Juz ${index + 1}',
                    style: TextStyle(
                      color: Colors.pink, // Ganti warna teks jadi pink
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

  Widget _fiturBawah(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.pink.withOpacity(0.9), // Latar belakang bawah dengan warna pink
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _itemFitur(context, Icons.book, 'Quran', QuranPage()),
          _itemFitur(context, Icons.explore, 'Waktu Sholat', WaktuSholatPage()),
          _itemFitur(context, Icons.volunteer_activism, 'Juz', HalamanJuzPage(juz: '1', edition: 'indo')),
          _itemFitur(context, Icons.notifications, 'Hadits', HadithPage()),
        ],
      ),
    );
  }

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
