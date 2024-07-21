import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:sidedi/screen/home_screen.dart';
import 'package:sidedi/screen_admin/penduduk_add_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sidedi/screen_admin/penduduk_edit_screen.dart';

class PendudukScreen extends StatefulWidget {
  const PendudukScreen({super.key});

  @override
  State<PendudukScreen> createState() => _PendudukScreenState();
}

class _PendudukScreenState extends State<PendudukScreen> {
  int pages = 1;
  int _currentPage = 0;
  String check = '1';

  @override
  Widget build(BuildContext context) {
    //
    getTotalData();
    //
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Penduduk'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Container(
          color: Colors.brown,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MaterialButton(
                color: Color.fromARGB(255, 65, 203, 70),
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
              SizedBox(
                height: 400,
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
              NumberPaginator(
                config: NumberPaginatorUIConfig(
                  buttonSelectedForegroundColor: Colors.white,
                  buttonSelectedBackgroundColor: Colors.green[400],
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
    );
  }

  Future<List> getTotalData() async {
    var _currentPagePagination = (_currentPage + 1);
    print(_currentPagePagination);
    String token =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYXBpL2xvZ2luIiwiaWF0IjoxNzIwNzEzNjY1LCJleHAiOjE3MjA3MTcyNjUsIm5iZiI6MTcyMDcxMzY2NSwianRpIjoiOTV3UFVhbEpsYnlaZ1ZPUiIsInN1YiI6IjEiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.HUoVxlDj-3O5SHtWOAcfJnMCXgHjFm9WppTeOVq1NZE";
    final response = await http.get(
      Uri.parse(
          "http://127.0.0.1:8000/api/penduduk-index/$_currentPagePagination"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var data = json.decode(response.body);

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

  num get pages => 0;

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
                  color: Colors.amber,
                  height: 100,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (i + 1 + pages).toString() +
                                  '. Nama : ${list[i]['nama_lengkap']}',
                              style: TextStyle(fontFamily: "Netflix"),
                            ),
                            Text('Nik : ${list[i]['nik']}'),
                            Text('No KK : ${list[i]['no_kk']}'),
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
                                      return PendudukEditScreen(
                                          nik: list[i]['nik']);
                                    },
                                  ),
                                );
                                print(list[i]['nik']);
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.create_outlined),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                deleteData(list[i]['nik'], context);
                                // print(list[i]['nik']);
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

void deleteData(nik, BuildContext context) {
  print(nik);
  print('delete');
  var url = "http://127.0.0.1:8000/api/hapus";
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
