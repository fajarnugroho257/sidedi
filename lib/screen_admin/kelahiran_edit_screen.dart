import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sidedi/models/pddk_model.dart';
import 'package:sidedi/screen_admin/kelahiran_screen.dart';
import 'package:intl/intl.dart';

class KelahiranEditScreen extends StatefulWidget {
  final String? kelahiran_id;
  const KelahiranEditScreen({this.kelahiran_id});

  @override
  State<KelahiranEditScreen> createState() => _KelahiranEditScreenState();
}

class _KelahiranEditScreenState extends State<KelahiranEditScreen> {
  @override
  void initState() {
    super.initState();
    //in first time, this method will be executed
    _getData();
  }

  // var
  var nikController;
  var kelahiran_idController;
  var nama_anakController;
  var tgl_lahirController;
  var berat_bayiController;
  var panjang_bayiController;

  Future _getData() async {
    print(widget.kelahiran_id);
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.1.103:8000/api/kelahiran-edit/${widget.kelahiran_id}"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          nikController = data['data']['nik'];
          kelahiran_idController = data['data']['kelahiran_id'];
          nama_anakController =
              TextEditingController(text: data['data']['nama_anak']);
          tgl_lahirController =
              TextEditingController(text: data['data']['tgl_lahir']);
          berat_bayiController =
              TextEditingController(text: data['data']['berat_bayi']);
          tgl_lahirController =
              TextEditingController(text: data['data']['tgl_lahir']);
          panjang_bayiController =
              TextEditingController(text: data['data']['panjang_bayi']);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<PddkModel>> getPostApi() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.103:8000/api/penduduk-index'));
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
        title: Text("Ubah Data Kelahiran"),
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
                    hint: Text('Pilih No KK'),
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
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Nama Anak",
              ),
              controller: nama_anakController,
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
                labelText: "Berat Bayi",
              ),
              controller: berat_bayiController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Panjang Bayi",
              ),
              controller: panjang_bayiController,
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 65, 203, 70),
              onPressed: () {
                addData();
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

  Future<void> addData() async {
    print('send');
    print(nikController);
    print(nama_anakController.text);
    print(tgl_lahirController.text);
    print(berat_bayiController.text);
    print(panjang_bayiController.text);
    try {
      final response = await http
          .post(
            Uri.parse("http://192.168.1.103:8000/api/kelahiran-edit-proses"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              // 'Authorization': 'Bearer $token',
            },
            body: jsonEncode(
              {
                "kelahiran_id": kelahiran_idController,
                "nik": nikController,
                "nama_anak": nama_anakController.text,
                "tgl_lahir": tgl_lahirController.text,
                "berat_bayi": berat_bayiController.text,
                "panjang_bayi": panjang_bayiController.text,
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
