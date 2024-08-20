import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sidedi/screen_admin/profesi_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfesiEditScreen extends StatefulWidget {
  final String? profesiId;
  const ProfesiEditScreen({this.profesiId});

  @override
  State<ProfesiEditScreen> createState() => _ProfesiEditScreenState();
}

class _ProfesiEditScreenState extends State<ProfesiEditScreen> {
  //
  @override
  void initState() {
    super.initState();
    //in first time, this method will be executed
    _getData();
  }

  var profesi_id;
  var profesi_namaController = TextEditingController();

  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.0.107:8000/api/profesi-edit/${widget.profesiId}"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          profesi_id = data['data']['profesi_id'];
          profesi_namaController =
              TextEditingController(text: data['data']['profesi_nama']);
        });
      }
    } catch (e) {
      print(e);
    }
  }

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
        title: Text("Ubah Data Profesi Warga"),
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
                editData();
              },
              child: const Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> editData() async {
    // Create storage
    final storage = new FlutterSecureStorage();
    String? _token = await storage.read(key: 'jwt');
    try {
      final response = await http
          .post(
            Uri.parse("http://192.168.0.107:8000/api/profesi-edit-proses"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $_token',
            },
            body: jsonEncode(
              {
                "profesi_id": profesi_id,
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
            content: Text('Sukses mengubah data'),
            action: SnackBarAction(
                label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
          ),
        );
        //
        print('oke');
      } else {
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          SnackBar(
            content: Text('Gagal mengubah data'),
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
