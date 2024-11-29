import 'package:flutter/material.dart';
import 'package:qr_scanner/ui/barcode/qr_generator_screen.dart';
import 'package:qr_scanner/ui/barcode/qr_scanner_screen.dart';
import 'package:qr_scanner/ui/splash/components/body.dart';
import 'package:qr_scanner/ui/splash/splash_screen.dart';

void main() {
  runApp(const QrScannerApp());
}

class QrScannerApp extends StatelessWidget {
  const QrScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ScanIt",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true
      ),
      initialRoute: "/",
      routes: {
        '/' : (context) => const SplashScreen(),
        '/scanner' : (context) => const QrScannerScreen(),
        '/generator' : (context) => const QrGeneratorScreen(),
        '/body' : (context) => const Body(),
      }
    );
  }
}