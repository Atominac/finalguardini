import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guardini/homescreen.dart';
//firabase shizz
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CreatePassword extends StatefulWidget {
  var mobile, fullname, email, gst;
  CreatePassword(this.mobile, this.fullname, this.email, this.gst);
  @override
  _CreatePasswordState createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final TextEditingController t1 = new TextEditingController(text: "");

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

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  register() async {
    print(jsonEncode({
      "mobileno": widget.mobile,
      "fullname": widget.fullname,
      "email": widget.email,
      "password": t1.text,
      "gst": widget.gst
    }));
    // return;
    _showdialogue();
    final String url =
        "http://34.93.1.41/guardini/public/authenticate.php/user/register";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {
        "mobileno": widget.mobile,
        "fullname": widget.fullname,
        "email": widget.email,
        "password": t1.text,
        "gst": widget.gst
      },
    );
    //print("login response"+response.body);
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
    } else if (jsondecoded["message"] == "invalid_mobileno") {
      Navigator.pop(context);
      showsnack("Invalid mobile");
    } else if (jsondecoded["message"] == "mobileno_already_exists") {
      Navigator.pop(context);
      showsnack("mobile already exist");
    } else {
      Navigator.pop(context);
      showsnack("Some error has ouccered");
    }
  }

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
      onLaunch: (Map<String, dynamic> msg) async {},
      onResume: (Map<String, dynamic> msg) async {
        if (notifdata["data"]["screen"] == "screenA") {}
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

    return Scaffold(
      key: _scafoldkey,
      appBar: AppBar(
        title: Text("Create Password"),
        backgroundColor: Hexcolor('#219251'),
      ),
      backgroundColor: Colors.white,
      body:  ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: <Widget>[
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     "Please fill a few details below",
                    //     style: TextStyle(
                    //         fontSize: 20, fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Password ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Hexcolor('#737373'),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    helperText:
                                        'Min.6 characters atleast 1 number',
                                    filled: true,
                                    fillColor: Color.fromRGBO(
                                      239,
                                      233,
                                      224,
                                      0.5,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
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
                                  controller: t1,
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
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Confirm Password ",
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
                                        239,
                                        233,
                                        224,
                                        0.5,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
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
                                    validator: (value) {
                                      if (value != t1.text) {
                                        return 'Password dosent match';
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: size.height * 0.12, bottom: 10),
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            register();
                          }
                        },
                        // enableFeedback: true,
                        splashColor: Color.fromRGBO(255, 194, 51, 0.3),
                        highlightColor: Color.fromRGBO(255, 194, 51, 0.25),
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 194, 51, 0.4),
                              border: Border.all(
                                color: Hexcolor('#FFC233'),
                                width: 0.5,
                              )),
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            'Create Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Hexcolor('#404040'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Positioned(
              //   top: -25,
              //   left: 0,
              //   child: Container(
              //     height: size.height * 0.25,
              //     width: size.width,
              //     child: Image.asset(
              //       'assets/signup_bg.png',
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              // Positioned(
              //   top: size.height * 0.16,
              //   left: 30,
              //   child: Container(
              //     decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(3)),
              //     padding: EdgeInsets.only(left: 30, right: 30, top: 10),
              //     child: Text(
              //       'CREATE PASSWORD',
              //       style: TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.w700,
              //         color: Hexcolor('#404040'),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
    );
  }
}
