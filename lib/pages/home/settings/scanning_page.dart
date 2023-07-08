import 'package:flutter/material.dart';
import 'package:message_app/widgets/qr_scanner_overlay_shape.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../profile_view/profile_view_arguments.dart';

class ScanningPage extends StatefulWidget {
  const ScanningPage({super.key});

  @override
  State<ScanningPage> createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
        ],
      ),
      body: Stack(children: [
        MobileScanner(
          scanWindow: Rect.fromCenter(
              center: Offset(MediaQuery.of(context).size.width / 2,
                  MediaQuery.of(context).size.height / 2),
              width: 160,
              height: 250),
          controller: cameraController,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              if (barcode.rawValue != null) {
                Navigator.pushReplacementNamed(context, "/profile_view",
                    arguments: ProfileViewArguments(barcode.rawValue!));
              }
            }
          },
        ),
        Positioned.fill(
            child: Container(
          decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                  borderColor: Colors.teal,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 5,
                  cutOutSize: 250)),
        ))
      ]),
    );
  }
}
