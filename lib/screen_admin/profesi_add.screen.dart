import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sidedi/screen_admin/profesi_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfesiAddScreen extends StatefulWidget {
  const ProfesiAddScreen({Key? key}) : super(key: key);

  @override
  State<ProfesiAddScreen> createState() => _ProfesiAddScreenState();
}

class _ProfesiAddScreenState extends State<ProfesiAddScreen> {
  //
  final profesi_namaController = TextEditingController();
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
                  return ProfesiScreen();
                },
              ),
            );
          },
        ),
        title: Text("Tambah Data Profesi Warga"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Profesi",
              ),
              controller: profesi_namaController,
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 65, 203, 70),
              onPressed: () {
                addData();
              },
              child: const Text(
                "Tambah",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addData() async {
    // Create storage
    final storage = new FlutterSecureStorage();
    String? _token = await storage.read(key: 'jwt');
    try {
      final response = await http
          .post(
            Uri.parse("http://192.168.1.103:8000/api/profesi/create"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $_token',
            },
            body: jsonEncode(
              {
                "profesi_nama": profesi_namaController.text,
              },
            ),
          )
          .timeout(
            const Duration(
              seconds: 1,
            ),
          );
      print(response.statusCode);
      if (response.statusCode == 200) {
        //
        print(json.decode(response.body));
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          SnackBar(
            content: Text('Sukses menambah data'),
            action: SnackBarAction(
                label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
          ),
        );
        profesi_namaController.clear();
        //
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
}
