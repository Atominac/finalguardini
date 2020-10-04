import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guardini/homescreen.dart';

import 'homescreen.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController t1 = new TextEditingController(text: "");
  final TextEditingController t2 = new TextEditingController(text: "");

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

  changepassword() async {
    _showdialogue();
    final user = await SharedPreferences.getInstance();

    final String url =
        "http://34.93.1.41/guardini/public/authenticate.php/user/changepassword";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {
        "masterhash": user.getString("masterhash"),
        "currentpassword": t1.text,
        "newpassword": t2.text
      },
    );
    //print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);
    if (jsondecoded['message'] == "password_updated_successfully") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (jsondecoded["message"] == "parameter_missing") {
      Navigator.pop(context);
      showsnack("Invalid details");
    } else if (jsondecoded["message"] == "error_in_hash") {
      Navigator.pop(context);
      showsnack("Can't change password");
    } else if (jsondecoded["message"] == "password_not_match") {
      Navigator.pop(context);
      showsnack("Invalid current password");
    } else if (jsondecoded["message"] == "error_updating_password") {
      Navigator.pop(context);
      showsnack("Can't change password");
    } else {
      Navigator.pop(context);
      showsnack("Some error has ouccered");
    }
    //parameter_missing
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;

    return WillPopScope(
      onWillPop: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
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
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Current password ",
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
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "New password ",
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
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          validator: (value) {
                                            if (value != t2.text) {
                                              return 'Password does not match';
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
                                if (_formKey.currentState.validate()) {
                                  changepassword();
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
                                  'Change Password',
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
                    Positioned(
                      top: -25,
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
                    Positioned(
                      top: size.height * 0.16,
                      left: 30,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3)),
                        padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                        child: Text(
                          'RESET PASSWORD',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Hexcolor('#404040'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 5,
                        child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }))
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
      ),
    );
  }
}
