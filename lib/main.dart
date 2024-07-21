import 'package:flutter/material.dart';
import 'package:sidedi/screen/beranda_screen.dart';
import 'package:sidedi/screen/home_screen.dart';
import 'package:sidedi/screen/kk_screen.dart';
import 'package:sidedi/screen/splash_screen.dart';
import 'package:sidedi/screen_admin/informasi_add_screen.dart';
import 'package:sidedi/screen_admin/informasi_screen.dart';
import 'package:sidedi/screen_admin/pengurus_screen.dart';
import 'package:sidedi/screen_admin/profesi_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: SplashScreen(),
    );
  }
}
