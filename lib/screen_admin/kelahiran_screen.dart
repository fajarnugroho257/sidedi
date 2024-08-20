import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:sidedi/screen/home_screen.dart';
import 'package:sidedi/screen_admin/informasi_add_screen.dart';
import 'package:sidedi/screen_admin/kelahiran_add_screen.dart';
import 'package:sidedi/screen_admin/kelahiran_detail_screen.dart';
import 'package:sidedi/screen_admin/kelahiran_edit_screen.dart';
import 'package:sidedi/screen_admin/penduduk_add_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sidedi/screen_admin/penduduk_edit_screen.dart';
import 'package:sidedi/screen_admin/profesi_add.screen.dart';

class KelahiranScreen extends StatefulWidget {
  const KelahiranScreen({super.key});

  @override
  State<KelahiranScreen> createState() => _KelahiranScreenState();
}

class _KelahiranScreenState extends State<KelahiranScreen> {
  int pages = 1;
  int _currentPage = 0;
  String check = '1';

  @override
  Widget build(BuildContext context) {
    //
    getTotalData();
    //
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return HomeScreen();
                },
              ),
            );
          },
        ),
        title: Text("Data Kelahiran Warga"),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MaterialButton(
                  color: Color.fromARGB(255, 93, 201, 96),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return kelahiranAddScreen();
                        },
                      ),
                    );
                  },
                  child: Text(
                    "Tambah Data",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: FutureBuilder<List>(
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
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                NumberPaginator(
                  config: NumberPaginatorUIConfig(
                    buttonSelectedForegroundColor: Colors.black,
                    buttonSelectedBackgroundColor:
                        Color.fromARGB(255, 255, 255, 255),
                  ),
                  // by default, the paginator shows numbers as center content
                  numberPages: pages,
                  onPageChange: (int index) {
                    setState(
                      () {
                        _currentPage = index;
                        print(index);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List> getTotalData() async {
    var _currentPagePagination = (_currentPage + 1);
    final response = await http.get(
      Uri.parse(
          "http://192.168.0.107:8000/api/kelahiran-index/$_currentPagePagination"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
    );
    var data = json.decode(response.body);
    // print(data);
    if (check == '1') {
      setState(() {
        pages = data['data']['last_page'];
        check = '2';
      });
    }
    return data['data']['data'];
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list.length,
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
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromARGB(255, 22, 141, 201),
                        Color.fromARGB(255, 73, 115, 214)
                      ],
                    ),
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
                                    '. Nama Anak : ${list[i]['nama_anak']}, \n NIK : ${list[i]['nik']}',
                                style: TextStyle(
                                  fontFamily: "poppins",
                                  color: Colors.white,
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
                                      return KelahiranDetailScreen(
                                          kelahiran_id_params: list[i]
                                              ['kelahiran_id']);
                                    },
                                  ),
                                );
                                print(list[i]['nik']);
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.remove_red_eye_sharp,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return KelahiranEditScreen(
                                          kelahiran_id: list[i]['kelahiran_id']
                                              .toString());
                                    },
                                  ),
                                );
                                print(list[i]['kelahiran_id']);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.create_outlined,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showAlertDialog(
                                  context,
                                  list[i]['kelahiran_id'],
                                );
                              },
                              // onTap: () {
                              //   deleteData(list[i]['kelahiran_id'], context);
                              //   // print(list[i]['kelahiran_id']);
                              // },
                              child: Row(
                                children: [
                                  Icon(Icons.restore_from_trash,
                                      color: Colors.red[400]),
                                ],
                              ),
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
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

void deleteData(kelahiran_id, BuildContext context) {
  print(kelahiran_id);
  print('delete');
  var url = "http://192.168.0.107:8000/api/hapus-kelahiran";
  http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer $token',
    },
    body: jsonEncode(
      {
        "kelahiran_id": kelahiran_id,
      },
    ),
  );
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) {
        return KelahiranScreen();
      },
    ),
  );
  _DeleteData(context, "Data berhasil dihapus");
}

void _DeleteData(BuildContext context, String error) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(error),
      action:
          SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

showAlertDialog(BuildContext context, kelahiran_id) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      deleteData(kelahiran_id, context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Hapus"),
    content: Text("Apakah anda yakin menghapus data ini ?."),
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
