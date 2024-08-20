import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sidedi/screen_admin/penduduk_screen.dart';
import 'package:sidedi/screen_admin/pengurus_screen.dart';
import '../Models/kk_model.dart';
import '../Models/profesi_model.dart';
import 'package:intl/intl.dart';

class PengurusEditScreen extends StatefulWidget {
  final String? user_id;
  const PengurusEditScreen({this.user_id});

  @override
  State<PengurusEditScreen> createState() => _PengurusEditScreenState();
}

class _PengurusEditScreenState extends State<PengurusEditScreen> {
  // onedata
  @override
  void initState() {
    super.initState();
    //in first time, this method will be executed
    _getData();
  }

  //
  var user_idController;
  var statusController;
  var roleController;

  var nameController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  List<String> list = <String>['aktif', 'nonaktif'];
  List<String> role = <String>['admin', 'rt'];

  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.0.107:8000/api/user-edit/${widget.user_id}"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          user_idController = widget.user_id;
          roleController = data['data']['role'];
          statusController = data['data']['status'];
          nameController = TextEditingController(text: data['data']['name']);
          usernameController =
              TextEditingController(text: data['data']['username']);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  //
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
                  return PengurusScreen();
                },
              ),
            );
          },
        ),
        title: Text("Ubah Data Pengurus"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: 800,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Nama lengkap",
                  ),
                  controller: nameController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Username",
                  ),
                  controller: usernameController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                  controller: passwordController,
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButton(
                  // Initial Value
                  value: roleController,
                  hint: Text('Role'),
                  isExpanded: true,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Array list of items
                  items: role.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // statusController = value;
                    print(roleController);
                    setState(
                      () {
                        roleController = value;
                      },
                    );
                  },
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
        ),
      ),
    );
  }

  Future<void> editData() async {
    print('edit');
    try {
      final response = await http
          .post(
            Uri.parse("http://192.168.0.107:8000/api/user-edit-proses"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              // 'Authorization': 'Bearer $token',
            },
            body: jsonEncode(
              {
                "user_id": widget.user_id,
                "name": nameController.text,
                "username": usernameController.text,
                "password": passwordController.text,
                "role": roleController,
                "status": statusController,
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
        // print(json.decode(response.body));
        var text = (response.body.toString());
        print(text);
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
      } else if (response.statusCode == 400) {
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          SnackBar(
            content: Text('Gagal menambah data'),
            action: SnackBarAction(
                label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
          ),
        );
      } else {
        const SnackBar(
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
