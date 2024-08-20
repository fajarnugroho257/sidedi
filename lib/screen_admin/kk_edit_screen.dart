import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sidedi/screen/kk_screen.dart';

class KkEditScreen extends StatefulWidget {
  final String? no_kk;
  const KkEditScreen({this.no_kk});

  @override
  State<KkEditScreen> createState() => _KkEditScreenState();
}

class _KkEditScreenState extends State<KkEditScreen> {
  var no_kk_old;
  var no_kkController = TextEditingController();
  var nama_kkController = TextEditingController();

  //
  @override
  void initState() {
    super.initState();
    //in first time, this method will be executed
    _getData();
  }

  Future _getData() async {
    try {
      final response = await http.get(
          Uri.parse("http://192.168.0.107:8000/api/kk-edit/${widget.no_kk}"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          no_kk_old = data['data']['no_kk'];
          no_kkController = TextEditingController(text: data['data']['no_kk']);
          nama_kkController =
              TextEditingController(text: data['data']['nama_kk']);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> editData() async {
    print('send');
    try {
      final response = await http
          .post(
            Uri.parse("http://192.168.0.107:8000/api/kk-edit-proses"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(
              {
                "no_kk_old": no_kk_old,
                "no_kk": no_kkController.text,
                "nama_kk": nama_kkController.text,
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
            content: Text('Sukses mengubah data'),
            action: SnackBarAction(
                label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
          ),
        );
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
                  return KkScreen();
                },
              ),
            );
          },
        ),
        title: Text("Edit Data kartu Keluarga"),
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
              controller: no_kkController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Nama",
              ),
              controller: nama_kkController,
            ),
            SizedBox(
              height: 20,
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
}
