import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class InputLokasiPage extends StatefulWidget {
  @override
  _InputLokasiPageState createState() => _InputLokasiPageState();
}

class _InputLokasiPageState extends State<InputLokasiPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jalanController = TextEditingController();
  final TextEditingController _detailAlamatController = TextEditingController();

  LatLng? _lokasiTerpilih;
  bool _tampilPeta = false;
  String? _alamatTersimpan;

  final MapController _mapController = MapController();

  // ambil lokasi sekarang
  Future<void> _ambilLokasiSaatIni() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    final lokasi = LatLng(position.latitude, position.longitude);

    setState(() {
      _lokasiTerpilih = lokasi;
      _tampilPeta = true;
    });

    _mapController.move(lokasi, 15.0);
  }

// reverse gecoding
  Future<void> _ambilAlamatDariKoordinat(LatLng posisi) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        posisi.latitude,
        posisi.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark p = placemarks.first;
        setState(() {
          _alamatTersimpan = "${p.street}, ${p.subLocality}, ${p.locality}";
        });
      }
    } catch (e) {
      print("Gagal mengambil alamat: $e");
    }
  }

  // cari alamat
  // Future<void> _cariAlamat() async {
  //   try {
  //     List<Location> locations =
  //         await locationFromAddress(_alamatController.text);
  //     if (locations.isNotEmpty) {
  //       setState(() {
  //         _lokasiTerpilih =
  //             LatLng(locations.first.latitude, locations.first.longitude);
  //       });
  //       if (_tampilPeta) {
  //         _mapController.move(_lokasiTerpilih!, 15.0);
  //       }
  //     }
  //   } catch (e) {
  //     print("Alamat tidak ditemukan: $e");
  //   }
  // }

  // forward gecoding
  Future<void> _cariAlamat() async {
    try {
      String alamat =
          "${_jalanController.text} ${_detailAlamatController.text}";
      if (alamat.isEmpty) return;

      List<Location> locations = await locationFromAddress(alamat);
      if (locations.isNotEmpty) {
        final lokasi =
            LatLng(locations.first.latitude, locations.first.longitude);
        setState(() {
          _lokasiTerpilih = lokasi;
          _tampilPeta = true;
        });
        _mapController.move(lokasi, 15.0);
      }
    } catch (e) {
      print("Gagal mencari alamat: $e");
    }
  }

  // tombol simpan
  void _simpanLokasi() {
    if (_lokasiTerpilih != null) {
      _ambilAlamatDariKoordinat(_lokasiTerpilih!);
      setState(() {
        _tampilPeta = false;
      });
    }
  }
  // @override
  // void initState() {
  //   super.initState();
  //   _ambilLokasiSaatIni();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alamat")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- FORM INPUT ---
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    labelText: "Nama Lengkap",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _jalanController,
                  decoration: InputDecoration(
                    labelText: "Nama Jalan",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _detailAlamatController,
                  decoration: InputDecoration(
                    labelText: "Detail Alamat",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              // --- TOMBOL CARI ALAMAT DARI TEKS ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.search),
                  label: Text("Cari Alamat"),
                  onPressed: _cariAlamat, // akan tampilkan titik di peta
                ),
              ),

              // --- TOMBOL AMBIL LOKASI DARI GPS ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.gps_fixed),
                  label: Text("Ambil Lokasi Saat Ini"),
                  onPressed: _ambilLokasiSaatIni,
                ),
              ),

              // --- TOMBOL TAMPILKAN PETA SECARA MANUAL ---
              if (!_tampilPeta)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.map),
                    label: Text("Pilih Lokasi pada Peta"),
                    onPressed: () {
                      setState(() {
                        _tampilPeta = true;
                      });
                    },
                  ),
                ),

              // --- TOMBOL REVERSE GEOCODING (alamat dari titik) ---
              if (_lokasiTerpilih != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.location_on),
                    label: Text("Cari Nama Alamat dari Titik"),
                    onPressed: () {
                      _ambilAlamatDariKoordinat(_lokasiTerpilih!);
                    },
                  ),
                ),

              // --- TAMPILKAN PETA JIKA DIPERLUKAN ---
              if (_tampilPeta)
                Container(
                  height: 400,
                  child: Column(
                    children: [
                      Expanded(
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            center:
                                _lokasiTerpilih ?? LatLng(-7.7956, 110.3695),
                            zoom: 13,
                            onTap: (tapPosition, latlng) {
                              setState(() {
                                _lokasiTerpilih = latlng;
                              });
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c'],
                              userAgentPackageName: 'com.example.app',
                            ),
                            if (_lokasiTerpilih != null)
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: _lokasiTerpilih!,
                                    width: 40,
                                    height: 40,
                                    builder: (ctx) => Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.save),
                          label: Text("Simpan Lokasi"),
                          onPressed: _simpanLokasi,
                        ),
                      ),
                    ],
                  ),
                ),

              // --- ALAMAT YANG DISIMPAN DARI TITIK ---
              if (!_tampilPeta && _alamatTersimpan != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Alamat disimpan: $_alamatTersimpan",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
