import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
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
                  return const Text("loading");
                }
                Map<String, dynamic> data = snapshot.data!.data()!;
                return InkWell(
                  onTap: () async {
                    await Navigator.pushNamed(context, "/profile");
                    setState(() {});
                  },
                  child: ListTile(
                    title: Text(data["displayName"]),
                    subtitle: Text(data["status"]),
                    trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Colors.teal,
                          size: 30,
                        )),
                    leading: data["profilePicture"] == null
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
                                NetworkImage(data["profilePicture"]),
                            minRadius: 25,
                            maxRadius: 25,
                          ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: const Text("Account"),
                subtitle: const Text("Privacy, security, change number"),
                leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal[50]!.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Icon(MdiIcons.keyOutline))),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: const Text("Chat"),
                subtitle: const Text("Chat history,theme,wallpapers"),
                leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal[50]!.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(child: Icon(Icons.message_outlined))),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: const Text("Notifications"),
                subtitle: const Text("Messages, group and others"),
                leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal[50]!.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                        child: Icon(Icons.notifications_outlined))),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: const Text("Help"),
                subtitle: const Text("Help center,contact us, privacy policy"),
                leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal[50]!.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(child: Icon(Icons.help_outline))),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: const Text("Storage and data"),
                subtitle: const Text("Network usage, storage usage"),
                leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal[50]!.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(child: Icon(Icons.swap_vert_outlined))),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: const Text("Invite a friend"),
                leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal[50]!.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(child: Icon(Icons.person_outline))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
