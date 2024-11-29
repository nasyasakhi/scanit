import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_scanner/const.dart';
import 'package:share_plus/share_plus.dart';

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  String? qrRawValue;
  final GlobalKey _qrKey = GlobalKey();
  int _activeButtonIndex = 1; // Index 1 untuk tombol "Generate"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Generate QR Code!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [
          _buildMainContent(),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Styled TextField
          TextField(
            decoration: InputDecoration(
              labelText: 'Enter text for QR Code',
              hintText: 'Type something...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              prefixIcon: const Icon(Icons.edit),
            ),
            onSubmitted: (value) {
              setState(() {
                qrRawValue = value;
              });
            },
          ),
          // QR Code Display
          if (qrRawValue != null)
            Column(
              children: [
                RepaintBoundary(
                  key: _qrKey,
                  child: PrettyQr(
                    data: qrRawValue!,
                    size: 200,
                    roundEdges: true,
                    errorCorrectLevel: QrErrorCorrectLevel.M,
                    elementColor: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                // Share and Download Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        await _saveQrAsImage();
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Download'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await _shareQrCode();
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

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
              color:
                  _activeButtonIndex == index ? Colors.white : secondaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _onButtonPressed(int index) {
    setState(() {
      _activeButtonIndex = index;
    });
    String route = index == 0 ? '/scanner' : '/generator';
    Navigator.pushNamed(context, route);
  }

  Future<void> _saveQrAsImage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Belum bisa huhu miss"),
      ),
    );
  }

  Future<void> _shareQrCode() async {
    try {
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();
        await Share.shareXFiles(
          [
            XFile.fromData(
              pngBytes,
              name: 'qr_code.png',
              mimeType: 'image/png',
            ),
          ],
          text: 'Here is the generated QR Code!',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to share QR Code: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}