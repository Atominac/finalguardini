import 'package:flutter/material.dart';
import 'package:guardini/login.dart';
import 'package:hexcolor/hexcolor.dart';
import 'otp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController t1 = new TextEditingController(text: "");
  final TextEditingController t2 = new TextEditingController(text: "");
  final TextEditingController t3 = new TextEditingController(text: "");
  final TextEditingController t4 = new TextEditingController(text: "");

  verifymobile() async {
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
      sendotp();
    } else if (jsondecoded["message"] == "mobileno_already_exists") {
      Navigator.pop(context);

      showsnack("Mobile no already exists");
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
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Otp(t1.text, t2.text, t3.text, t4.text)),
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

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;

    return Scaffold(
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
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Hexcolor('#737373'),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      child: TextFormField(
                                        decoration: new InputDecoration(
                                          filled: true,
                                          fillColor: Color.fromRGBO(
                                              239, 233, 224, 0.5),
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
                                        keyboardType: TextInputType.text,
                                        controller: t2,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter valid name';
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Mobile Number",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Hexcolor('#737373'),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
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
                                              return 'Please enter Phone Number';
                                            } else if (value.length != 10) {
                                              return 'Enter valid Phone Number';
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email id",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Hexcolor('#737373'),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      child: TextFormField(
                                        decoration: new InputDecoration(
                                          filled: true,
                                          fillColor: Color.fromRGBO(
                                              239, 233, 224, 0.5),
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
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: t3,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter email id';
                                          } else if (!value.contains("@")) {
                                            return 'enter valid email id';
                                          } else if (!value.contains(".")) {
                                            return 'enter valid email id';
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
                        //Create Account Button
                        Container(
                          margin: EdgeInsets.only(
                              top: size.height * 0.12, bottom: 10),
                          child: InkWell(
                            onTap: () {
                              print(t4.text);
                              if (_formKey.currentState.validate()) {
                                print("object");
                                verifymobile();
                              }
                            },
                            // enableFeedback: true,
                            splashColor: Color.fromRGBO(255, 194, 51, 0.3),
                            highlightColor: Color.fromRGBO(255, 194, 51, 0.25),
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
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Hexcolor('#404040'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                      color: Hexcolor('#404040'),
                                    ),
                                  )),
                              Container(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()),
                                    );
                                  },
                                  child: Text(
                                    "LOGIN",
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
                  Container(
                    height: size.height * 0.28,
                    width: size.width,
                    child: Image.asset(
                      'assets/login-sgnup.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
               ],
              ),
            ],
          ),
          Container(
            color: Hexcolor('#145730'),
            height: 24,
          )
        ],
      ),
    );
  }
}
