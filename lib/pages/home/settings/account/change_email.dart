import 'package:flutter/material.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final _currentEmail = TextEditingController();
  final _newEmail = TextEditingController();
  final _newEmailConfirm = TextEditingController();
  bool _error = false;
  bool _hasChanged = false;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Change email"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextFormField(
                  controller: _currentEmail,
                  decoration: const InputDecoration(
                    labelText: "Current email",
                  )),
              const SizedBox(height: 20),
              TextFormField(
                  controller: _newEmail,
                  decoration: const InputDecoration(
                    labelText: "New email",
                  )),
              const SizedBox(height: 20),
              TextFormField(
                  controller: _newEmailConfirm,
                  decoration: const InputDecoration(
                    labelText: "Confirm new email",
                  )),
              const SizedBox(height: 50),
              SizedBox(
                width: MediaQuery.of(context).size.width - 70,
                child: !_isLoading
                    ? TextButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          _changeEmail();
                          setState(() {
                            _isLoading = false;
                          });
                          if (context.mounted) {
                            if (!_error && _hasChanged) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Text(
                                        "Saved changes successfully",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green));
                            }
                            Navigator.pop(context);
                          }
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.teal)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Save changes",
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
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.teal)),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _changeEmail() {}
}
