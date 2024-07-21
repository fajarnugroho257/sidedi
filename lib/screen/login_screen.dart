import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sidedi/screen/beranda_screen.dart';
import 'package:sidedi/screen/home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sidedi/screen/rt_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginScreenState extends State<LoginScreen> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // String email, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;
  String login_st = 'inactive';

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  String apiUrl = 'http://192.168.1.103:8000/api/login';

  login() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'username': usernameController.text,
        'password': passwordController.text
      },
    );
    final data = jsonDecode(response.body);
    print(data);
    // Create storage
    final storage = new FlutterSecureStorage();
    // Write value
    await storage.write(key: 'jwt', value: data['token']);
    //
    if (response.statusCode == 200) {
      await storage.write(key: 'jwt', value: data['token']);
      await storage.write(key: 'login_st', value: 'active');
      await storage.write(key: 'role', value: data['user']['role']);
      await storage.write(key: 'name', value: data['user']['name']);
      //
      // String? value = await storage.read(key: 'jwt');
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        preferences.setInt("value", 1);
      });
      // final data = json.decode(response.body);

      String role = data['user']['role'];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return role == 'admin'
                ? HomeScreen()
                : role == 'rt'
                    ? RtScreen(role: role)
                    : Scaffold();
          },
        ),
      );
      usernameController.clear();
      passwordController.clear();
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: Username atau Password tidak ditemukan'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: Server error'),
        ),
      );
    }
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 2 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "LOGIN",
                      style: TextStyle(fontSize: 20),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Username",
                      ),
                      controller: usernameController,
                    ),
                    TextFormField(
                      obscureText: _secureText,
                      decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: IconButton(
                          onPressed: showHide,
                          icon: Icon(_secureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                      controller: passwordController,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(
                            color: Colors.blueAccent,
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return BerandaScreen();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "Kembali",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          MaterialButton(
                            color: Color.fromARGB(255, 65, 203, 70),
                            onPressed: () {
                              login();
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return HomeScreen();
        break;
    }
  }
}
