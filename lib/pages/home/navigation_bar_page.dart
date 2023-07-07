import 'package:flutter/material.dart';
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
        actions: [
          if (_currentPageIndex == 2)
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person_add_alt_1_outlined))
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
