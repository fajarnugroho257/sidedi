import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sidedi/models/pddk_model.dart';
import 'package:sidedi/screen_admin/kelahiran_screen.dart';
import 'package:intl/intl.dart';
import 'package:sidedi/screen_admin/kematian_screen.dart';

class KematianEditScreen extends StatefulWidget {
  final String? kematian_id;
  const KematianEditScreen({this.kematian_id});

  @override
  State<KematianEditScreen> createState() => _KematianEditScreenState();
}

class _KematianEditScreenState extends State<KematianEditScreen> {
  @override
  void initState() {
    super.initState();
    //in first time, this method will be executed
    _getData();
  }

  //
  var kematian_idController;
  var nikController;
  var tgl_kematianController;

  Future _getData() async {
    print(widget.kematian_id);
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.0.107:8000/api/kematian-edit/${widget.kematian_id}"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          kematian_idController = data['data']['kematian_id'].toString();
          nikController = data['data']['nik'];
          tgl_kematianController =
              TextEditingController(text: data['data']['tgl_kematian']);
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
                  return KematianScreen();
                },
              ),
            );
          },
        ),
        title: Text("Edit Data Kematian"),
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
            TextField(
              controller: tgl_kematianController,
              decoration: const InputDecoration(labelText: "Tanggal Kematian"),
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
                      tgl_kematianController.text = formattedDate;
                    },
                  );
                } else {
                  print("Date is not selected");
                }
              },
            ),
            MaterialButton(
              color: Color.fromARGB(255, 65, 203, 70),
              onPressed: () {
                editData();
              },
              child: Text(
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
    print('send');
    print(nikController);
    print(tgl_kematianController.text);
    try {
      final response = await http
          .post(
            Uri.parse("http://192.168.0.107:8000/api/kematian-edit-proses"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              // 'Authorization': 'Bearer $token',
            },
            body: jsonEncode(
              {
                "kematian_id": kematian_idController,
                "nik": nikController,
                "tgl_kematian": tgl_kematianController.text,
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
