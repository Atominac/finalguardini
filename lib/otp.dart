
import 'package:flutter/material.dart';
import 'package:guardini/createpassword.dart';
import 'register.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Otp extends StatefulWidget {
  var mobile, fullname, email,gst;
  Otp(this.mobile, this.fullname, this.email,this.gst);
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  Timer timer;
  int start = 59;
  var disp = "59";
  var mainotp="";
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
    print(widget.mobile);
    _showdialogue();
    print(otp);
    print(widget.mobile);
    final String url =
        "http://34.93.1.41/guardini/public/authenticate.php/user/verifyotp";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {"mobileno": widget.mobile,"otp":otp},
    );
    //print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "otp_verified") {
      print("otp_success");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreatePassword(widget.mobile,widget.fullname, widget.email,widget.gst)),
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
          disp="59";
          start=59;
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
    return Scaffold(
      key: _scafoldkey,
      appBar: AppBar(
        title: Text("OTP Verification"),
        backgroundColor: Color.fromRGBO(38, 179, 163, 1),
      ),
      backgroundColor: Color.fromRGBO(240, 248, 255, 1),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Please enter a Verification code",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                Card( margin: EdgeInsets.only(top: 20),
                                   shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Color.fromRGBO(253, 186, 37, 1),
                                  child: Card(
                                    margin:
                                        EdgeInsetsDirectional.only(bottom: 5),
                    elevation: 2,
                   
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: PinEntryTextField(
                              fields: 6,
                              fontSize: 15.0,
                              fieldWidth:30.0,
                              onSubmit: (String otp) {
                                mainotp=otp;
                                verifyotp(otp); //end showDialog()
                              }, // end onSubmit
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 60),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Didn't recieve?  ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.grey),
                                ),
                                GestureDetector(
                                  onTap: disp == "00" ? () {
                                    resendotp();
                                  } : () {},
                                  child: Text(
                                    disp == "00"
                                        ? "Resend"
                                        : "Resend in 00:" + disp,
                                    style: TextStyle(
                                        color: Color.fromRGBO(38, 179, 163, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          )
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
                                "Verify",
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
                        verifyotp(mainotp);
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
