import 'package:flutter/material.dart';
import 'package:guardini/home.dart';
import 'package:guardini/homescreen.dart';
import 'package:guardini/login.dart';
import 'package:guardini/onboarding1.dart';
import 'package:guardini/onboarding2.dart';
import 'package:guardini/otpforgot.dart';
import 'package:guardini/welcomebanner.dart';
import 'package:hexcolor/hexcolor.dart';
import 'nointernet.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guardini',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Poppins',
        ),
      ),
      // home: Onboarding2(),
      home: MyHomePage(title: 'Guardini'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    checkinternet();
  }

  checkinternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final user = await SharedPreferences.getInstance();

        if (user.getString("session_token") == null) {
          if(user.getString("first")==null){
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Onboarding2()),
          );
          }else{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
          }
        } else {
          // return;
          checksession();
        }
      }
    } on SocketException catch (_) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoInternet()));
    }
  }

  checksession() async {
    final user = await SharedPreferences.getInstance();

    final String url =
        "http://34.93.1.41/guardini/public/authenticate.php/user/checksession";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {"sessiontoken": user.getString("session_token")},
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

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Welcomebanner()),
      );
    } else if (jsondecoded["message"] == "session_expired") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else if (jsondecoded["message"] == "something_went_worng") {
      // showsnack("Some error has ouccered");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
              'assets/logohd.png',
            ),
            Image.asset(
              "assets/city.png",
            ),
          ],
        ),
      ),
    );
  }
}
