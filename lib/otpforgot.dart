import 'package:flutter/material.dart';
import 'package:guardini/createpassword.dart';
import 'package:guardini/updatepassword.dart';
import 'package:hexcolor/hexcolor.dart';
import 'register.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpForgotForgot extends StatefulWidget {
  var mobile;
  OtpForgotForgot(this.mobile);
  @override
  _OtpForgotForgotState createState() => _OtpForgotForgotState();
}

class _OtpForgotForgotState extends State<OtpForgotForgot> {
  Timer timer;
  int start = 59;
  var disp = "59";
  var mainotp = "";

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (start < 1) {
            timer.cancel();
          } else {
            start = start - 1;
            if (start < 10) {
              disp = "0" + start.toString();
            } else {
              disp = start.toString();
            }
          }
        },
      ),
    );
  }

  verifyotp(otp) async {
    // print(jsonEncode({"mobileno": widget.mobile, "otp": otp}));
    // return 0;
    print(widget.mobile);
    _showdialogue();
    print(otp);
    print(widget.mobile);
    final String url =
        "http://34.93.1.41/guardini/public/authenticate.php/user/verifyforgototp";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {"mobileno": widget.mobile, "otp": otp},
    );
    //print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "otp_verified") {
      print("otp_success");

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdatePassword(widget.mobile, otp)),
      );
    } else if (jsondecoded["message"] == "invalid_otp") {
      Navigator.pop(context);
      showsnack("Invalid otp");
    } else if (jsondecoded["message"] == "some_error_has_ouccered") {
      Navigator.pop(context);
      showsnack("Some error has ouccered");
    }
  }

  resendotp() async {
    print(widget.mobile);

    _showdialogue();

    final String url =
        "http://34.93.1.41/guardini/public/authenticate.php/user/sendotp";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {"mobileno": widget.mobile},
    );
    //print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "otp_sent") {
      print("otp_success");
      showsnack("OTP resend");
      startTimer();
      disp = "59";
      start = 59;
      Navigator.pop(context);
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

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scafoldkey,
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("OTP"),backgroundColor: 
       Hexcolor('#219251'),),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //"Enter OTP sent to your registered mobile number"
                Container(
                  width: size.width * 0.6,
                  child: Text(
                    "Enter OTP sent to your registered mobile number",
                    style:
                        TextStyle(fontSize: 16, color: Hexcolor('#404040')),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: PinEntryTextField(
                    showFieldAsBox: true,
                    fields: 6,
                    fontSize: 18.0,
                    fieldWidth: size.width * 0.125,
                    onSubmit: (String otp) {
                      mainotp = otp;
                      verifyotp(otp); //end showDialog()
                    }, // end onSubmit
                  ),
                ),
                //"Didn't recieve? "
                Container(
                  margin: EdgeInsets.only(top: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Didn't recieve? ",
                        style: TextStyle(
                          color: Hexcolor('#404040'),
                        ),
                      ),
                      GestureDetector(
                        onTap: disp == "00"
                            ? () {
                                resendotp();
                              }
                            : () {},
                        child: Text(
                          disp == "00" ? "Resend" : "Resend in 00:" + disp,
                          style: TextStyle(
                            color: Hexcolor('#219251'),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                //Verify OTP Button
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      verifyotp(mainotp);
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
                        'Verify OTP',
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
    );
  }
}
