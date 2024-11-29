import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState(); 
    Future.delayed(const Duration(seconds: 5), () { 
      Navigator.pushReplacementNamed( 
        // ignore: use_build_context_synchronously
        context, '/body'); // Navigasi ke halaman utama
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_barcode.png',
              width: 200, 
            ),
          ],
        ),
      ),
    );
  }
}