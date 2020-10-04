import 'package:flutter/material.dart';
import 'package:guardini/homescreen.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:quick_feedback/quick_feedback.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReferralCodes extends StatefulWidget {
  Map detail;
  ReferralCodes(this.detail);
  @override
  _ReferralCodesState createState() => _ReferralCodesState();
}

class _ReferralCodesState extends State<ReferralCodes> {
  final TextEditingController t1 = new TextEditingController(text: "");
  final TextEditingController t2 = new TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();
  addreffral() async {
    final user = await SharedPreferences.getInstance();
    print(widget.detail["orderid"]);
    // print(rate);
    print(t1.text);
    print({
      "masterhash": user.getString("masterhash"),
      "mobileno": t1.text,
      "name": t2.text
    });
    // return 0;
    _showdialogue();
    final String url =
        "http://34.93.1.41/guardini/public/orders.php/user/reffral";

    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {
        "masterhash": user.getString("masterhash"),
        "mobileno": t1.text,
        "name": t2.text
      },
    );
    print("start");

    var jsondecoded = json.decode(response.body);
    print(response.body);
    if (jsondecoded["message"] == "success") {
      setState(() {});
      Navigator.pop(context);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.pop(context);
      showsnack("Please retry");
    }
  }

  showsnack(String message) {
    print(message);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scafoldkey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Referral Codes'),
          backgroundColor: Hexcolor('#219251'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 35),
                          child: Text(
                            'Refer your friends and get 50% off ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            'your next order',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Text(
                            'How do you like our service? Please give ',
                            style: TextStyle(
                              color: Hexcolor('#404040'),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'us your valuable feedback.',
                            style: TextStyle(
                              color: Hexcolor('#404040'),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 60),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  margin: EdgeInsets.only(top: 30),
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.38,
                  ),
                  width: MediaQuery.of(context).size.width - 32,
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 10, right: 18),
                        child: InkWell(
                          onTap: () {
                            // verifyotp(mainotp);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                            //
                          },
                          // enableFeedback: true,
                          splashColor: Color.fromRGBO(255, 194, 51, 0.3),
                          highlightColor: Color.fromRGBO(255, 194, 51, 0.25),
                          child: Container(
                            width: 160,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Hexcolor('#FFC233'),
                                  width: 0.5,
                                )),
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Hexcolor('#404040'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 10, left: 18),
                        child: InkWell(
                          onTap: () {
                            // verifyotp(mainotp);
                            if (_formKey.currentState.validate()) {
                              if (t1.text == "" || t2.text == "") {
                                showsnack("Please enter mobile no. and name");
                              } else {
                                addreffral();
                              }
                            }
                            // addreffral();
                          },
                          // enableFeedback: true,
                          splashColor: Color.fromRGBO(255, 194, 51, 0.3),
                          highlightColor: Color.fromRGBO(255, 194, 51, 0.25),
                          child: Container(
                            width: 160,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 194, 51, 0.4),
                                border: Border.all(
                                  color: Hexcolor('#FFC233'),
                                  width: 0.5,
                                )),
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'Send',
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
          ),
        ),
      ),
    );
  }
}
