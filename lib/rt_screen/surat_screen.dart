import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sidedi/models/pddk_model.dart';
import 'package:sidedi/screen/rt_screen.dart';
import 'package:http/http.dart' as http;

class SuratScreen extends StatefulWidget {
  String? judul;
  SuratScreen({this.judul});

  @override
  State<SuratScreen> createState() => _SuratScreenState();
}

class _SuratScreenState extends State<SuratScreen> {
  var nik_pddk;
  var nama_lengkap;
  var tempat_lahir;
  var tgl_lahir;
  var status_perkawinan;

  Future<List<PddkModel>> getPostApi() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.0.107:8000/api/penduduk-index'));
      final body = json.decode(response.body) as List;
      if (response.statusCode == 200) {
        return body.map((dynamic json) {
          final map = json as Map<String, dynamic>;
          return PddkModel(
            nik: map['nik'] as String,
            nama_lengkap: map['nama_lengkap'] as String,
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

  Future getData(nik) async {
    try {
      final response = await http
          .get(Uri.parse("http://192.168.0.107:8000/api/penduduk-edit/${nik}"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['data']['nik']);
        setState(() {
          status_perkawinan = data['data']['status_perkawinan'];
          nik_pddk = data['data']['nik'];
          nama_lengkap = data['data']['nama_lengkap'];
          tempat_lahir = data['data']['tempat_lahir'];
          tgl_lahir = data['data']['tgl_lahir'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

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

  // download
  late String _localPath;
  late bool _permissionReady;
  TargetPlatform? platform;
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

  var nikController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return RtScreen(
                    role: 'rt',
                  );
                },
              ),
            );
          },
        ),
        title: Text("${widget.judul}"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            FutureBuilder<List<PddkModel>>(
              future: getPostApi(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton(
                    // Initial Value
                    value: nikController,
                    hint: Text('Pilih No KK / Penduduk'),
                    isExpanded: true,
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),
                    // Array list of items
                    items: snapshot.data!.map((item) {
                      return DropdownMenuItem(
                        value: item.nik,
                        child: Text(item.nama_lengkap.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        nikController = value;
                      });
                    },
                  );
                } else {
                  return Center(child: const CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 65, 203, 70),
              onPressed: () {
                getData(nikController);
                // addData();
              },
              child: Text(
                "${widget.judul}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                    child: Text('Nama'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$nama_lengkap')
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                    child: Text('Tempat & Tgl Lahir'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$tempat_lahir / $tgl_lahir')
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                    child: Text('NIK'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$nik_pddk')
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                    child: Text('Status Perkawinan'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$status_perkawinan')
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                    child: Text('Keperluan'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text(widget.judul.toString())
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 68, 134, 201),
              onPressed: () async {
                _permissionReady = await _checkPermission();
                if (_permissionReady) {
                  await _prepareSaveDir();
                  print("Downloading");
                  print(nikController);
                  try {
                    var cari = widget.judul?.replaceAll(' ', '');
                    print(cari);
                    await Dio().download(
                        "http://192.168.0.107:8000/api/download-keperluan/${nikController}/${cari}",
                        _localPath + "/" + "SURAT ${widget.judul}.pdf");
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
                        content: Text("Download Failed.\n\n" + e.toString()),
                        action: SnackBarAction(
                            label: 'OK',
                            onPressed: scaffold.hideCurrentSnackBar),
                      ),
                    );
                  }
                }
              },
              child: Text(
                "Cetak ${widget.judul}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
