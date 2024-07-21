import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sidedi/screen_admin/informasi_screen.dart';
import 'package:sidedi/screen_admin/penduduk_screen.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

class InformasiAddScreen extends StatefulWidget {
  const InformasiAddScreen({Key? key}) : super(key: key);

  @override
  State<InformasiAddScreen> createState() => _InformasiAddScreenState();
}

class _InformasiAddScreenState extends State<InformasiAddScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> uploadFile(String url, File file) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      // Upload successful
    } else {
      // Handle error
    }
  }

  File? _imageFile;
  var no_kkController;

  //
  final info_textController = TextEditingController();
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
                  return InformasiScreen();
                },
              ),
            );
          },
        ),
        title: Text("Tambah Data Informasi"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text('Ambil Gambar'),
            SizedBox(
              height: 5,
            ),
            Semantics(
              label: 'image_picker_example_from_gallery',
              child: FloatingActionButton(
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
                heroTag: 'image0',
                tooltip: 'Pick Image from gallery',
                child: const Icon(Icons.photo),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              color: const Color.fromARGB(255, 245, 240, 240),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 8, //or null
                  controller: info_textController,
                  decoration: InputDecoration.collapsed(
                    hintText: "Deskripsi",
                  ),
                ),
              ),
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

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) _imageFile = File(pickedFile.path);
      print(pickedFile?.name);
    });
  }

  Future<void> addData() async {
    print('send');
    try {
      print(_imageFile!.path);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://192.168.1.103:8000/api/addimage"),
      );
      request.fields['info_text'] = info_textController.text;
      request.files
          .add(await http.MultipartFile.fromPath('image', _imageFile!.path));
      final response = await request.send();
      if (response.statusCode == 200) {
        print('200lo');
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jasonMap = jsonDecode(responseString);
        // setState(() {
        // final url = jsonMap['url'];
        // _imageUrl = url;
        // });

        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          SnackBar(
            content: Text('Sukses menambah data'),
            action: SnackBarAction(
                label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
          ),
        );
        info_textController.clear();
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
