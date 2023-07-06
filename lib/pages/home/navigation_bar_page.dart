import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import 'calls.dart';
import 'chats.dart';
import 'contacts.dart';
import 'settings.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _currentPageIndex = 0;

  final _widgets = <Widget>[
    const Chats(),
    const Calls(),
    const Contacts(),
    const Settings()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  await Provider.of<AuthService>(context, listen: false)
                      .signOut();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      e.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              icon: const Icon(Icons.person)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.message_outlined,
                size: 30,
              ),
              label: "Chats"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.phone_in_talk_outlined,
                size: 30,
              ),
              label: "Calls"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_outlined,
                size: 30,
              ),
              label: "Contacts"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings_outlined,
                size: 30,
              ),
              label: "Settings")
        ],
        currentIndex: _currentPageIndex,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
      body: _widgets[_currentPageIndex],
    );
  }
}
