import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HalamanJuzPage extends StatefulWidget {
  final String juz;
  final String edition;
  HalamanJuzPage({required this.juz, required this.edition});

  @override
  _HalamanJuzPageState createState() => _HalamanJuzPageState();
}

class _HalamanJuzPageState extends State<HalamanJuzPage> {
  late Future<Map<String, dynamic>> juzData;

  @override
  void initState() {
    super.initState();
    juzData = fetchJuzData();
  }

  Future<Map<String, dynamic>> fetchJuzData() async {
    final response = await http.get(
      Uri.parse('http://api.alquran.cloud/v1/juz/${widget.juz}/${widget.edition}'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load juz data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juz ${widget.juz}'),
        backgroundColor: Colors.pink, // Change to pink
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: juzData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var data = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: data['data']['ayahs'].length,
              itemBuilder: (context, index) {
                var ayah = data['data']['ayahs'][index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(
                      ayah['text'],
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      'Surah: ${ayah['surah']['name']} - Ayat: ${ayah['numberInSurah']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
