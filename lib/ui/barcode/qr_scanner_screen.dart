import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner/const.dart';
import 'package:share_plus/share_plus.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  int _activeButtonIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildScanner(),
          _buildHeader(),
          _buildScannerFrame(),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  // Method to build the scanner 
  Widget _buildScanner() {
    return MobileScanner(
      controller: MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        returnImage: true,
      ),
      onDetect: (capture) => _onQrCodeDetect(capture),
    );
  }

  // Method to handle QR code detection
  void _onQrCodeDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    final Uint8List? image = capture.image;

    for (final barcode in barcodes) {
      final rawCode = barcode.rawValue;

      if (rawCode != null) {
        _showQrCodeDialog(rawCode, image);
      }
    }
  }

  // Method to show the QR Code detection dialog
  void _showQrCodeDialog(String rawCode, Uint8List? image) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('QR Code Detected'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Raw Code: $rawCode',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              if (image != null) Image.memory(image, height: 150, width: 150),
            ],
          ),
          actions: [
            _buildShareButton(rawCode),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Method to build the Share button
  Widget _buildShareButton(String rawCode) {
    return TextButton.icon(
      onPressed: () => _shareQrCode(rawCode),
      icon: const Icon(Icons.share),
      label: const Text('Share'),
    );
  }

  // Method to handle sharing QR code
  Future<void> _shareQrCode(String rawCode) async {
    try {
      await Share.share(
        'Here is the scanned QR code: $rawCode',
        subject: 'Scanned QR Code',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to share: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Header Section
  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: const Text(
          'Scan QR Code !',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Scanner Frame in the Center
  Widget _buildScannerFrame() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 60,
          ),
        ),
      ),
    );
  }

  // Bottom Buttons for switching between Scanner and Generator
  Widget _buildBottomButtons() {
    return Positioned(
      bottom: 30,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildButton('Scanner', 0),
            const SizedBox(width: 10),
            _buildButton('Generate', 1),
          ],
        ),
      ),
    );
  }

  // Method to build the action buttons
  Widget _buildButton(String label, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onButtonPressed(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: _activeButtonIndex == index ? secondaryColor : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: secondaryColor,
              width: 2,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _activeButtonIndex == index ? Colors.white : secondaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Method to handle button press
  void _onButtonPressed(int index) {
    setState(() {
      _activeButtonIndex = index;
    });
    String route = index == 0 ? '/scanner' : '/generator';
    Navigator.pushNamed(context, route);
  }
}