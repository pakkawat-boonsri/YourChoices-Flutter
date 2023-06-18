import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/src/presentation/views/admin_side/qr_code_result_view/qr_code_result_view.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/loading_dialog.dart';

class QrCodeScannerView extends StatefulWidget {
  const QrCodeScannerView({Key? key}) : super(key: key);

  @override
  State<QrCodeScannerView> createState() => _QrCodeScannerViewState();
}

class _QrCodeScannerViewState extends State<QrCodeScannerView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String result = '';
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.pauseCamera();
    await Future.delayed(const Duration(seconds: 2)).then((value) {
      controller.resumeCamera();
    });
    controller.scannedDataStream.listen((scanData) {
      result = scanData.code!;
      if (result.isNotEmpty) {
        loadingDialog(context);
        controller.pauseCamera();
        Future.delayed(const Duration(seconds: 1)).then((value) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QrCodeResultView(customerData: result),
              ));
          controller.dispose();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const CustomText(
          text: "สแกนคิวอาร์โคด",
          fontSize: 20,
          color: Colors.white,
        ),
        centerTitle: true,
        leading: TouchableOpacity(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: "B44121".toColor(),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 22,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: QRView(
        key: qrKey,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.amber.shade900,
          borderRadius: 10,
          borderLength: 40,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }
}
