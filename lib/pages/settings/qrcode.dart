
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/user.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserQRCode extends StatelessWidget {
  const UserQRCode({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController =Get.put(UserController());
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text(
            "My QR Code",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 40),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 10.0,
                        spreadRadius: 1.0)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: Image.network("lib/images/profileIcon.png"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(() => Text(userController.user.value!.name))
                      ]),
                    ),
                    Divider(),
                    const SizedBox(
                      height: 5,
                    ),
                    QrImageView(
                      data: 'This QR code has an embedded image as well',
                      version: QrVersions.auto,
                      size: MediaQuery.of(context).size.height / 4.5,
                      gapless: false,
                      embeddedImage:AssetImage("lib/images/logo_without_text.png"),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                          size: Size(
                        MediaQuery.of(context).size.height / 20,
                        MediaQuery.of(context).size.height / 20,
                      )),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Text("Scan QR to invite as collector"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  qrActionButton(title: "Save", icon: Icons.save_alt),
                  qrActionButton(title: "Share", icon: Icons.share)
                ],
              )
            ],
          ),
        ));
  }

  Column qrActionButton({required String title, required IconData icon}) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 5),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        Text(title)
      ],
    );
  }
}
