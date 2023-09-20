import 'package:flutter/material.dart';
import 'package:message_app/pages/home/chats/chat_arguments.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ChatArguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(args.groupName),
        centerTitle: true,
      ),
    );
  }
}
