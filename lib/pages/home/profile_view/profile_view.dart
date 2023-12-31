import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:message_app/pages/home/profile_view/profile_view_arguments.dart';
import 'package:message_app/services/database_service.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ProfileViewArguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(
          child: FutureBuilder(
        future:
            FirebaseFirestore.instance.collection('users').doc(args.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          Map<String, dynamic> data = snapshot.data!.data()!;
          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: CircleAvatar(
                backgroundColor: Colors.teal,
                minRadius: 52,
                maxRadius: 52,
                child: data["profilePicture"] != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(data["profilePicture"]),
                        minRadius: 50,
                        maxRadius: 50,
                      )
                    : const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 80,
                      ),
              ),
            ),
            Text(
              data["displayName"],
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.teal),
                      child: const Icon(
                        Icons.message_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.teal),
                      child: const Icon(
                        Icons.video_call_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.teal),
                      child: const Icon(
                        Icons.phone_in_talk_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.teal),
                    child: PopupMenuButton(
                      color: Colors.teal,
                      offset: const Offset(0, 50),
                      icon: const Icon(
                        Icons.more_horiz_outlined,
                        color: Colors.white,
                      ),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () async {
                            try {
                              await _addContact(args.uid);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                          "Added to contacts successfully",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green));
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  e.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ));
                            }
                          },
                          child: const Text(
                            "Add to contacts",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Status"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  data["status"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Email Address"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  data["email"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]);
        },
      )),
    );
  }

  Future<void> _addContact(String contactUid) async {
    await context.read<DatabaseService>().addContact(contactUid);
  }
}
