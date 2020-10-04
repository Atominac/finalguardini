import 'package:flutter/material.dart';
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
      key: _scafoldkey,
      appBar: AppBar(
        title: Text("Select promo"),
        backgroundColor:Color.fromRGBO(38, 179, 163, 1),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: promos == null
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : ListView.builder(
                itemCount: promos.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async{
                      var res =await checkeligible(promos[index]["id"]);
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
                      child: Card(shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Color.fromRGBO(253, 186, 37, 1),
                        child: Card(
                          margin: EdgeInsetsDirectional.only(bottom: 5),
                          child: Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/sale.png",
                                        height: 50,
                                        width: 50,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.all(5),
                                                    child: Text(
                                                      promos[index]["name"],
                                                      style: TextStyle(
                                                          fontSize: (5/100)*width,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.all(5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: <Widget>[
                                                        Icon(
                                                          LineAwesomeIcons.star_o,
                                                          size: (4/100)*width,
                                                          color: Color.fromRGBO(
                                                              28, 147, 85, 1),
                                                        ),
                                                        Text(
                                                          "  " +
                                                              promos[index]
                                                                  ["code"],
                                                          style: TextStyle(
                                                              fontSize: (4/100)*width,
                                                              color:
                                                                  Colors.black54,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.all(3),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.watch_later,
                                                          size: (4/100)*width,
                                                          color: Color.fromRGBO(
                                                              28, 147, 85, 1),
                                                        ),
                                                        Text(
                                                          promos[index][
                                                                      "offertype"] ==
                                                                  "0"
                                                              ? "  " +
                                                                  promos[index]
                                                                      ["value"] +
                                                                  "% off" +
                                                                  " Max " +
                                                                  "Rs " +
                                                                  promos[index]
                                                                      ["maxlimit"]
                                                              : "  Rs " +
                                                                  promos[index]
                                                                      ["value"] +
                                                                  " off" +
                                                                  " Max " +
                                                                  "Rs " +
                                                                  promos[index][
                                                                      "maxlimit"],
                                                          style: TextStyle(
                                                              fontSize: (4/100)*width,
                                                              color:
                                                                  Colors.black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_forward_ios),
                                ],
                              )),
                        ),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
