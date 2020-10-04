import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:guardini/homescreen.dart';
import 'package:http/http.dart' as http;

class Welcomebanner extends StatefulWidget {
  @override
  _WelcomebannerState createState() => _WelcomebannerState();
}

class _WelcomebannerState extends State<Welcomebanner> {
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchbanner();
  }

  var timer;
  startTime() async {
    var duration = new Duration(seconds: 5);
    timer = Timer(duration, route);
  }

  route() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  var welcome;
  fetchbanner() async {
    final String url =
        "http://34.93.1.41/guardini/public/listing.php/user/fetchwelcomebanner";
    var response = await http.get(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
    );
    ////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      welcome = jsondecoded["data"][0];
      startTime();

      setState(() {});
    } else if (jsondecoded['message'] == "no_promos_found") {
      showsnack("No promos available");
    } else {
      showsnack("Some error has ouccered");
    }
  }

  showsnack(String message) {
    //////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scafoldkey.currentState.showSnackBar(snackBar);
  }

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    return WillPopScope(
      onWillPop: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
      child: Scaffold(
        key: _scafoldkey,
        body: Container(
            margin: EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: welcome == null
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Image.network(
                          welcome["imageurl"],
                          width: double.infinity,
                          height: (70 / 100) * height,
                        ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
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
                                "Skip",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      color: Colors.orangeAccent,
                      textTheme: ButtonTextTheme.normal,
                      height: 50.0,
                      minWidth: 600,
                      onPressed: () {
                        if (timer != null) {
                          timer.cancel();
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      }),
                )
              ],
            )),
      ),
    );
  }
}
