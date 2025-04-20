import 'package:flutter/material.dart';
import 'package:qr_scanner/ui/barcode/qr_generator_screen.dart';
import 'package:qr_scanner/ui/barcode/qr_scanner_screen.dart';
import 'package:qr_scanner/ui/home/home_screen.dart';
import 'package:qr_scanner/ui/splash_screen.dart';

void main() {
  runApp(const QrScannerApp());
}

class QrScannerApp extends StatelessWidget {
  const QrScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "QR Scanner App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/home": (context) => const HomeScreen(),
        "/scanner": (context) => const QrScannerScreen(),
        "/generator": (context) => const QrGeneratorScreen(),
      },
    );
  }
}