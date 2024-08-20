import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
import 'package:intl/intl.dart';

class ActivitasScreen extends StatefulWidget {
  const ActivitasScreen({super.key});

  @override
  State<ActivitasScreen> createState() => _ActivitasScreenState();
}

class _ActivitasScreenState extends State<ActivitasScreen> {
  int pages = 1;
  int _currentPage = 0;
  String check = '1';

  List<String> bulan = <String>[
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];
  List<String> tahun = <String>[
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
  ];
  var bulanController;
  var tahunController;

  late String _localPath;
  late bool _permissionReady;
  TargetPlatform? platform;

  @override
  void initState() {
    super.initState();
    //in first time, this method will be executed

    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      // return "/sdcard/download";
      return "/storage/emulated/0/Download";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + Platform.pathSeparator + 'Download';
    }
  }

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
        title: Text("Aktivitas Kegiatan Kelurahan"),
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
                  onPressed: () async {
                    _permissionReady = await _checkPermission();
                    if (_permissionReady) {
                      await _prepareSaveDir();
                      print("Downloading");
                      try {
                        String res_bln =
                            bulanController == null ? 'def' : bulanController;
                        String res_thn =
                            tahunController == null ? 'def' : tahunController;
                        await Dio().download(
                            "http://192.168.0.107:8000/api/aktivitas-download/${res_bln}/${res_thn}",
                            _localPath +
                                "/" +
                                "Aktivitas-Bulan-$res_bln-Tahun-$res_thn.pdf");
                        print("Download Completed.");
                        print(_localPath);
                        final scaffold = ScaffoldMessenger.of(context);
                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text('Download Completed.$_localPath'),
                            action: SnackBarAction(
                                label: 'OK',
                                onPressed: scaffold.hideCurrentSnackBar),
                          ),
                        );
                      } catch (e) {
                        final scaffold = ScaffoldMessenger.of(context);
                        scaffold.showSnackBar(
                          SnackBar(
                            content:
                                Text("Download Failed.\n\n" + e.toString()),
                            action: SnackBarAction(
                                label: 'OK',
                                onPressed: scaffold.hideCurrentSnackBar),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    width: 90,
                    child: Row(
                      children: [
                        Icon(Icons.download, color: Colors.white),
                        Text(
                          "Download",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 100,
                      child: DropdownButton(
                        // Initial Value
                        value: bulanController,
                        hint: Text('Bulan'),
                        isExpanded: true,
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        // Array list of items
                        items:
                            bulan.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            bulanController = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Container(
                      width: 100,
                      child: DropdownButton(
                        // Initial Value
                        value: tahunController,
                        hint: Text('Tahun'),
                        isExpanded: true,
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        // Array list of items
                        items:
                            tahun.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            tahunController = value;
                          });
                        },
                      ),
                    ),
                  ],
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
    print(bulanController);
    print(tahunController);
    var _currentPagePagination = (_currentPage + 1);
    final response = await http.post(
      Uri.parse(
          "http://192.168.0.107:8000/api/aktivitas-index/$_currentPagePagination"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          "bulan": bulanController,
          "tahun": tahunController,
        },
      ),
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
                              width: 320,
                              child: Text(
                                (i + 1).toString() +
                                    '. Aktivitas : ${list[i]['aktivitas_nama']} \n Waktu : ${list[i]['tgl']} ${list[i]['pukul']}',
                                style: TextStyle(
                                  fontFamily: "poppins",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
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
