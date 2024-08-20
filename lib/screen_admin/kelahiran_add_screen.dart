import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sidedi/models/pddk_model.dart';
import 'package:sidedi/screen_admin/kelahiran_screen.dart';
import 'package:intl/intl.dart';

class kelahiranAddScreen extends StatefulWidget {
  const kelahiranAddScreen({Key? key}) : super(key: key);

  @override
  State<kelahiranAddScreen> createState() => _kelahiranAddScreenState();
}

class _kelahiranAddScreenState extends State<kelahiranAddScreen> {
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

  var nikController;
  var nik_ibuController;
  var nik_ayahController;

  //
  final tgl_lahirController = TextEditingController();
  final alamat_kelahiranController = TextEditingController();
  final anak_keController = TextEditingController();
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
                  return KelahiranScreen();
                },
              ),
            );
          },
        ),
        title: Text("Tambah Data Kelahiran"),
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
                    hint: Text('Pilih Nama Anak'),
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
                      nikController = value;
                      setState(() {
                        print(nikController);
                      });
                    },
                  );
                } else {
                  return Center(child: const CircularProgressIndicator());
                }
              },
            ),
            FutureBuilder<List<PddkModel>>(
              future: getPostApi(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton(
                    // Initial Value
                    value: nik_ibuController,
                    hint: Text('Pilih Nama Ibu'),
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
                      nik_ibuController = value;
                      setState(() {
                        print(nik_ibuController);
                      });
                    },
                  );
                } else {
                  return Center(child: const CircularProgressIndicator());
                }
              },
            ),
            FutureBuilder<List<PddkModel>>(
              future: getPostApi(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton(
                    // Initial Value
                    value: nik_ayahController,
                    hint: Text('Pilih Nama Ayah'),
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
                      nik_ayahController = value;
                      setState(() {
                        print(nik_ayahController);
                      });
                    },
                  );
                } else {
                  return Center(child: const CircularProgressIndicator());
                }
              },
            ),
            TextField(
              controller: tgl_lahirController,
              decoration: const InputDecoration(labelText: "Tanggal lahir"),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1989),
                    lastDate: DateTime(2101));

                if (pickedDate != null) {
                  print(pickedDate);
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  print(formattedDate);
                  setState(
                    () {
                      tgl_lahirController.text = formattedDate;
                    },
                  );
                } else {
                  print("Date is not selected");
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Alamat Kelahiran",
              ),
              controller: alamat_kelahiranController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Anak Ke",
              ),
              controller: anak_keController,
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

  Future<void> addData() async {
    print('send');
    print(nikController);
    print(tgl_lahirController.text);
    print(alamat_kelahiranController.text);
    print(anak_keController.text);
    try {
      final response = await http
          .post(
            Uri.parse("http://192.168.0.107:8000/api/kelahiran-create"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              // 'Authorization': 'Bearer $token',
            },
            body: jsonEncode(
              {
                "nik": nikController,
                "nik_ibu": nik_ibuController,
                "nik_ayah": nik_ayahController,
                "tgl_lahir": tgl_lahirController.text,
                "alamat_kelahiran": alamat_kelahiranController.text,
                "anak_ke": anak_keController.text,
              },
            ),
          )
          .timeout(
            const Duration(
              seconds: 1,
            ),
          );
      print(response.body);
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
        //
        print('oke');
      } else {
        SnackBar(
          content: Text("Failed to create post!"),
        );
        print('gagal');
      }
    } catch (e) {
      print('error caught: $e');
    }
    //
  }
}
