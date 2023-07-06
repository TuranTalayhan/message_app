import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  Future<void> _resetPassword() async {
    if (_status.text.isEmpty && _displayName.text.isEmpty) {
      return;
    } else if (_status.text.isEmpty) {
      try {
        _error = false;
        await Provider.of<AuthService>(context, listen: false)
            .updateInfo(displayName: _displayName.text);
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
    } else if (_displayName.text.isEmpty) {
      try {
        _error = false;
        await Provider.of<AuthService>(context, listen: false)
            .updateInfo(status: _status.text);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.teal[50]!.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                      child: Icon(
                    Icons.person,
                    size: 100,
                  ))),
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
                              await _resetPassword();
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
}
