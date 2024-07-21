import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sidedi/screen/beranda_screen.dart';
import 'package:sidedi/screen/home_screen.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:sidedi/screen/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    Future.delayed(Duration(seconds: 6)).then(
      (value) => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BerandaScreen(),
          ),
          (route) => false),
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/background.png',
              // fit: BoxFit.fill,
              height: 200,
              width: 200,
              alignment: Alignment.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Selamat Datang',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
                color: Colors.black,
              ),
            ),
            Text(
              'di Sistem Administrasi Desa',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
