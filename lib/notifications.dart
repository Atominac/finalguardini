import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchnotif();
  }

  var notif;
  fetchnotif() async {
    final user = await SharedPreferences.getInstance();

    final String url =
        "http://34.93.1.41/guardini/public/listing.php/user/notification";
    var response = await http.post(
        //encode url
        Uri.encodeFull(url),
        headers: {"accept": "application/json"},
        body: {"masterhash": user.getString("masterhash")});
    ////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      setState(() {
        notif = jsondecoded["data"];
      });
    } else if (jsondecoded['message'] == "no_notif_found") {
      showsnack("No notif available");
    } else {
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
  var formatter = new DateFormat("dd-MMM-yy hh:mm");

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scafoldkey,
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Color.fromRGBO(38, 179, 163, 1),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: notif == null
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : ListView.builder(
                itemCount: notif.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      // var res =await checkeligible(notif[index]["id"]);
                      // if (res == 1) {
                      //   if (widget.totalamount >
                      //       int.parse(notif[index]["minlimit"])) {
                      //     var send = {
                      //       "value": notif[index]["value"],
                      //       "type": notif[index]["offertype"],
                      //       "code": notif[index]["code"],
                      //       "max": notif[index]["maxlimit"],
                      //       "promoid": notif[index]["id"]
                      //     };
                      //     Navigator.pop(context, send);
                      //   } else {
                      //     showsnack(
                      //         "only applicable on bill amount greater than Rs ${notif[index]["minlimit"]}");
                      //   }
                      // } else {
                      //   showsnack("You have already used this promo");
                      // }

                      // print(send);
                    },
                    child: Container(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Color.fromRGBO(253, 186, 37, 1),
                        child: Card(
                          margin: EdgeInsetsDirectional.only(bottom: 5),
                          child: Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/notification.png",
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
                                                      notif[index]["title"],
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.all(5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        // Icon(
                                                        //   LineAwesomeIcons.star_o,
                                                        //   size: 15,
                                                        //   color: Color.fromRGBO(
                                                        //       28, 147, 85, 1),
                                                        // ),
                                                        Container(
                                                          width:
                                                              size.width - 155,
                                                          child: Text(
                                                            notif[index]
                                                                ["body"],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.all(3),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.watch_later,
                                                          size: 15,
                                                          color: Color.fromRGBO(
                                                              28, 147, 85, 1),
                                                        ),
                                                        Text(
                                                         formatter.format(DateTime.parse(notif[index]
                                                              ["datetime"])),
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .black87,
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
