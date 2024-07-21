import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sidedi/screen_admin/penduduk_screen.dart';
import '../Models/kk_model.dart';
import '../Models/profesi_model.dart';
import 'package:intl/intl.dart';

class PendudukDetailScreen extends StatefulWidget {
  final String? nik_params;
  const PendudukDetailScreen({this.nik_params});

  @override
  State<PendudukDetailScreen> createState() => _PendudukDetailScreenState();
}

class _PendudukDetailScreenState extends State<PendudukDetailScreen> {
  late String _localPath;
  late bool _permissionReady;
  TargetPlatform? platform;

  var nik;
  var no_kk;
  var profesi_nama;
  var nama_lengkap;
  var tempat_lahir;
  var tgl_lahir;
  var alamat;
  var agama;
  var kewarganegaraan;
  var status;

  @override
  void initState() {
    super.initState();
    //in first time, this method will be executed
    _getData();

    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
  }

  //
  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.1.103:8000/api/penduduk-edit/${widget.nik_params}"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          no_kk = data['data']['nama_kk'].toString();
          profesi_nama = data['data']['profesi_nama'];
          status = data['data']['status'];
          nik = data['data']['nik'].toString();
          nama_lengkap = data['data']['nama_lengkap'];
          tempat_lahir = data['data']['tempat_lahir'];
          tgl_lahir = data['data']['tgl_lahir'];
          alamat = data['data']['alamat'];
          agama = data['data']['agama'];
          kewarganegaraan = data['data']['kewarganegaraan'];
        });
      }
    } catch (e) {
      print(e);
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return PendudukScreen();
                },
              ),
            );
          },
        ),
        title: Text("Detail Data Penduduk"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                    child: Text('Kartu Keluarga'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$no_kk')
                ],
              ),
            ),
            SizedBox(
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
                  Text('$nik')
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                    child: Text('Nama Lengkap'),
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
            SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                    child: Text('Tempat Lahir'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$tempat_lahir')
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                    child: Text('Tanggal Lahir'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$tgl_lahir')
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                    child: Text('Alamat'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$alamat')
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                    child: Text('Agama'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$agama')
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                    child: Text('Profesi'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$profesi_nama')
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
                    child: Text('Kewarganegaraan'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$kewarganegaraan')
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                    child: Text('Status'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$status')
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 68, 134, 201),
              onPressed: () async {
                _permissionReady = await _checkPermission();
                if (_permissionReady) {
                  await _prepareSaveDir();
                  print("Downloading");
                  print(widget.nik_params);
                  try {
                    await Dio().download(
                        "http://192.168.1.103:8000/api/download-penduduk/${widget.nik_params}",
                        _localPath +
                            "/" +
                            "penduduk-${widget.nik_params}-nik.pdf");
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
              child: const Text(
                "Cetak Surat Domisili",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
