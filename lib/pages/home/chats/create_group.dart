import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  var contacts = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  List checkedUsers = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder(
                future: contacts,
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
                          return ListTile(
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
                                    child:
                                        const Center(child: Icon(Icons.person)))
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        document["profilePicture"]),
                                    minRadius: 25,
                                    maxRadius: 25,
                                  ),
                            trailing: Checkbox(
                              onChanged: (value) {
                                setState(() {
                                  if (checkedUsers.contains(document.id)) {
                                    checkedUsers.remove(document.id);
                                  } else {
                                    checkedUsers.add(document.id);
                                  }
                                });
                              },
                              value: checkedUsers.contains(document.id),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 100),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 70,
              child: TextButton(
                onPressed: () {},
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
                    backgroundColor: MaterialStateProperty.all(Colors.teal)),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Create group",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
