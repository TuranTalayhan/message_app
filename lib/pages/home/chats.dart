import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message_app/pages/home/chats/chat_arguments.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final _groupStream = FirebaseFirestore.instance
      .collection("groups")
      .where("members", arrayContains: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: StreamBuilder(
          stream: _groupStream,
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
                    Navigator.pushNamed(context, "/chat",
                        arguments: ChatArguments(
                            document["groupName"],
                            document["groupPicture"],
                            document["lastMessage"],
                            document["members"]));
                  },
                  child: ListTile(
                    title: Text(document["groupName"]),
                    subtitle: Text(document["lastMessage"]),
                    leading: document["groupPicture"] == null
                        ? Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.teal[50]!.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(child: Icon(Icons.groups_3)))
                        : CircleAvatar(
                            backgroundImage:
                                NetworkImage(document["groupPicture"]),
                            minRadius: 25,
                            maxRadius: 25,
                          ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
