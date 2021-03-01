import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Promos extends StatefulWidget {
  var totalamount;
  Promos(this.totalamount);
  @override
  _PromosState createState() => _PromosState(); 
}

class _PromosState extends State<Promos> {
  final TextEditingController t1 = new TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchpromos();
  }

  var promos;
  fetchpromos() async {
    final String url =
        "http://34.93.1.41/guardini/public/offers.php/offers/promos";
    var response = await http.get(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
    );
    ////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      setState(() {
        promos = jsondecoded["data"];
      });
    } else if (jsondecoded['message'] == "no_promos_found") {
      promos=[];
      setState(() {
      });
      showsnack("No promos available");
    } else {
      showsnack("Some error has ouccered");
    }
  }

  checkeligible(promoid) async {
    _showdialogue();
    print(promoid);
    final user = await SharedPreferences.getInstance();

    final String url =
        "http://34.93.1.41/guardini/public/orders.php/promo/checkeligible";
    var response = await http.post(
        //encode url
        Uri.encodeFull(url),
        headers: {"accept": "application/json"},
        body: {"masterhash": user.getString("masterhash"), "promoid": promoid});
    ////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      Navigator.pop(context);
      return 1;
    } else if (jsondecoded['message'] == "already_used") {
      Navigator.pop(context);
      return 0;
    } else {
      Navigator.pop(context);
      showsnack("Some error has ouccered");
    }
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

  showsnack(String message) {
    //////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scafoldkey.currentState.showSnackBar(snackBar);
  }

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    return Scaffold(
      backgroundColor: Hexcolor('#EFE9E0'),
      key: _scafoldkey,
      appBar: AppBar(
        title: Text("Apply Promo Code"),
        backgroundColor: Hexcolor('#219251'),
      ),
      body: Container(
        child: promos == null
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            :promos.isEmpty?Center(child: Container(child: Text("No Promos"),)) :Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   color: Colors.white,
                  //   padding: EdgeInsets.all(16),
                  //   margin: EdgeInsets.only(top: 8, bottom: 8),
                  //   child: new Theme(
                  //     data: new ThemeData(
                  //       primaryColor: Colors.redAccent,
                  //       primaryColorDark: Colors.red,
                  //     ),
                  //     child: TextField(
                  //       style: TextStyle(fontSize: 14),
                  //       controller: t1,
                  //       decoration: InputDecoration(
                  //           contentPadding: const EdgeInsets.symmetric(
                  //               vertical: 2, horizontal: 10),
                  //           fillColor: Colors.white,
                  //           border: OutlineInputBorder(
                  //             borderSide: BorderSide(color: Colors.red[100]),
                  //           ),
                  //           focusedBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(
                  //               color: Hexcolor('#00B6BC'),
                  //             ),
                  //           ),
                  //           hintText: 'Enter Promo Code',
                  //           hintStyle: TextStyle(
                  //             fontSize: 14,
                  //           ),
                  //           // suffixIcon: GestureDetector(
                  //           //   child: Text('APPLY'),
                  //           // ),
                  //           suffix: GestureDetector(
                  //             child: Text('APPLY'),
                  //           ),
                  //           suffixIconConstraints: BoxConstraints()),
                  //       keyboardType: TextInputType.text,

                  //       // textInputAction: TextInputAction.search,
                  //     ),
                  //   ),
                  // ),
                  Container(
                    color: Colors.white,
                    width: size.width,
                    padding: EdgeInsets.only(left: 16, top: 16),
                    child: Text(
                      'Available promo codes',
                      style: TextStyle(
                        color: Hexcolor('#595959'),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: promos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            var res = await checkeligible(promos[index]["id"]);
                            if (res == 1) {
                              if (widget.totalamount >
                                  int.parse(promos[index]["minlimit"])) {
                                var send = {
                                  "value": promos[index]["value"],
                                  "type": promos[index]["offertype"],
                                  "code": promos[index]["code"],
                                  "max": promos[index]["maxlimit"],
                                  "promoid": promos[index]["id"]
                                };
                                Navigator.pop(context, send);
                              } else {
                                showsnack(
                                    "only applicable on bill amount greater than Rs ${promos[index]["minlimit"]}");
                              }
                            } else {
                              showsnack("You have already used this promo");
                            }

                            // print(send);
                          },
                          child: Container(
                            padding: index == promos.length - 1
                                ? EdgeInsets.only(
                                    left: 16, right: 16, bottom: 16)
                                : EdgeInsets.only(left: 16, right: 16),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 24),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Hexcolor('#FFC233')
                                              .withOpacity(0.2),
                                          border: Border.all(
                                            color: Hexcolor('#FFC233')
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                        child: Text(
                                          promos[index]["name"],
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Hexcolor('#404040')),
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                ),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                   Container(
                                  margin: EdgeInsets.only(top: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          promos[index]["offertype"] == "0"
                                              ? promos[index]["value"] +
                                                  "% off" +
                                                  " Max " +
                                                  "Rs " +
                                                  promos[index]["maxlimit"]
                                              : "Rs " +
                                                  promos[index]["value"] +
                                                  " off" +
                                                  " Max " +
                                                  "Rs " +
                                                  promos[index]["maxlimit"],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Hexcolor('#252525'),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          promos[index]["code"],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Hexcolor('#595959'),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                        'APPLY',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Hexcolor('#00B6BC')),
                                      )
                                ],),
                               index == promos.length - 1
                                    ? Container()
                                    : Divider(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
