import 'package:flutter/material.dart';
import 'package:toko_farda_mobile/drawer.dart';
import 'package:toko_farda_mobile/profil/alamat.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State {
  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      // body: Container(
      //   color: Colors.blue,
      // ),
      appBar: AppBar(
        title: Text("Toko Farda Mobile"),
      ),
      body: (ProfilPage()),
    );
  }
}
