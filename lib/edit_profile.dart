import 'package:flutter/material.dart';
import 'package:guardini/login.dart';
import 'package:hexcolor/hexcolor.dart';
import 'otp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  var name, mobile, email;
  EditProfile(this.name, this.mobile, this.email);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController t1 = new TextEditingController(text: "");
  final TextEditingController t2 = new TextEditingController(text: "");
  final TextEditingController t3 = new TextEditingController(text: "");
  final TextEditingController t4 = new TextEditingController(text: "");

  showsnack(String message) {
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
      appBar: AppBar(
        backgroundColor: Hexcolor('#219251'),
        title: Text('Profile Details'),
      ),
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      16,
                      30,
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
                                        initialValue: widget.name.toString(),
                                        keyboardType: TextInputType.text,
                                        // controller: t2,
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
                                          enabled: false,
                                          initialValue:
                                              widget.mobile.toString(),
                                          keyboardType: TextInputType.number,
                                          // controller: t1,
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
                                        initialValue: widget.email.toString(),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        // controller: t3,
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
                            onTap: () {},
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
                                'Update',
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
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
