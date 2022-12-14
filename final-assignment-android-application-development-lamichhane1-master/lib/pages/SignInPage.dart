import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/pages/SignUpPage.dart';
import 'package:blog_app/pages/HomePage.dart';
import 'package:blog_app/pages/ForgotPassword.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/sign-in';

  @override
  _SignInPageState createState() => _SignInPageState();
}

void notify() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 1,
        channelKey: 'key1',
        title: 'Just a notification',
        body: 'YOu just signed in',
        notificationLayout: NotificationLayout.BigPicture,
        bigPicture:
            'https://images.idgesg.net/images/article/2019/01/android-q-notification-inbox-100785464-large.jpg?auto=webp&quality=85,70'),
  );
}

class _SignInPageState extends State<SignInPage> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  // String errorText;
  String errorTextUser;
  String errorTextPass;
  bool validate = false;
  bool circular = false;
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          // height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage("https://cdn5.f-cdn.com/contestentries/1465388/27319887/5c437042565d6_thumb900.jpg"),
            fit: BoxFit.cover)
            // gradient: LinearGradient(
            //   colors: [Colors.white, Colors.purple[300]],
            //   begin: const FractionalOffset(0.0, 1.0),
            //   end: const FractionalOffset(0.0, 1.0),
            //   stops: [0.0, 1.0],
            //   tileMode: TileMode.repeated,
            // ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Form(
              key: _globalkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SIGN IN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  usernameTextField(),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  passwordTextField(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ForgotPassword.routeName);
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(SignUpPage.routeName);
                        },
                        child: Text(
                          "New User?",
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        circular = true;
                      });
                      if (_usernameController.text.length == 0 ||
                          _passwordController.text.length == 0) {
                        setState(() {
                          circular = false;
                          validate = false;
                          errorTextUser = _usernameController.text.length == 0
                              ? "Username can't be empty"
                              : null;
                          errorTextPass = _passwordController.text.length == 0
                              ? "Password can't be empty"
                              : null;
                        });
                      } else {
                        Map<String, String> data = {
                          "username": _usernameController.text,
                          "password": _passwordController.text,
                        };
                        var response =
                            await networkHandler.post("/user/login", data);
                        if (response == null) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Some eror occured. Please try later',
                              ),
                              duration: Duration(
                                seconds: 2,
                              ),
                            ),
                          );
                          setState(() {
                            validate = false;
                            circular = false;
                          });
                        } else if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          Map<String, dynamic> output =
                              json.decode(response.body);
                          // Write value
                          await storage.write(
                            key: "token",
                            value: output["token"],
                          );
                          await storage.write(
                            key: "username",
                            value: data["username"],
                          );
                          await storage.write(
                            key: "id",
                            value: output["id"],
                          );
                          setState(() {
                            validate = true;
                            circular = false;
                            notify();
                          });
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              HomePage.routeName, (route) => false);
                        } else {
                          Map<String, dynamic> output =
                              json.decode(response.body);
                          print("3");
                          print(output);
                          setState(() {
                            validate = false;
                            // errorText = output["msg"];
                            errorTextUser = output["msg"].contains("user")
                                ? output["msg"]
                                : null;
                            errorTextPass = output["msg"].contains("password")
                                ? output["msg"]
                                : null;
                            circular = false;
                          });
                        }
                      }
                    },
                    child: circular
                        ? CircularProgressIndicator()
                        : Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.purpleAccent,
                            ),
                            child: Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget usernameTextField() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        controller: _usernameController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          errorText: validate ? null : errorTextUser,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.purpleAccent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 14, 7, 1),
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Icons.person_outline_sharp,
            color: Color.fromARGB(255, 2, 17, 16),
          ),
          labelText: 'UserName',
        ),
      ),
    );
  }

  Widget passwordTextField() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: _passwordController,
        // focusNode: _passwordFocusNode,
        obscureText: vis,
        decoration: InputDecoration(
          errorText: validate ? null : errorTextPass,
          suffixIcon: IconButton(
            icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                vis = !vis;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.purpleAccent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 10, 10, 10),
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Icons.lock_outline_sharp,
            color: Color.fromARGB(255, 4, 15, 14),
          ),
          labelText: 'Password',
        ),
      ),
    );
  }
}
