import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'profile_view/profile_view_arguments.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final _contacts = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: FutureBuilder(
          future: _contacts,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("error");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var data = snapshot.data!.data();
            if (data == null) {
              return const Text("data is null");
            }
            if (data["contacts"] == null) {
              return const Text("no contacts");
            }
            List list = data["contacts"];

            final userStream = FirebaseFirestore.instance
                .collection("users")
                .where(FieldPath.documentId, whereIn: list)
                .snapshots();

            return StreamBuilder(
              stream: userStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("error");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    var document = snapshot.data!.docs[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/profile_view",
                            arguments: ProfileViewArguments(document.id));
                      },
                      child: ListTile(
                        title: Text(document["displayName"]),
                        subtitle: Text(document["status"]),
                        leading: document["profilePicture"] == null
                            ? Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.teal[50]!.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(child: Icon(Icons.person)))
                            : CircleAvatar(
                                backgroundImage:
                                    NetworkImage(document["profilePicture"]),
                                minRadius: 25,
                                maxRadius: 25,
                              ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
