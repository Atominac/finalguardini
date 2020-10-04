import 'package:flutter/material.dart';
import 'package:guardini/homescreen.dart';
import 'package:guardini/otpforgot.dart';
import 'package:hexcolor/hexcolor.dart';
import 'register.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'notifications.dart';
//firabase shizz
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController t1 = new TextEditingController(text: "");
  final TextEditingController t2 = new TextEditingController(text: "");

  login() async {
    _showdialogue();
    print(jsonEncode({"mobileno": t1.text, "password": t2.text}));
    final String url =
        "http://34.93.1.41/guardini/public/authenticate.php/user/login";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {"mobileno": t1.text, "password": t2.text},
    );
    print("login response" + response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);
    var userdata = jsondecoded["data"];
    if (jsondecoded['message'] == "success") {
      final user = await SharedPreferences.getInstance();
      user.setString('session_token', userdata["session_token"]);
      user.setString('masterhash', userdata["masterhash"]);
      user.setString('fullname', userdata["fullname"]);
      user.setString('mobileno', userdata["mobileno"]);
      user.setString('email', userdata["email"]);
      await gsmtoken();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (jsondecoded["message"] == "invalid_credentials") {
      Navigator.pop(context);
      showsnack("Mobile or Password incorrect");
    } else if (jsondecoded["message"] == "some_error_has_ouccered") {
      Navigator.pop(context);
      showsnack("Some error has ouccered");
    }
  }

  verifymobile() async {
    _showdialogue();
    var userdata;

    print("login function init");
    _showdialogue();

    print(userdata);
    final String url =
        "http://34.93.1.41/guardini/public/authenticate.php/user/verifymobile";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {"mobileno": t1.text},
    );
    //print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      print("verified");
      Navigator.pop(context);
      Navigator.pop(context);
      showsnack("Mobile not found");
    } else if (jsondecoded["message"] == "mobileno_already_exists") {
      sendotp();
    } else if (jsondecoded["message"] == "some_error_has_ouccered") {
      Navigator.pop(context);

      showsnack("Some error has ouccered");
    }
  }

  sendotp() async {
    final String url =
        "http://34.93.1.41/guardini/public/authenticate.php/user/sendotp";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {"mobileno": t1.text},
    );
    //print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "otp_sent") {
      print("otp_success");
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpForgotForgot(t1.text)),
      );
    } else if (jsondecoded["message"] == "something_went_worng") {
      Navigator.pop(context);
      showsnack("Something went wrong");
    } else if (jsondecoded["message"] == "some_error_has_ouccered") {
      Navigator.pop(context);
      showsnack("Some error has ouccered");
    }
  }

  showsnack(String message) {
    ////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scafoldkey.currentState.showSnackBar(snackBar);
  }

  void _showdialogue() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(child: CircularProgressIndicator()),
          );
        });
  }

  Future<bool> _leave() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to exit? '),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  exit(0);
                }),
          ],
        );
      },
    );
  }

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  DatabaseReference databaseReference = new FirebaseDatabase().reference();
  String fcmtoken;
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  gsmtoken() {
    var android = new AndroidInitializationSettings('mipmap/launcher_icon');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
    var initializationSettings = new InitializationSettings(android, ios);

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Notifications()));
      },
      onResume: (Map<String, dynamic> msg) async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Notifications()));
      },
      onMessage: (Map<String, dynamic> msg) async {
        print("object");
        _showNotificationWithDefaultSound(msg);
      },
    );

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      //print('IOS Setting Registed');
    });
    firebaseMessaging.getToken().then((token) {
      print("token: " + token);
      update(token);
      fcmtoken = token;
    });
  }

  update(String token) async {
    final user = await SharedPreferences.getInstance();

    user.setString("fcm_token", token);

    databaseReference.child('all/${token}').set({"token": token});

    databaseReference
        .child('specefic/${user.getString("masterhash")}/${token}')
        .set({"token": token});

    setState(() {});
  }

  var notifdata;

  showNotification(Map<String, dynamic> msg) async {
    var android = new AndroidNotificationDetails(
      'sdffds dsffds',
      "CHANNLE NAME",
      "channelDescription",
    );

    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, msg["notification"]["title"], msg["notification"]["body"], platform);
    notifdata = msg;
  }

  Future _showNotificationWithDefaultSound(msg) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.High, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      msg["notification"]["title"],
      msg["notification"]["body"],
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
    // _showNotificationWithDefaultSound();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;

    return WillPopScope(
      onWillPop: _leave,
      child: Scaffold(
        key: _scafoldkey,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        16,
                        size.height * 0.3,
                        16,
                        0,
                      ),
                      child: Column(
                        children: <Widget>[
                          // Login Form
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //Mobile Number
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Mobile Number",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Hexcolor('#737373'),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: TextFormField(
                                            decoration: new InputDecoration(
                                              filled: true,
                                              fillColor: Color.fromRGBO(
                                                  239, 233, 224, 0.5),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Hexcolor('#00B6BC'),
                                                ),
                                              ),
                                              border: InputBorder.none,
                                            ),
                                            keyboardType: TextInputType.number,
                                            controller: t1,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter Mobile no.';
                                              } else if (value.length != 10) {
                                                return 'Enter valid Mobile no.';
                                              }
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                //Password
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Password",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Hexcolor('#737373'),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: TextFormField(
                                          decoration: new InputDecoration(
                                            filled: true,
                                            fillColor: Color.fromRGBO(
                                                239, 233, 224, 0.5),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Hexcolor('#00B6BC'),
                                              ),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          obscureText: true,
                                          controller: t2,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter password';
                                            } else if (value.length < 6) {
                                              return 'Password must be atleast 6 characters long';
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //"Forgot Password?"
                                GestureDetector(
                                  onTap: () {
                                    if (t1.text.length < 10) {
                                      showsnack("please enter valid mobile");
                                    } else {
                                      verifymobile();
                                    }
                                  },
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      child: Text(
                                        "Forgot password?",
                                        style: TextStyle(
                                            color: Hexcolor('#219251'),
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //Signin Button
                          Container(
                            margin: EdgeInsets.only(
                                top: size.height * 0.16, bottom: 10),
                            child: InkWell(
                              onTap: () {
                                if (_formKey.currentState.validate()) {
                                  login();
                                }
                              },
                              // enableFeedback: true,
                              splashColor: Color.fromRGBO(255, 194, 51, 0.3),
                              highlightColor:
                                  Color.fromRGBO(255, 194, 51, 0.25),
                              child: Container(
                                width: width,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 194, 51, 0.4),
                                    border: Border.all(
                                      color: Hexcolor('#FFC233'),
                                      width: 0.5,
                                    )),
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Hexcolor('#404040'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //"Do not have an account yet?"
                          Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    'Do not have an account yet? ',
                                    style: TextStyle(
                                      color: Hexcolor('#404040'),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Register()),
                                      );
                                    },
                                    child: Text(
                                      "SIGNUP",
                                      style: TextStyle(
                                        color: Hexcolor('#219251'),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Top background
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: size.height * 0.25,
                        width: size.width,
                        child: Image.asset(
                          'assets/signup_bg.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    //company logo
                    Positioned(
                      top: size.height * 0.124,
                      left: width * 0.126,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/logoguardini.png",
                              height: 80,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            //Notificaton shade bg
            Container(
              color: Hexcolor('#145730'),
              height: 24,
            )
          ],
        ),
      ),
    );
  }
}
