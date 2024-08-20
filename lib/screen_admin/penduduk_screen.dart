import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:sidedi/screen/home_screen.dart';
import 'package:sidedi/screen/rt_screen.dart';
import 'package:sidedi/screen_admin/penduduk_add_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sidedi/screen_admin/penduduk_detail_screen.dart';
import 'package:sidedi/screen_admin/penduduk_edit_screen.dart';
import '../Models/kk_model.dart';
import 'package:sidedi/screen_admin/profesi_add.screen.dart';

class PendudukScreen extends StatefulWidget {
  final String? role;
  const PendudukScreen({this.role});

  @override
  State<PendudukScreen> createState() => _PendudukScreenState();
}

class _PendudukScreenState extends State<PendudukScreen> {
  int pages = 1;
  int _currentPage = 0;
  String check = '1';

  //
  @override
  void initState() {
    super.initState();
    //in first time, this method will be executed
    getTotalData();
    _get_role();
  }

  String? role_pengguna;

  _get_role() async {
    final storage = new FlutterSecureStorage();
    role_pengguna = await storage.read(key: 'role');
    print(role_pengguna);
  }

  Future<List> getTotalData() async {
    var _currentPagePagination = (_currentPage + 1);
    String token =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYXBpL2xvZ2luIiwiaWF0IjoxNzIwNzEzNjY1LCJleHAiOjE3MjA3MTcyNjUsIm5iZiI6MTcyMDcxMzY2NSwianRpIjoiOTV3UFVhbEpsYnlaZ1ZPUiIsInN1YiI6IjEiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.HUoVxlDj-3O5SHtWOAcfJnMCXgHjFm9WppTeOVq1NZE";
    final response = await http.get(
      Uri.parse(
          "http://192.168.0.107:8000/api/penduduk-index/$_currentPagePagination"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var data = json.decode(response.body);
    print(data);
    if (check == '1') {
      setState(() {
        pages = data['data']['last_page'];
        check = '2';
      });
    }
    return data['data']['data'];
  }

  var no_kkController;

  Future<List<KkModel>> getKk() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.0.107:8000/api/kk-index'));
      final body = json.decode(response.body) as List;
      if (response.statusCode == 200) {
        return body.map((dynamic json) {
          final map = json as Map<String, dynamic>;
          return KkModel(
            no_kk: map['no_kk'] as String,
            nama_kk: map['nama_kk'] as String,
          );
        }).toList();
      }
    } on SocketException {
      await Future.delayed(const Duration(milliseconds: 1800));
      throw Exception('No Internet Connection');
    } on TimeoutException {
      throw Exception('');
    }
    throw Exception('error fetching data');
  }

  @override
  Widget build(BuildContext context) {
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
                  return role_pengguna == 'rt'
                      ? RtScreen(role: role_pengguna)
                      : HomeScreen();
                },
              ),
            );
          },
        ),
        title: Text("Data Penduduk"),
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
                          return PendudukAddScreen();
                        },
                      ),
                    );
                  },
                  child: Text(
                    "Tambah Data",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10),
                //   child: Row(
                //     children: [
                //       Container(
                //         width: 100,
                //         color: Colors.grey[100],
                //         child: TextFormField(
                //           decoration: const InputDecoration(
                //             border: OutlineInputBorder(),
                //             labelText: "Nama",
                //           ),
                //           // controller: ,
                //         ),
                //       ),
                //       SizedBox(
                //         width: 10,
                //       ),
                //       Container(
                //         width: 200,
                //         color: Colors.grey[100],
                //         child: FutureBuilder<List<KkModel>>(
                //           future: getKk(),
                //           builder: (context, snapshot) {
                //             if (snapshot.hasData) {
                //               return DropdownButton(
                //                 // Initial Value
                //                 value: no_kkController,
                //                 hint: Text('Pilih No KK'),
                //                 isExpanded: true,
                //                 // Down Arrow Icon
                //                 icon: const Icon(Icons.keyboard_arrow_down),
                //                 // Array list of items
                //                 items: snapshot.data!.map((item) {
                //                   return DropdownMenuItem(
                //                     value: item.no_kk,
                //                     child: Text(item.nama_kk.toString()),
                //                   );
                //                 }).toList(),
                //                 onChanged: (value) {
                //                   no_kkController = value;
                //                   setState(() {
                //                     print(no_kkController);
                //                   });
                //                 },
                //               );
                //             } else {
                //               return Center(
                //                   child: const CircularProgressIndicator());
                //             }
                //           },
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
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
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                (i + 1).toString() +
                                    '. Nama : ${list[i]['nama_lengkap']}\nNama kepala Keluarga : ${list[i]['nama_kk']}',
                                style: TextStyle(
                                    fontFamily: "poppins", color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return PendudukDetailScreen(
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
                                      return PendudukEditScreen(
                                          nik: list[i]['nik']);
                                    },
                                  ),
                                );
                                print(list[i]['nik']);
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
                                  list[i]['nik'],
                                );
                              },
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

void deleteData(nik, BuildContext context) {
  print(nik);
  print('delete');
  var url = "http://192.168.0.107:8000/api/penduduk-hapus";
  http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer $token',
    },
    body: jsonEncode(
      {
        "nik": nik,
      },
    ),
  );
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) {
        return PendudukScreen();
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

showAlertDialog(BuildContext context, nik) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      deleteData(nik, context);
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
