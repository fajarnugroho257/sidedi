import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sidedi/datas/menu_data.dart';
import 'package:sidedi/rt_screen/surat_screen.dart';
import 'package:sidedi/screen/beranda_screen.dart';
import 'package:sidedi/screen/kk_screen.dart';
import 'package:sidedi/screen_admin/informasi_screen.dart';
import 'package:sidedi/screen_admin/kelahiran_screen.dart';
import 'package:sidedi/screen_admin/kematian_screen.dart';
import 'package:sidedi/screen_admin/profesi_screen.dart';
import 'package:sidedi/screen_admin/penduduk_screen.dart';
import 'package:sidedi/screen_admin/pengurus_screen.dart';

class RtScreen extends StatefulWidget {
  final String? role;
  RtScreen({required this.role});

  @override
  State<RtScreen> createState() => _RtScreenState();
}

class _RtScreenState extends State<RtScreen> {
  String? role_pengguna;
  String? name;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _get_role();
  }

  _get_role() async {
    final storage = new FlutterSecureStorage();
    role_pengguna = await storage.read(key: 'role');
    name = await storage.read(key: 'name');
    setState(() {
      name = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(this.role_pengguna);
    var roles = this.widget.role.toString().toUpperCase();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Center(
            child: Image.asset(
              'assets/images/sidedi.png',
              fit: BoxFit.fill,
              height: 75,
              width: 300,
              alignment: Alignment.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Selamat Datang\n$name',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 27, right: 27),
              child: Container(
                height: 600,
                child: GridView.count(
                  childAspectRatio: 2.5,
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    ...menuRt.map(
                      (icon) => GestureDetector(
                        onTap: () {
                          final page = icon.screen;
                          final title = icon.title;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return page == 'penduduk_screen'
                                    ? PendudukScreen(
                                        role: role_pengguna.toString(),
                                      )
                                    : page == 'informasi_screen'
                                        ? InformasiScreen(
                                            role: role_pengguna.toString(),
                                          )
                                        : title == 'Cari Ktp'
                                            ? SuratScreen(judul: 'Cari KTP')
                                            : title == 'Cari KK'
                                                ? SuratScreen(judul: 'Cari KK')
                                                : title ==
                                                        'Cari Surat Kelahiran'
                                                    ? SuratScreen(
                                                        judul:
                                                            'Cari Surat Kelahiran')
                                                    : title ==
                                                            'Cari Surat Kematian'
                                                        ? SuratScreen(
                                                            judul:
                                                                'Cari Surat Kematian')
                                                        : title ==
                                                                'Cari Surat Pindah Tempat'
                                                            ? SuratScreen(
                                                                judul:
                                                                    'Cari Surat Pindah Tempat')
                                                            : Scaffold();
                              },
                            ),
                          );
                        },
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromARGB(255, 22, 141, 201),
                                Color.fromARGB(255, 73, 115, 214)
                              ],
                            ),
                          ),
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Text(
                            icon.title,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showAlertDialog(context);
            },
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20, bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromARGB(255, 22, 141, 201),
                      Color.fromARGB(255, 73, 115, 214)
                    ],
                  ),
                ),
                height: 40,
                width: 100,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Keluar',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'poppins',
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return BerandaScreen();
          },
        ),
      );
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Keluar"),
    content: Text("Apakah anda yakin ingin keluar."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
