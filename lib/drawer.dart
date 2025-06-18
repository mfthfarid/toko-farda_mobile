import 'package:flutter/material.dart';
// import 'package:kaspin/login/login.dart'; // Belum perlu logout

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 36, 34, 32),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===================== HEADER ====================
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('data/profile.png'),
                    radius: 30,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Nama Pengguna",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Admin",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white54),

            // ===================== MENU ITEM ====================
            ListTile(
              selected: selectedIndex == 1,
              leading: const Icon(Icons.money_rounded, color: Colors.white),
              title: const Text("Penjualan",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
                // Navigator.push(
                //   context,
                //     MaterialPageRoute(builder: (_) => const Penjualan())
                // );
              },
            ),
            ListTile(
              selected: selectedIndex == 2,
              leading:
                  const Icon(Icons.restore_page_outlined, color: Colors.white),
              title: const Text("Retur Penjualan",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (_) => const Retur()));
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.supervisor_account_rounded,
                  color: Colors.white),
              title: const Text("Pelanggan",
                  style: TextStyle(color: Colors.white)),
              children: [
                ListTile(
                  leading: const Icon(Icons.add, color: Colors.white),
                  title: const Text("Tambah Pelanggan",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      selectedIndex = 3;
                    });
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => const AddPelanggan()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list, color: Colors.white),
                  title: const Text("Data Pelanggan",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => const DataPelanggan()));
                  },
                ),
              ],
            ),

            // ===================== LOGOUT (opsional) ====================
            // ListTile(
            //   leading: const Icon(Icons.logout_outlined, color: Colors.white),
            //   title: const Text("Log Out", style: TextStyle(color: Colors.white)),
            //   onTap: () {
            //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
