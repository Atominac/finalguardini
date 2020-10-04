import 'package:flutter/material.dart';
import 'main.dart';
class NoInternet extends StatefulWidget {
  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        
        children: <Widget>[
          Expanded(
        flex: 8,
              child: Column(
          children: <Widget>[
            Container(margin: EdgeInsets.only(top:20),child: Image.asset("assets/nointernet.png")),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Whoops!",
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
                  "Slow or no internet connection. Please check the internet connection and try again  ",
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
          Expanded(child:  Container(
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
                                "Retry",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      color:Color.fromRGBO(38, 179, 163, 1),
                      textTheme: ButtonTextTheme.normal,
                      height: 50.0,
                      minWidth: 600,
                      onPressed: () {
                        Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyApp()));
                      }),
                ),
              )
        ],
      )    
    );
  }
}
