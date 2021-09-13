import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:neo_vision/GetMail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';
import 'LoginWithOtherMail.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController hostServerController = TextEditingController();
  TextEditingController emailPasswordController = TextEditingController();
  bool showPassword = false;

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue[300],
      body: Form(
        key: _form,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue[300],
                    ),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.blue[300],
                        size: 80,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Login",
                        style: TextStyle(color: Colors.blue[300], fontSize: 20),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () async {
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          await GMail().getHttpClient().then((value) {
                            sharedPreferences.setString(
                                "LoginType", "GoogleLogin");
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          });
                          // imapExample();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue[300],
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Google",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                // Icon(Icons.mail_outline, color: Colors.white)
                                Image.asset(
                                  "assets/google.png",
                                  width: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Or",
                          style:
                              TextStyle(color: Colors.blue[300], fontSize: 15)),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginWithOtherMail()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue[300],
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Other",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.mail_outline, color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> imapExample() async {
    String userName = 'hwy@tastysoftcloud.com';
    String password = 'htetwaiyanI\$l1tt';
    String hostServer = "tastysoftcloud.com";
    int imapServerPort = 993;
    bool isImapServerSecure = true;

    final client = ImapClient(isLogEnabled: false);

    await client
        .connectToServer(hostServer, imapServerPort,
            isSecure: isImapServerSecure)
        .then((value) {
      print("Connected Success");
    }).catchError((error) {
      print("Connect Fail => $error");
    });
    await client.login(userName, password).then((value) {
      print("Login Success");
    }).catchError((error) {
      print("Login Error");
    });
    await client.selectInbox().then((value) async {
      print("select inbox success");
    }).catchError((error) {
      print("select inbox fail");
    });
    List<MimeMessage> subjectList = [];

    await client
        .fetchRecentMessages(
            messageCount: 20, criteria: 'BODY.PEEK[HEADER.FIELDS (DATE)]')
        .then((fetchResult) {
      print("fetchResult success");
      subjectList = fetchResult.result.messages;
      for (var k = 0; k < subjectList.length; k++) {
        DateTime dateTime = subjectList[k].decodeHeaderDateValue("Date");
        String time = DateFormat.jm().format(
            DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTime.toString()));
        String time2 = time.substring(0, time.lastIndexOf(":"));
        String time3 = "";
        if (time2.length != 2) {
          time3 = "0" + time;
        } else {
          time3 = time;
        }

        print(time3);
      }
    }).catchError((error) {
      print("error ==> $error");
    });

    await client.logout();
  }
}
