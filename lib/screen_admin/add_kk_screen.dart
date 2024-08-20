import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sidedi/screen/kk_screen.dart';

class AddDataKk extends StatefulWidget {
  const AddDataKk({super.key});

  @override
  State<AddDataKk> createState() => _AddDataKkState();
}

class _AddDataKkState extends State<AddDataKk> {
  Future<void> addData() async {
    String token =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYXBpL2xvZ2luIiwiaWF0IjoxNzIwNzAwMDU1LCJleHAiOjE3MjA3MDM2NTUsIm5iZiI6MTcyMDcwMDA1NSwianRpIjoiWjZwYk1DeWpqbXNMYTh6MCIsInN1YiI6IjEiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.hN_b_vdS7RnT8StZ-4lb5ywKLaKZtkguCg_vq2tSHQY";
    print('send');
    try {
      final response = await http
          .post(
            Uri.parse("http://192.168.0.107:8000/api/kk-create"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              // 'Authorization': 'Bearer $token',
            },
            body: jsonEncode(
              {
                "no_kk": nokkController.text,
                "nama_kk": namaController.text,
              },
            ),
          )
          .timeout(
            const Duration(
              seconds: 1,
            ),
          );
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          SnackBar(
            content: Text('Sukses menambah data'),
            action: SnackBarAction(
                label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
          ),
        );
        nokkController.clear();
        namaController.clear();
        print('oke');
      } else {
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          SnackBar(
            content: Text('Gagal menambah data'),
            action: SnackBarAction(
                label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
          ),
        );
        print('gagal');
      }
    } catch (e) {
      print('error caught: $e');
    }
    //
  }

  void error(BuildContext context, String error) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(error),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  final nokkController = TextEditingController();
  final namaController = TextEditingController();

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
                  return KkScreen();
                },
              ),
            );
          },
        ),
        title: Text("Tambah Data kartu Keluarga"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Nomor kartu Keluarga",
              ),
              controller: nokkController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Nama",
              ),
              controller: namaController,
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 65, 203, 70),
              onPressed: () {
                addData();
              },
              child: Text(
                "Tambah",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FetchDataException implements Exception {
  final _message;
  FetchDataException([this._message]);

  String toString() {
    if (_message == null) return "Exception";
    return "Exception: $_message";
  }
}
