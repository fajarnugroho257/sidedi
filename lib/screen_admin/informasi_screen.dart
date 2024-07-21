import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:sidedi/screen/home_screen.dart';
import 'package:sidedi/screen/rt_screen.dart';
import 'package:sidedi/screen_admin/informasi_add_screen.dart';
import 'package:sidedi/screen_admin/penduduk_add_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sidedi/screen_admin/penduduk_edit_screen.dart';
import 'package:sidedi/screen_admin/profesi_add.screen.dart';

class InformasiScreen extends StatefulWidget {
  final String? role;
  const InformasiScreen({this.role});

  @override
  State<InformasiScreen> createState() => _InformasiScreenState();
}

class _InformasiScreenState extends State<InformasiScreen> {
  int pages = 1;
  int _currentPage = 0;
  String check = '1';

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

  @override
  Widget build(BuildContext context) {
    var role = this.widget.role;
    return Scaffold(
      appBar: AppBar(
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
        title: Text("Data Informasi Warga"),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
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
                          return InformasiAddScreen();
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
    print(_currentPagePagination);
    String token =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYXBpL2xvZ2luIiwiaWF0IjoxNzIwNzEzNjY1LCJleHAiOjE3MjA3MTcyNjUsIm5iZiI6MTcyMDcxMzY2NSwianRpIjoiOTV3UFVhbEpsYnlaZ1ZPUiIsInN1YiI6IjEiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.HUoVxlDj-3O5SHtWOAcfJnMCXgHjFm9WppTeOVq1NZE";
    final response = await http.get(
      Uri.parse(
          "http://192.168.1.103:8000/api/info-index/$_currentPagePagination"),
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
                    color: Color.fromARGB(255, 255, 255, 255),
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
                              width: 260,
                              child: Text(
                                (i + 1).toString() +
                                    '. Deskripsi : ${list[i]['info_text']}',
                                style: TextStyle(fontFamily: "Netflix"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) {
                                //       return PendudukEditScreen(
                                //           info_id: list[i]['info_id']);
                                //     },
                                //   ),
                                // );
                                print(list[i]['info_id']);
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.create_outlined),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                deleteData(list[i]['info_id'], context);
                                // print(list[i]['info_id']);
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.restore_from_trash),
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

void deleteData(info_id, BuildContext context) {
  print(info_id);
  print('delete');
  var url = "http://192.168.1.103:8000/api/hapus-info";
  http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer $token',
    },
    body: jsonEncode(
      {
        "info_id": info_id,
      },
    ),
  );
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) {
        return InformasiScreen();
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
