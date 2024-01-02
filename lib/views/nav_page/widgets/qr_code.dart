import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:smartshop/services/service_firebase.dart';
import 'package:smartshop/views/nav_page/widgets/input_textfield.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  final GlobalKey globalKey = GlobalKey();
  late String qrData = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Create Qr Code Scanner',
          style: styles(color: Colors.black87),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            RepaintBoundary(
              key: globalKey,
              child: Container(
                color: Colors.white,
                // child: Center(
                  // child: qrData.isEmpty
                  //     ? Text(
                  //         'Enter Data To Generate OR Code',
                  //         style: styles(fontSize: 20, color: Colors.indigo),
                  //       )
                  //     : QrImage(
                  //         data: qrData,
                  //         version: QrVersions.auto,
                  //         size: 200,
                  //       ),
                // ),
              ),
            ),
            const SizedBox(height: 50),
            InputTextfield(
              textInputType: TextInputType.text,
              prefixIcon: const Icon(IconlyLight.scan),
              hintText: 'Enter Data',
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please enter your Qr Code';
                } else if (val.length < 8) {
                  return 'QrCode longer than eight characters';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                setState(() {
                  qrData = value;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
