import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();

  double? latitude;
  double? longitude;

  Future<void> ambilLokasi() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Layanan lokasi tidak aktif');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi ditolak');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Izin lokasi ditolak permanen');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  void simpanData() {
    // di sini nanti kita akan kirim ke server
    print("Nama: ${namaController.text}");
    print("Alamat: ${alamatController.text}");
    print("Latitude: $latitude");
    print("Longitude: $longitude");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 16),
            Text(latitude == null
                ? 'Koordinat belum diambil'
                : 'Lat: $latitude, Long: $longitude'),
            ElevatedButton(
              onPressed: ambilLokasi,
              child: Text('Ambil Lokasi Saya Sekarang'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: simpanData,
              child: Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}
