import 'package:flutter/material.dart';
import 'package:qr_scanner/const.dart';
import 'package:qr_scanner/size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key, required this.title, required this.subtitle, required this.image});

  final String title, subtitle, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: 300,
          width: 300,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            color: primaryColor,
            fontSize: getPropotionateScreenWidth(24.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey,
            fontSize: getPropotionateScreenWidth(16),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
