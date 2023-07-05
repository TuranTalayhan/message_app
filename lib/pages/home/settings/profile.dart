import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _displayName = TextEditingController();

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
              TextField(
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
                    return TextField(
                        controller: _displayName,
                        decoration: InputDecoration(
                          labelText: "Status",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "Error = ${snapshot.error}",
                          labelStyle: const TextStyle(color: Colors.teal),
                        ));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return TextField(
                        controller: _displayName,
                        decoration: const InputDecoration(
                          labelText: "Status",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "Loading",
                          labelStyle: TextStyle(color: Colors.teal),
                        ));
                  }
                  Map<String, dynamic> data = snapshot.data!.data()!;

                  return TextField(
                      controller: _displayName,
                      decoration: InputDecoration(
                        labelText: "Status",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: data['status'],
                        labelStyle: const TextStyle(color: Colors.teal),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
