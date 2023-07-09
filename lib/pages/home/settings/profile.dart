import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _displayName = TextEditingController();
  final _status = TextEditingController();
  bool _isLoading = false;
  bool _error = false;
  File? image;
  UploadTask? uploadTask;
  String? downloadURL;

  @override
  Widget build(BuildContext context) {
    Image? tempImage;
    if (image != null) {
      tempImage = Image.file(
        image!,
        height: 150,
        width: 150,
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              GestureDetector(
                  onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 200,
                            child: Column(children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: InkWell(
                                  onTap: () async {
                                    await _pickImage(ImageSource.camera);
                                    await _cropImage();
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const ListTile(
                                      leading: Icon(Icons.camera_alt),
                                      title: Text("Camera")),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await _pickImage(ImageSource.gallery);
                                  await _cropImage();
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: const ListTile(
                                    leading: Icon(Icons.photo),
                                    title: Text("Gallery")),
                              ),
                            ]),
                          );
                        },
                      ),
                  child: image == null
                      ? Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.teal[50]!.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: FutureBuilder(
                            future: _getImageURL(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Icon(
                                  Icons.person,
                                  size: 100,
                                ));
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              String? imageURL = snapshot.data;
                              return CircleAvatar(
                                backgroundImage: NetworkImage(imageURL!),
                                minRadius: 75,
                                maxRadius: 75,
                              );
                            },
                          ))
                      : CircleAvatar(
                          backgroundImage: tempImage!.image,
                          minRadius: 75,
                          maxRadius: 75,
                        )),
              const SizedBox(height: 20),
              Form(
                  child: Column(
                children: [
                  TextFormField(
                      controller: _displayName,
                      decoration: InputDecoration(
                        labelText: "Name",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: _getDisplayname(),
                        labelStyle: const TextStyle(color: Colors.teal),
                      )),
                  const SizedBox(height: 20),
                  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                    builder: (_, snapshot) {
                      if (snapshot.hasError) {
                        return TextFormField(
                            controller: _status,
                            decoration: InputDecoration(
                              labelText: "Status",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: "Error = ${snapshot.error}",
                              labelStyle: const TextStyle(color: Colors.teal),
                            ));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return TextFormField(
                            controller: _status,
                            decoration: const InputDecoration(
                              labelText: "Status",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: "Loading",
                              labelStyle: TextStyle(color: Colors.teal),
                            ));
                      }
                      Map<String, dynamic> data = snapshot.data!.data()!;

                      return TextFormField(
                          controller: _status,
                          decoration: InputDecoration(
                            labelText: "Status",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: data['status'],
                            labelStyle: const TextStyle(color: Colors.teal),
                          ));
                    },
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 70,
                    child: !_isLoading
                        ? TextButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await _uploadImage();
                              await _updateInfo();
                              setState(() {
                                _isLoading = false;
                              });
                              if (!_error && context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                          "Saved changes successfully",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green));
                                Navigator.pop(context);
                              }
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.teal)),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Save changes",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        : TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.teal)),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  String _getDisplayname() {
    try {
      return Provider.of<AuthService>(context, listen: false).displayName;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      return "error";
    }
  }

  Future<void> _updateInfo() async {
    try {
      _error = false;
      await Provider.of<AuthService>(context, listen: false).updateInfo(
          status: _status.text.isNotEmpty ? _status.text : null,
          displayName: _displayName.text.isNotEmpty ? _displayName.text : null,
          downloadURL: downloadURL);
    } catch (e) {
      _error = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        return;
      }
      this.image = File(image.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _cropImage() async {
    CroppedFile? image = await ImageCropper().cropImage(
        sourcePath: this.image!.path,
        aspectRatio: const CropAspectRatio(ratioX: 150, ratioY: 150));

    if (image == null) {
      return;
    }

    setState(() {
      this.image = File(image.path);
    });
  }

  Future<void> _uploadImage() async {
    if (image == null) {
      return;
    }
    final path = "${FirebaseAuth.instance.currentUser!.uid}/profilePicture";
    final File file = image!;

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});
    downloadURL = await snapshot.ref.getDownloadURL();
    uploadTask = null;
  }

  Future<String?> _getImageURL() async {
    try {
      String imageURL = await FirebaseStorage.instance
          .ref()
          .child("${FirebaseAuth.instance.currentUser!.uid}/profilePicture")
          .getDownloadURL();
      return imageURL;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
