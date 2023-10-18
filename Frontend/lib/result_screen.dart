import 'package:flutter/material.dart';
import 'package:frontend/qr_scanner.dart';
// import 'package:qr_flutter/qr_flutter.dart';

class ResultScreen extends StatelessWidget {
  final String code;
  final Function() closeScreen;

  const ResultScreen(
      {super.key, required this.closeScreen, required this.code});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            closeScreen();
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.black87,
        ),
        centerTitle: true,
        title: const Text(
          'QR Scanner',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            //show QR Code here
            // QrImage(
            //   code,
            //   size: 150,
            //   version: QrVersions.auto,
            // ),
            const Text(
              'Scanned Result',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              code,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width - 100,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blue,
            //     ),
            //     onPressed: () {},
            //     child: Text(
            //       'Copy',
            //       style: TextStyle(
            //         fontSize: 16,
            //         color: Colors.black87,
            //         fontWeight: FontWeight.bold,
            //         letterSpacing: 1,
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
