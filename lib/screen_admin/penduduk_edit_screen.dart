import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sidedi/screen_admin/penduduk_screen.dart';
import '../Models/kk_model.dart';
import '../Models/profesi_model.dart';
import 'package:intl/intl.dart';

class PendudukEditScreen extends StatefulWidget {
  final String? nik;
  const PendudukEditScreen({this.nik});

  @override
  State<PendudukEditScreen> createState() => _PendudukEditScreenState();
}

class _PendudukEditScreenState extends State<PendudukEditScreen> {
  // onedata
  @override
  void initState() {
    super.initState();
    //in first time, this method will be executed
    _getData();
  }

  var nik_old;
  var no_kkController;
  var profesi_idController;
  var jkController;
  var nikController;
  var nama_lengkapController;
  var tempat_lahirController;
  var alamatController;
  var tgl_lahirController;
  var agamaController;
  var kewarganegaraanController;
  List<String> list = <String>['aktif', 'nonaktif'];
  List<String> jk = <String>['L', 'P'];
  var statusController;
  //
  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.1.103:8000/api/penduduk-edit/${widget.nik}"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          no_kkController = data['data']['no_kk'];
          profesi_idController = data['data']['profesi_id'].toString();
          statusController = data['data']['status'];
          nik_old = data['data']['nik'];
          jkController = data['data']['jk'];
          nikController = TextEditingController(text: data['data']['nik']);
          nama_lengkapController =
              TextEditingController(text: data['data']['nama_lengkap']);
          tempat_lahirController =
              TextEditingController(text: data['data']['tempat_lahir']);
          tgl_lahirController =
              TextEditingController(text: data['data']['tgl_lahir']);
          agamaController = TextEditingController(text: data['data']['agama']);
          kewarganegaraanController =
              TextEditingController(text: data['data']['kewarganegaraan']);
          alamatController =
              TextEditingController(text: data['data']['alamat']);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<KkModel>> getKk() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.103:8000/api/kk-index'));
      final body = json.decode(response.body) as List;
      if (response.statusCode == 200) {
        return body.map((dynamic json) {
          final map = json as Map<String, dynamic>;
          return KkModel(
            no_kk: map['no_kk'] as String,
            nama_kk: map['nama_kk'] as String,
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

  Future<List<ProfesiModel>> getProfesi() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.103:8000/api/profesi-index'));
      // print(response.body);
      final body = json.decode(response.body) as List;
      if (response.statusCode == 200) {
        return body.map((dynamic json) {
          final map = json as Map<String, dynamic>;
          print(map);
          return ProfesiModel(
            profesi_id: map['profesi_id'].toString() as String,
            profesi_nama: map['profesi_nama'] as String,
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        title: Text("Ubah Data Penduduk"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: 900,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<List<KkModel>>(
                  future: getKk(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DropdownButton(
                        // Initial Value
                        value: no_kkController,
                        hint: Text('Pilih No KK'),
                        isExpanded: true,
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        // Array list of items
                        items: snapshot.data!.map((item) {
                          return DropdownMenuItem(
                            value: item.no_kk,
                            child: Text(item.nama_kk.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          no_kkController = value;
                          setState(() {
                            print(no_kkController);
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
                    labelText: "Nik",
                  ),
                  controller: nikController,
                ),
                FutureBuilder<List<ProfesiModel>>(
                  future: getProfesi(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DropdownButton(
                        // Initial Value
                        value: profesi_idController,
                        hint: Text('Pilih Profesi'),
                        isExpanded: true,
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        // Array list of items
                        items: snapshot.data!.map((item) {
                          return DropdownMenuItem(
                            value: item.profesi_id,
                            child: Text(item.profesi_nama.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          profesi_idController = value;
                          setState(() {
                            print(profesi_idController);
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
                    labelText: "Nama lengkap",
                  ),
                  controller: nama_lengkapController,
                ),
                TextField(
                  controller: tgl_lahirController,
                  decoration: const InputDecoration(labelText: "Tangga Lahir"),
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
                    labelText: "Tempat Lahir",
                  ),
                  controller: tempat_lahirController,
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButton(
                  // Initial Value
                  value: jkController,
                  hint: Text('Jenis Kelamin'),
                  isExpanded: true,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Array list of items
                  items: jk.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // jkController = value;
                    print(jkController);
                    setState(
                      () {
                        jkController = value;
                      },
                    );
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Alamat",
                  ),
                  controller: alamatController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Agama",
                  ),
                  controller: agamaController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Kewarganegaraan",
                  ),
                  controller: kewarganegaraanController,
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButton(
                  // Initial Value
                  value: statusController,
                  hint: Text('Status'),
                  isExpanded: true,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Array list of items
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // statusController = value;
                    print(statusController);
                    setState(
                      () {
                        statusController = value;
                      },
                    );
                  },
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
        ),
      ),
    );
  }

  Future<void> editData() async {
    print('send');
    print(nikController.text);
    print(no_kkController);
    print(nama_lengkapController.text);
    print(tempat_lahirController.text);
    print(tgl_lahirController.text);
    print(agamaController.text);
    print(kewarganegaraanController.text);
    print(statusController);
    try {
      final response = await http
          .post(
            Uri.parse("http://192.168.1.103:8000/api/penduduk-edit-proses"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              // 'Authorization': 'Bearer $token',
            },
            body: jsonEncode(
              {
                "nik_old": nik_old,
                "nik": nikController.text,
                "no_kk": no_kkController,
                "profesi_id": profesi_idController,
                "nama_lengkap": nama_lengkapController.text,
                "tempat_lahir": tempat_lahirController.text,
                "alamat": alamatController.text,
                "tgl_lahir": tgl_lahirController.text,
                "agama": agamaController.text,
                "kewarganegaraan": kewarganegaraanController.text,
                "status": statusController,
                "jk": jkController,
              },
            ),
          )
          .timeout(
            const Duration(
              seconds: 1,
            ),
          );
      // print(response.body);
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
