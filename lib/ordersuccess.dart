import 'package:flutter/material.dart';
import 'package:guardini/homescreen.dart';
import 'package:guardini/orders.dart';

class Ordersuccess extends StatefulWidget {
  var orderid;
  Ordersuccess(this.orderid);
  @override
  _OrdersuccessState createState() => _OrdersuccessState();
}

class _OrdersuccessState extends State<Ordersuccess> {
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
          flex: 12,
                child: Column(
            children: <Widget>[
              Container(margin: EdgeInsets.only(top:20),child: Image.asset("assets/success.png",height: 230,)),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Order Placed",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Thanks for placing your order! Please wait while we schedule your pick-up !",
                    overflow: TextOverflow.fade,
                    maxLines: 5,
                                  textAlign: TextAlign.center,

                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Order id: "+"#"+widget.orderid,
                    overflow: TextOverflow.fade,
                    maxLines: 5,
                                  textAlign: TextAlign.center,

                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
            Expanded(flex:4,child: Column(
              
              children: [
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
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Orders()),
                        );
                        }),
                  ),
                   Container(
                     margin: EdgeInsets.only(left:10,right:10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      child: Material(
                        child: Ink(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color.fromRGBO(38, 179, 163, 1),
                              width: 2.0,
                            ),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                          ),
                          child: InkWell(
                            //This keeps the splash effect within the circle
                            //borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
                            // onTap: _messages,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Keep Exploring",
                                  style: TextStyle(
                                      color: Color.fromRGBO(38, 179, 163, 1),
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            )
                )
          ],
        )    
      ),
    );
  }
}
