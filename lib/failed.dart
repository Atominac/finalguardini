import 'package:flutter/material.dart';
import 'homescreen.dart';
class Orderfailed extends StatefulWidget {
  @override
  _OrderfailedState createState() => _OrderfailedState();
}

class _OrderfailedState extends State<Orderfailed> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
         Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()),
        );
      },
          child: Scaffold(
        body: Column(
          
          children: <Widget>[
            Expanded(
          flex: 8,
                child: Column(
            children: <Widget>[
              Container(margin: EdgeInsets.only(top:20),child: Image.asset("assets/fail.png")),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Order failed",
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
                    "Oops something went wrong, please view your orders and take another try",
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
                                  "View Orders",
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
                          
                        }),
                  ),
                )
          ],
        )    
      ),
    );
  }
}
