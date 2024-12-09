import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WaktuSholatPage extends StatefulWidget {
  @override
  _WaktuSholatPageState createState() => _WaktuSholatPageState();
}

class _WaktuSholatPageState extends State<WaktuSholatPage> {
  Map<String, String>? prayerTimes;
  String city = "Jakarta"; // Kota default
  String country = "Indonesia"; // Negara default
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    final year = selectedDate.year;
    final month = selectedDate.month;
    final day = selectedDate.day;
    final url = Uri.parse(
        'http://api.aladhan.com/v1/calendarByCity/$year/$month?city=$city&country=$country&method=2');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data'][day - 1]['timings'];
        setState(() {
          prayerTimes = {
            "Fajr": timings['Fajr'],
            "Dhuhr": timings['Dhuhr'],
            "Asr": timings['Asr'],
            "Maghrib": timings['Maghrib'],
            "Isha": timings['Isha'],
          };
        });
      } else {
        print("Failed to load prayer times: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching prayer times: $e");
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      fetchPrayerTimes();
    }
  }

  void updateLocation(String newCity, String newCountry) {
    setState(() {
      city = newCity;
      country = newCountry;
    });
    fetchPrayerTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waktu Shalat'),
        centerTitle: true,
        backgroundColor: Colors.pink, // Ubah menjadi warna pink
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 6,
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Waktu Shalat',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$city, $country',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tanggal: ${selectedDate.toLocal()}'.split(' ')[0],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: prayerTimes == null
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
                      children: prayerTimes!.entries
                          .map((entry) => Card(
                                elevation: 2,
                                child: ListTile(
                                  title: Text(
                                    entry.key,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  trailing: Text(
                                    entry.value,
                                    style: TextStyle(color: Colors.pink), // Ubah warna teks menjadi pink
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => selectDate(context),
                  icon: Icon(Icons.date_range),
                  label: Text('Pilih Tanggal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink, // Ubah warna button menjadi pink
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => LocationDialog(
                        onLocationSelected: updateLocation,
                      ),
                    );
                  },
                  icon: Icon(Icons.location_city),
                  label: Text('Ubah Lokasi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink, // Ubah warna button menjadi pink
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LocationDialog extends StatefulWidget {
  final Function(String, String) onLocationSelected;
  LocationDialog({required this.onLocationSelected});
  @override
  _LocationDialogState createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ubah Lokasi'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: cityController,
            decoration: InputDecoration(
              labelText: 'Kota',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: countryController,
            decoration: InputDecoration(
              labelText: 'Negara',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onLocationSelected(
              cityController.text,
              countryController.text,
            );
            Navigator.pop(context);
          },
          child: Text('Simpan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink, // Ubah warna button menjadi pink
          ),
        ),
      ],
    );
  }
}
