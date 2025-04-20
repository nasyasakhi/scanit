import 'package:flutter/material.dart';
import 'package:qr_scanner/const.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset('assets/images/logo_barcode.png', height: 50),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: defaultPadding),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Welcome to Scan It !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/scanner');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 42),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1E1F87FC),
                        blurRadius: 22,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ]
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/qr_scanner.png',
                        width: 65,
                        height: 65,
                      ),
                      const SizedBox(height: defaultPadding),
                      const Text(
                        "Scan \nQR Code",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/generator');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 42),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1E1F87FC),
                        blurRadius: 22,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ]
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/qr_generator.png',
                        width: 65,
                        height: 65,
                      ),
                      const SizedBox(height: defaultPadding),
                      const Text(
                        "Generate \nQR Code",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}