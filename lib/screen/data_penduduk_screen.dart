import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sidedi/screen/beranda_screen.dart';
import 'package:sidedi/screen/data_penduduk_detail_screen.dart';
import 'package:sidedi/screen/login_screen.dart';

class DataPendudukScreen extends StatefulWidget {
  const DataPendudukScreen({super.key});

  @override
  State<DataPendudukScreen> createState() => _DataPendudukScreenState();
}

class _DataPendudukScreenState extends State<DataPendudukScreen> {
  final params = TextEditingController();
  var dataCari;
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Penduduk'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.login_outlined),
            tooltip: 'Show Snackbar',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 50,
            ),
            ListTile(
              leading: Icon(
                Icons.info,
              ),
              title: const Text('Informasi Desa'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return BerandaScreen();
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle,
              ),
              title: const Text('Data Penduduk'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return DataPendudukScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 195, 242, 244),
              Color.fromARGB(255, 95, 219, 219)
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(
                  height: 18,
                ),
                TextFormField(
                  controller: params,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Masukkan NIK / Nama Warga',
                    labelText: 'Cari Data Penduduk',
                    suffixIcon: IconButton(
                      onPressed: () {
                        // print(params.text);
                        setState(() {
                          dataCari = params.text;
                          DaftarData(
                            dataParams: params.text,
                          );
                        });
                      },
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: DaftarData(
                      dataParams: dataCari == null ? 'xxxxxxxxx' : dataCari),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DaftarData extends StatefulWidget {
  String? dataParams;
  DaftarData({this.dataParams});

  @override
  State<DaftarData> createState() => _DaftarDataState();
}

class _DaftarDataState extends State<DaftarData> {
  Future<List> getTotalData() async {
    var params = widget.dataParams;
    final response = await http.post(
      Uri.parse("http://192.168.0.107:8000/api/penduduk-cari-proses"),
      body: {
        'params': params,
      },
    );
    var data = json.decode(response.body);
    // print(data);
    return data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: getTotalData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? ItemList(
                list: snapshot.data ?? [],
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({required this.list});

  @override
  Widget build(BuildContext context) {
    return list.length > 0
        ? ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 188, 188, 188),
                              blurRadius: 4,
                              offset: Offset(4, 4), // Shadow position
                            ),
                          ],
                        ),
                        //
                        // height: 500,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 230,
                                    child: Text(
                                      (i + 1).toString() +
                                          '. Nama Warga : ${list[i]['nama_lengkap']}, \n NIK : ${list[i]['nik']}',
                                      style: TextStyle(
                                        fontFamily: "poppins",
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return DataPendudukDetailScreen(
                                                nik_params: list[i]['nik']);
                                          },
                                        ),
                                      );
                                      print(list[i]['nik']);
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.remove_red_eye_sharp,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        : Text('Data tidak ditemukan');
  }
}
