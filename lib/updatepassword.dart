import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guardini/homescreen.dart';
import 'login.dart';
import 'package:hexcolor/hexcolor.dart';

class UpdatePassword extends StatefulWidget {
  var mobile,otp ;
  UpdatePassword(this.mobile, this.otp);
  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
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

  updatepassword() async {
    print(t1.text);
    print( widget.mobile);
        print( widget.otp);

    _showdialogue();
    final String url =
        "http://34.93.1.41/guardini/public/authenticate.php/user/forgotpassword";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {"mobileno": widget.mobile, "otp": widget.otp, "password": t1.text},
    );
    //print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);
    if (jsondecoded['message'] == "success") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else if (jsondecoded["message"] == "retry_sending_otp") {
      Navigator.pop(context);
      showsnack("Retry sending otp");
    } else if (jsondecoded["message"] == "error_while_updating_password") {
      Navigator.pop(context);
      showsnack("Please retry");
    } else if (jsondecoded["message"] == "invalid_request") {
      Navigator.pop(context);
      showsnack("Invalid request");
    } else if (jsondecoded["message"] == "parameter_missing") {
      Navigator.pop(context);
      showsnack("parameter Missing");
    }else {
      Navigator.pop(context);
      showsnack("Some error has ouccered");
    }
    //parameter_missing
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

     return Scaffold(
      key: _scafoldkey,
      // appBar: AppBar(
      //   title: Text("Create Password"),
      //   backgroundColor: Hexcolor('#219251'),
      // ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(16, size.height * 0.3, 16, 0),
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
                                      updatepassword();
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
                                'Reset Password',
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
                  // Positioned(
                  //     top: 5,
                  //     child: IconButton(
                  //         icon: Icon(Icons.arrow_back),
                  //         onPressed: () {
                  //           Navigator.of(context).pop();
                  //         }))
                ],
              ),
            ],
          ),
          Container(
            color: Hexcolor('#219251'),
            height: MediaQuery.of(context).padding.top,
          )
        ],
      ),
    );
  }
}
