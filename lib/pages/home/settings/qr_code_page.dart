import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  Future<void> _setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      throw Exception("Failed to set brightness");
    }
  }

  @override
  void initState() {
    super.initState();
    _setBrightness(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("QR code"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  const Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: SizedBox(
                        height: 350,
                        width: 350,
                      )),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("error");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      Map<String, dynamic> data = snapshot.data!.data()!;

                      return Positioned.fill(
                        top: 5,
                        child: Column(children: [
                          data["profilePicture"] == null
                              ? Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.teal[50]!.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child:
                                      const Center(child: Icon(Icons.person)))
                              : CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(data["profilePicture"]),
                                  minRadius: 30,
                                  maxRadius: 30,
                                ),
                          Text(
                            data["displayName"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                          Text("MessageApp user",
                              style: TextStyle(color: Colors.grey[600]))
                        ]),
                      );
                    },
                  ),
                  Positioned(
                    right: 75,
                    bottom: 50,
                    child: QrImageView(
                      data: FirebaseAuth.instance.currentUser!.uid,
                      size: 200,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 150,
              ),
              SizedBox(
                width: 300,
                height: 55,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/scanning_page");
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                      backgroundColor: MaterialStateProperty.all(Colors.teal)),
                  child: const Text(
                    "Scan",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
