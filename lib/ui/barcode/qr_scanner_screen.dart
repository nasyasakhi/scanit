import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner/const.dart';
import 'package:share_plus/share_plus.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  String? qrRawValue;
  MobileScannerController controller = MobileScannerController(
    // biar sekali detect aja
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: true,
  );

  void resetScanner() {
    setState(() {
      qrRawValue = null;
    });
    controller.stop(); // Stop scanning before restarting.
    controller.start(); // Restart scanning.
  }

  @override
  void dispose() {
    controller.dispose(); // Dispose of the scanner controller.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "/generator");
            },
            icon: const Icon(Icons.qr_code_rounded),
          )
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            // ketika kamera berhasil mendeteksi
            onDetect: (capture) {
              // bakal nyimpen hasilnya di variable barcodes
              final List<Barcode> barcodes = capture.barcodes;
              // tipe data yang menyimpan data sebesar 8 bit memperkecil penyimpanan, biar aplikasinya ramah RAM
              final Uint8List? image = capture.image;

              // untuk ngecek apakah barcode ada di var barcode, kalo valid maka akan melakukan print
              for (final barcode in barcodes) {
                // rawValue = nilai asli dari qr, data mentah berupa link atau apapun
                qrRawValue = barcode.rawValue;
                print("Barcode is valid! Here's the source: $qrRawValue");
              }

              // jika image bukan null (ada) maka akan menampilkan dialog yang menampilkan hasil qr(rawValue)
              if (image != null && qrRawValue != null) {
                controller.stop(); // Stop scanning when QR is detected.
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // rawValue ?? kalo detect dummy qr nanti munculin string itu
                      title: Text(qrRawValue ??
                          "No reference found from this QR code"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              // MemoryImage() salah satu cara menampilkan image yang ramah ke RAM
                              // decode: proses breakdown size dari sebuah objek(image) / kompres size image, karena pake Uint8List
                              child: Image.memory(image),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  // memunculkan interface berbagi (share sheet)
                                  Share.share(
                                    qrRawValue!,
                                    subject: "QR Code Data", //menambahkan subjek saat data dibagikan ke aplikasi yang mendukung subjek, kayak email
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEEF6FF),
                                  foregroundColor: Colors.black
                                ),
                                icon: const Icon(Icons.share),
                                label: const Text("Share"),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // nyimpen ke clipboard perangkat 
                                  Clipboard.setData(
                                    ClipboardData(text: qrRawValue!),
                                  );
                                  // snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("QR Code data copied!"),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEEF6FF),
                                  foregroundColor: Colors.black
                                ),
                                icon: const Icon(Icons.copy),
                                label: const Text("Copy"),
                              ),
                            ],
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // pop dari Dialog
                            Navigator.of(context).pop();
                            resetScanner(); // Restart scanner after dialog closes.
                          },
                          child: const Text("Scan Again", style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton.icon(
                onPressed: resetScanner,
                icon: const Icon(Icons.refresh),
                label: const Text("Reset Scanner"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: bgColor,
                  foregroundColor: Colors.black
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}