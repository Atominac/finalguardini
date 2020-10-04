import 'package:flutter/material.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';

class Appupdate extends StatefulWidget {
  @override
  _AppupdateState createState() => _AppupdateState();
}

class _AppupdateState extends State<Appupdate> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
          body: Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Image.asset("assets/appupdate.png")),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Hi there!",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.all(30),
                    child: Text(
                      "You have not updated your app in a while. Please update to continue using the service ",
                      overflow: TextOverflow.fade,
                      maxLines: 5,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
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
                            "Update",
                            style:
                                TextStyle(color: Colors.white, fontSize: 17.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  color: Color.fromRGBO(38, 179, 163, 1),
                  textTheme: ButtonTextTheme.normal,
                  height: 50.0,
                  minWidth: 600,
                   onPressed: () async {
                var url = "https://play.google.com/store/apps/details?id=com.kmguardini.guardini";
                print(url);
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
                  ),
            ),
          )
        ],
      )),
    );
  }
}
