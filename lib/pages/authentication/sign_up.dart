import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:message_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final bool isDarkMode =
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;

  final name = TextEditingController();

  final email = TextEditingController();

  final password = TextEditingController();

  final passwordConfirm = TextEditingController();

  late bool error;

  bool isLoading = false;

  Future<void> signUpUser() async {
    if (password.text != passwordConfirm.text) {
      error = true;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Passwords do not match",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      error = false;
      await Provider.of<AuthService>(context, listen: false)
          .signUpWithEmailAndPassword(name.text, email.text, password.text);
    } catch (e) {
      error = true;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Sign up with Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Text(
                "Get chatting with friends and family today by signing up for our chat app!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.grey[700],
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: TextFormField(
                        controller: name,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 20.0),
                            labelText: "Your name",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle:
                                TextStyle(fontSize: 20, color: Colors.teal))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 20.0),
                            labelText: "Your email",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle:
                                TextStyle(fontSize: 20, color: Colors.teal))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 20.0),
                            labelText: "Password",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle:
                                TextStyle(fontSize: 20, color: Colors.teal))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: TextFormField(
                        controller: passwordConfirm,
                        obscureText: true,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 20.0),
                            labelText: "Confirm Password",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle:
                                TextStyle(fontSize: 20, color: Colors.teal))),
                  ),
                  const SizedBox(height: 60),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 70,
                    child: !isLoading
                        ? TextButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await signUpUser();
                              setState(() {
                                isLoading = false;
                              });
                              if (!error && context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                          "Signed up successfully",
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
                              child: Text("Create an account",
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
        ));
  }
}
