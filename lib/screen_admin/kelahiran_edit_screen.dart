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
  var nik_ibuController;
  var nik_ayahController;
  var kelahiran_idController;

  //
  var tgl_lahirController;
  var alamat_kelahiranController;
  var anak_keController;

  Future _getData() async {
    print(widget.kelahiran_id);
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.0.107:8000/api/kelahiran-edit/${widget.kelahiran_id}"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          kelahiran_idController = data['data']['kelahiran_id'];
          nikController = data['data']['nik'];
          nik_ibuController = data['data']['nik_ibu'];
          nik_ayahController = data['data']['nik_ayah'];
          tgl_lahirController =
              TextEditingController(text: data['data']['tgl_lahir']);
          alamat_kelahiranController =
              TextEditingController(text: data['data']['alamat_kelahiran']);
          anak_keController =
              TextEditingController(text: data['data']['anak_ke']);
        });
      }
    } catch (e) {
      print(e);
    }
  }

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
    try {
      final response = await http
          .post(
            Uri.parse("http://192.168.0.107:8000/api/kelahiran-edit-proses"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              // 'Authorization': 'Bearer $token',
            },
            body: jsonEncode(
              {
                "kelahiran_id": kelahiran_idController,
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
