import 'package:flutter/material.dart';
import 'package:sidedi/screen/data_penduduk_screen.dart';
import 'package:sidedi/screen/login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Desa'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.login_outlined),
            tooltip: 'Show Snackbar',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 50,
            ),
            ListTile(
              leading: Icon(
                Icons.info,
              ),
              title: const Text('Informasi Desa'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return BerandaScreen();
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle,
              ),
              title: const Text('Data Penduduk'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return DataPendudukScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 195, 242, 244),
              Color.fromARGB(255, 95, 219, 219)
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            // color: Color.fromARGB(255, 200, 199, 199),
            child: Column(
              children: [
                SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: FutureBuilder<List>(
                    future: getTotalData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData
                          ? ItemList(
                              list: snapshot.data ?? [],
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List> getTotalData() async {
    var _currentPagePagination = 1;
    print(_currentPagePagination);
    String token =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYXBpL2xvZ2luIiwiaWF0IjoxNzIwNzEzNjY1LCJleHAiOjE3MjA3MTcyNjUsIm5iZiI6MTcyMDcxMzY2NSwianRpIjoiOTV3UFVhbEpsYnlaZ1ZPUiIsInN1YiI6IjEiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.HUoVxlDj-3O5SHtWOAcfJnMCXgHjFm9WppTeOVq1NZE";
    final response = await http.get(
      Uri.parse("http://192.168.0.107:8000/api/info-index/1"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var data = json.decode(response.body);
    return data['data']['data'];
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        final url = list[i]['url'];
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 188, 188, 188),
                        blurRadius: 4,
                        offset: Offset(4, 4), // Shadow position
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 180,
                            width: double.infinity,
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(list[i]['info_text']),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
