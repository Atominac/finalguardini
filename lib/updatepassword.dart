import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guardini/homescreen.dart';
import 'login.dart';

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
    return Scaffold(
      key: _scafoldkey,
      appBar: AppBar(
        title: Text("Create new password"),
        backgroundColor: Color.fromRGBO(38, 179, 163, 1),
      ),
      backgroundColor: Color.fromRGBO(240, 248, 255, 1),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Please fill a few details below",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                Card(                    margin: EdgeInsets.only(top: 20),

                                   shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Color.fromRGBO(253, 186, 37, 1),
                                  child: Card(
                                    margin:
                                        EdgeInsetsDirectional.only(bottom: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Password ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                        border: new OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(5.0),
                                          ),
                                        ),
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
                                  Padding(padding: EdgeInsets.all(10)),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Confirm Password ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                        border: new OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(5.0),
                                          ),
                                        ),
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
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Create Password",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      color: Color.fromRGBO(38, 179, 163, 1),
                      textTheme: ButtonTextTheme.normal,
                      height: 50.0,
                      minWidth: 600,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          updatepassword();
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
