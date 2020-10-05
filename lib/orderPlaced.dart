import 'package:flutter/material.dart';
import 'package:guardini/homescreen.dart';
import 'package:guardini/orders.dart';
import 'package:hexcolor/hexcolor.dart';

import 'orderTracking.dart';

class OrderPlaced extends StatelessWidget {
  const OrderPlaced({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: (){
         Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()),
        );
      
      },
          child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Hooray!',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          backgroundColor: Hexcolor('#219251'),
        ),
        body: Container(
          height: size.height,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/orderPlaced.png'),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 40),
                // width: size.width * 0.6,
                child: Column(
                  children: [
                    Text(
                      'Thank you for booking',
                      style: TextStyle(
                        color: Hexcolor('#252525'),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'our services!',
                      style: TextStyle(
                        color: Hexcolor('#252525'),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Text(
                      'Your booking details have been',
                      style: TextStyle(
                        color: Hexcolor('#595959'),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      ' successfully shared with the vendor.',
                      style: TextStyle(
                        color: Hexcolor('#595959'),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Orders()),
                    );
                  },
                  child: Container(
                    width: size.width * 0.6,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 194, 51, 0.4),
                      border: Border.all(
                        width: 0.5,
                        color: Hexcolor('#FFC233'),
                      ),
                    ),
                    child: Text(
                      'Check status of booking',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Hexcolor('#252525'),),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
