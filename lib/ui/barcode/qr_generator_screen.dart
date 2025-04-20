import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_scanner/const.dart';

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  String? qrRawValue;
  Color qrColor = Colors.black;
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate QR Code'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "/scanner");
            },
            icon: const Icon(Icons.qr_code_scanner_rounded),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_barcode.png',
                height: 80,
              ),
              const Text(
                'Generator',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              Screenshot(
                controller: screenshotController,
                child: Container(
                  width: 260,
                  height: 260,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: qrColor, width: 4.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: qrRawValue == null || qrRawValue!.isEmpty
                      ? const Center(
                          child: Text(
                            'QR Preview',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : PrettyQrView.data(
                          data: qrRawValue!,
                          decoration: PrettyQrDecoration(
                            shape: PrettyQrSmoothSymbol(
                              color: qrColor,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                onChanged: (value) {
                  setState(() {
                    qrRawValue = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Insert text or URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: primaryColor, // Set to primaryColor
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                children: [
                  ...[
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.cyan,
                    Colors.purple,
                    Colors.black
                  ].map((color) => GestureDetector(
                        onTap: () {
                          setState(() {
                            qrColor = color;
                          });
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 2,
                              color: qrColor == color
                                  ? primaryColor
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: qrRawValue == null || qrRawValue!.isEmpty
                    ? null
                    : _shareQrCode,
                icon: Icon(
                  Icons.share_sharp,
                  color: qrRawValue == null || qrRawValue!.isEmpty
                      ? Colors.grey
                      : Colors.white,
                ),
                label: const Text(
                  'Share QR',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareQrCode() async {
    final image = await screenshotController.capture();
    if (image != null) {
      await Share.shareXFiles([
        XFile.fromData(
          image,
          name: "qr_code.png",
          mimeType: "image/png",
        ),
      ]);
    }
  }
}
