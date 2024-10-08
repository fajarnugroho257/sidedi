import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sidedi/screen/home_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sidedi/screen_admin/profesi_add.screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:sidedi/screen_admin/profesi_edit_screen.dart';

class ProfesiScreen extends StatefulWidget {
  const ProfesiScreen({super.key});

  @override
  State<ProfesiScreen> createState() => _ProfesiScreenState();
}

class _ProfesiScreenState extends State<ProfesiScreen> {
  int pages = 1;
  int _currentPage = 0;
  String check = '1';

  late String _localPath;
  late bool _permissionReady;
  TargetPlatform? platform;

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
        title: Text("Data Profesi Warga"),
        centerTitle: true,
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: const LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [
        //       Color.fromARGB(255, 22, 141, 201),
        //       Color.fromARGB(255, 73, 115, 214)
        //     ],
        //   ),
        // ),
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
                          return ProfesiAddScreen();
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
                // InkWell(
                //   onTap: () async {
                //     _permissionReady = await _checkPermission();
                //     if (_permissionReady) {
                //       await _prepareSaveDir();
                //       print("Downloading");
                //       try {
                //         await Dio().download(
                //             "http://192.168.0.107:8000/api/downloadFile",
                //             _localPath + "/" + "profesi.pdf");
                //         print("Download Completed.");
                //         print(_localPath);
                //         final scaffold = ScaffoldMessenger.of(context);
                //         scaffold.showSnackBar(
                //           SnackBar(
                //             content: Text('Download Completed.$_localPath'),
                //             action: SnackBarAction(
                //                 label: 'OK',
                //                 onPressed: scaffold.hideCurrentSnackBar),
                //           ),
                //         );
                //       } catch (e) {
                //         final scaffold = ScaffoldMessenger.of(context);
                //         scaffold.showSnackBar(
                //           SnackBar(
                //             content:
                //                 Text("Download Failed.\n\n" + e.toString()),
                //             action: SnackBarAction(
                //                 label: 'OK',
                //                 onPressed: scaffold.hideCurrentSnackBar),
                //           ),
                //         );
                //       }
                //     }
                //   },
                //   child: Container(
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: Colors.grey.withOpacity(0.5)),
                //     padding: EdgeInsets.all(8),
                //     child: Icon(Icons.download, color: Colors.black),
                //   ),
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

  @override
  void initState() {
    super.initState();
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
      // return "/sdcard/download/";
      return "/storage/emulated/0/Download";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + Platform.pathSeparator + 'Download';
    }
  }

  Future<List> getTotalData() async {
    var _currentPagePagination = (_currentPage + 1);
    // Create storage
    final storage = new FlutterSecureStorage();
    String? _token = await storage.read(key: 'jwt');
    final response = await http.get(
      Uri.parse(
          "http://192.168.0.107:8000/api/profesi/index/$_currentPagePagination"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
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
                  height: 50,
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
                            Text(
                              (i + 1).toString() +
                                  '. Nama : ${list[i]['profesi_nama']}',
                              style: TextStyle(
                                  fontFamily: "poppins", color: Colors.white),
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
                                      return ProfesiEditScreen(
                                        profesiId:
                                            list[i]['profesi_id'].toString(),
                                      );
                                    },
                                  ),
                                );
                                print(list[i]['profesi_id']);
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
                                  list[i]['profesi_id'],
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.restore_from_trash,
                                    color: Colors.red[400],
                                  ),
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

Future<void> deleteData(profesi_id, BuildContext context) async {
  // Create storage
  final storage = new FlutterSecureStorage();
  String? _token = await storage.read(key: 'jwt');
  String? _login_st = await storage.read(key: 'login_st');
  print(_login_st);
  var url = "http://192.168.0.107:8000/api/profesi/hapus";
  http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    },
    body: jsonEncode(
      {
        "profesi_id": profesi_id,
      },
    ),
  );
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) {
        return ProfesiScreen();
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

showAlertDialog(BuildContext context, kematian_id) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      deleteData(kematian_id, context);
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
