import 'package:flutter/material.dart';
import 'package:guardini/homescreen.dart';
import 'package:guardini/referral_codes.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderRating extends StatefulWidget {
   Map detail;
  OrderRating(this.detail);
  @override
  _OrderRatingState createState() => _OrderRatingState();
}

class _OrderRatingState extends State<OrderRating> {
  double rate = 0;
  final TextEditingController t2 = new TextEditingController(text: "");

final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();
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

rateandreview() async {
    final user = await SharedPreferences.getInstance();
    print(widget.detail["orderid"]);
    print(rate);
    print(t2.text);
    print({
      "masterhash": user.getString("masterhash"),
      "orderid": widget.detail["orderid"].toString(),
      "rating": rate,
      "review": t2.text == null ? "" : t2.text
    });
    // return;
    _showdialogue();
    final String url =
        "http://34.93.1.41/guardini/public/orders.php/user/rating";

    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {
        "masterhash": user.getString("masterhash"),
        "orderid": widget.detail["orderid"].toString(),
        "rating": rate.toString(),
        "review": t2.text == null ? "" : t2.text
      },
    );
    print("start");

    var jsondecoded = json.decode(response.body);
    print(response.body);
    if (jsondecoded["message"] == "success") {
      setState(() {});
      Navigator.pop(context);
      if (rate == 5) {
        // reffral();
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => ReferralCodes(widget.detail)));
      
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } else {
      Navigator.pop(context);
      showsnack("Please retry");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scafoldkey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Order Complete!'),
          backgroundColor: Hexcolor('#219251'),
        ),
        body: ListView(
                  children: [
                    Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset('assets/feedback_img.png'),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 35),
                      child: Text(
                        'Thankyou for booking',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      child: Text(
                        'our services!',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child:  SmoothStarRating(
                          allowHalfRating: false,
                          onRated: (v) {
                            rate = v;
                            setState(() {});
                          },
                          starCount: 5,
                          rating: rate,
                          size: 40.0,
                          color: Colors.orangeAccent,
                          borderColor: Colors.grey,
                          spacing: 10),
                ),
                 Container(
                                         margin: EdgeInsets.only(top: 20, bottom: 10, right: 18, left: 18),

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Reviews",
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
                  margin: EdgeInsets.only(top: 32),
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
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
                              'Rate Later',
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
                        margin: EdgeInsets.only(top: 20, bottom: 10),
                        child: InkWell(
                          onTap: () {
                            // verifyotp(mainotp);
                            rateandreview();
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
                              'Submit',
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
                )
              ],
            ),
          ),
       
                  ],  ),
      ),
    );
  }
  }

