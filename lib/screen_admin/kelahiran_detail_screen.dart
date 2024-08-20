import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sidedi/screen_admin/kelahiran_screen.dart';
import 'package:sidedi/screen_admin/penduduk_screen.dart';
import '../Models/kk_model.dart';
import '../Models/profesi_model.dart';
import 'package:intl/intl.dart';

class KelahiranDetailScreen extends StatefulWidget {
  final int? kelahiran_id_params;
  const KelahiranDetailScreen({this.kelahiran_id_params});

  @override
  State<KelahiranDetailScreen> createState() => _KelahiranDetailScreenState();
}

class _KelahiranDetailScreenState extends State<KelahiranDetailScreen> {
  late String _localPath;
  late bool _permissionReady;
  TargetPlatform? platform;

  var nama_anak;
  var nama_ayah;
  var nama_ibu;
  var tgl_lahir;
  var alamat_kelahiran;
  var anak_ke;

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
    print('sini');
    print(widget.kelahiran_id_params);
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.0.107:8000/api/kelahiran-edit/${widget.kelahiran_id_params}"));
      print(response.body);
      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          nama_anak = data['data']['nama_anak'];
          nama_ibu = data['data']['nama_ibu'];
          nama_ayah = data['data']['nama_ayah'];
          tgl_lahir = data['data']['tgl_lahir'];
          alamat_kelahiran = data['data']['alamat_kelahiran'];
          anak_ke = data['data']['anak_ke'];
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
                  return KelahiranScreen();
                },
              ),
            );
          },
        ),
        title: Text("Detail Data Kelahiran"),
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
                    child: Text('Nama Anak'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$nama_anak')
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
                    child: Text('Nama Ibu'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$nama_ibu')
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
                    child: Text('Nama Ayah'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$nama_ayah')
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
                    child: Text('Alamat Kelahiran'),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$alamat_kelahiran')
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
                    child: Text('Anak Ke '),
                    width: 130,
                  ),
                  SizedBox(
                    child: Text(':'),
                    width: 20,
                  ),
                  Text('$anak_ke')
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
                  print(widget.kelahiran_id_params);
                  try {
                    await Dio().download(
                        "http://192.168.0.107:8000/api/download-kelahiran/${widget.kelahiran_id_params}",
                        _localPath +
                            "/" +
                            "kelahiran-${widget.kelahiran_id_params}-kelahiran.pdf");
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
                "Cetak Surat Kelahiran",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
