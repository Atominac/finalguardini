import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'login.dart';
import 'onboarding4.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding3 extends StatelessWidget {
  const Onboarding3();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 40, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerRight,
                width: size.width,
                child: GestureDetector(
                 onTap: () async {
                    final user = await SharedPreferences.getInstance();
                    user.setString("first", "1");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    );
                  },
                  child: Text(
                    'SKIP',
                    style: TextStyle(
                      color: Hexcolor('00B6BC'),
                    ),
                  ),
                ),
              ),
              Container(
                height: size.longestSide * 0.35,
                margin: EdgeInsets.only(top: size.height * 0.1),
                child: Image.asset('assets/22.jpeg'),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.04),
                alignment: Alignment.center,
                width: size.width,
                child: Text(
                  'ADD GARMENTS FOR DRYCLEANING',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                alignment: Alignment.center,
                width: size.width * 0.8,
                child: Text(
                  'Carpets |  Suede Shoes |  Winter-wear care | ',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: size.width * 0.6,
                child: Text(
                  'Bags | Curtains |  ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Hexcolor('404040'),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      maxRadius: 4,
                      backgroundColor: Hexcolor('D1D1D1'),
                    ),
                    Padding(padding: EdgeInsets.only(left: 6)),
                    CircleAvatar(
                      maxRadius: 4,
                      backgroundColor: Hexcolor('FFC233'),
                    ),
                    Padding(padding: EdgeInsets.only(left: 6)),
                    CircleAvatar(
                      maxRadius: 4,
                      backgroundColor: Hexcolor('D1D1D1'),
                    ),
                    
                    Padding(padding: EdgeInsets.only(left: 6)),
                    CircleAvatar(
                      maxRadius: 4,
                      backgroundColor: Hexcolor('D1D1D1'),
                    ),
                    Padding(padding: EdgeInsets.only(left: 6)),
                    CircleAvatar(
                      maxRadius: 4,
                      backgroundColor: Hexcolor('D1D1D1'),
                    ),
                    Padding(padding: EdgeInsets.only(left: 6)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25, bottom: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Onboarding4(),
                      ),
                    );
                  },
                  // enableFeedback: true,
                  splashColor: Color.fromRGBO(255, 194, 51, 0.3),
                  highlightColor: Color.fromRGBO(255, 194, 51, 0.25),
                  child: Container(
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 194, 51, 0.4),
                        border: Border.all(
                          color: Hexcolor('#FFC233'),
                          width: 0.5,
                        )),
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      'Next',
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
      ),
    );
  }
}
