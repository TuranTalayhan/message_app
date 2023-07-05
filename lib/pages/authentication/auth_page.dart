import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color(0xffadadad),
            Color(0xff979797),
            Color(0xff828282),
            Color(0xff6c6c6c),
            Color(0xff565656),
            Color(0xff414141),
            Color(0xff2b2b2b),
          ])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Wrap(children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "MessageApp",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                        const SizedBox(width: 5),
                        Image.asset(
                          "assets/MessageAppLogo.png",
                          scale: 40,
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      "Connect",
                      style: TextStyle(fontSize: 80, color: Colors.white),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      "friends",
                      style: TextStyle(fontSize: 80, color: Colors.white),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      "easily &",
                      style: TextStyle(
                          fontSize: 70.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      "quickly",
                      style: TextStyle(
                          fontSize: 70.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      "Our chat app is the perfect way to stay connected with friends and family.",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            alignment: Alignment.center,
                            shape:
                                MaterialStateProperty.all(const CircleBorder()),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(15)),
                            side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.white70))),
                        child: Image.asset("assets/Facebook.png", scale: 60),
                      ),
                      const SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            alignment: Alignment.center,
                            shape:
                                MaterialStateProperty.all(const CircleBorder()),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(15)),
                            side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.white70))),
                        child: Image.asset("assets/G.png", scale: 15),
                      ),
                      const SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            alignment: Alignment.center,
                            shape:
                                MaterialStateProperty.all(const CircleBorder()),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(15)),
                            side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.white70))),
                        child: Image.asset("assets/Apple.png", scale: 40),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(children: <Widget>[
                      Expanded(child: Divider(color: Colors.white70)),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.white70)),
                    ]),
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 70,
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, "/sign_up_page"),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Sign up with email",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Existing account?",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, "/login_page"),
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              ),
            ]),
          )),
    );
  }
}
