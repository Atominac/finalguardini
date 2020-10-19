import 'package:flutter/material.dart';
import 'package:guardini/addItems.dart';
import 'package:guardini/orderdetails.dart';
import 'package:guardini/outlets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homescreen.dart';
import 'package:intl/intl.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  var orders;

  @override
  void initState() {
    super.initState();
  start();
  }

start () async{
  await fetchoutlets();
    fetchorders();
  
}

var outlets;
fetchoutlets() async {
    final String url =
        "http://34.93.1.41/guardini/public/listing.php/outlets/list";
    var response = await http.get(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
    );
    //print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      setState(() {
        outlets = jsondecoded["data"];
      });
      print(outlets.length);
    } else {
      showsnack("Some error has ouccered");
    }
  }



  fetchorders() async {
    final user = await SharedPreferences.getInstance();

    final String url =
        "http://34.93.1.41/guardini/public/orders.php/user/orders";
    var response = await http.post(
        //encode url
        Uri.encodeFull(url),
        headers: {"accept": "application/json"},
        body: {"masterhash": user.getString("masterhash")});
    ////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
        orders = jsondecoded["data"];

        for (var i = 0; i < orders.length; i++) {

                  for (var j = 0; j < outlets.length; j++) {
                    if(orders[i]["outletid"]==outlets[j]["id"]){
                      orders[i]["outletname"]=outlets[j]["name"];
                    }
                  }

        }
      setState(() {
      });
    } else if (jsondecoded['message'] == "no_orders_found") {
      showsnack("No orders available");
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
  var formatter = new DateFormat("dd-MMM-yy");

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;

    return WillPopScope(
      onWillPop: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: Hexcolor('#F3EEE8'),
        key: _scafoldkey,
        appBar: AppBar(
          title: Text("Bookings"),
          backgroundColor: Hexcolor('#219251'),
        ),
        body: Container(
          child: orders == 0
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : orders == null
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : orders.length == 0
                      ? Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Image.asset(
                                  "assets/noorders.png",
                                  height: 230,
                                )),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "No existing orders",
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  )),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Place Order",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                color: Hexcolor("#FFC233"),
                                textTheme: ButtonTextTheme.normal,
                                height: 50.0,
                                minWidth: 600,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddItems(0)),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            fetchorders();
                          },
                          child: ListView.builder(
                              itemCount: orders.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderDetails(
                                              orders[index]["orderid"])),
                                    );
                                    fetchorders();
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.only(top: 5),
                                    padding: EdgeInsets.only(
                                        left: 16,
                                        top: 16,
                                        right: 16,
                                        bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Booking id:  #" +
                                                        orders[index]
                                                            ["orderid"],
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          Hexcolor('#595959'),
                                                    ),
                                                  ),
                                                  Padding(padding: EdgeInsets.only(top: 3)),
                                                  Text(
                                                    orders[index]
                                                                ["outletname"],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          Hexcolor('#595959'),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   formatter.format(
                                                  //       DateTime.parse(
                                                  //           orders[index]
                                                  //               ["datetime"])),
                                                  //   style: TextStyle(
                                                  //       fontSize:
                                                  //           (4 / 100) * width,
                                                  //       color: Colors.black54,
                                                  //       fontWeight:
                                                  //           FontWeight.bold),
                                                  // ),
                                                ],
                                              ),

                                              orders[index]["status"] == "1"
                                                  ? Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Hexcolor('#DF7272'),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2),
                                                      ),
                                                      child: Text(
                                                        "Cancelled",
                                                        style: TextStyle(
                                                          fontSize: 8,
                                                          color: Hexcolor(
                                                              '#4B1111'),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Hexcolor('#72D8DF'),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2),
                                                      ),
                                                      child: Text(
                                                        orders[index][
                                                                    "orderstatus"] ==
                                                                "0"
                                                            ? "Ongoing"
                                                            // "Order Placed"
                                                            : orders[index][
                                                                        "orderstatus"] ==
                                                                    "1"
                                                                ? "Order picked"
                                                                : orders[index][
                                                                            "orderstatus"] ==
                                                                        "2"
                                                                    ? "Reached Outlet"
                                                                    : orders[index]["orderstatus"] ==
                                                                            "3"
                                                                        ? "Processing"
                                                                        : orders[index]["orderstatus"] ==
                                                                                "4"
                                                                            ? "order Processed"
                                                                            : orders[index]["orderstatus"] == "5"
                                                                                ? "Out for delivery"
                                                                                : orders[index]["orderstatus"] == "6" ? "Ready for pickup" : "Delivered",
                                                        style: TextStyle(
                                                          fontSize: 8,
                                                          color: Hexcolor(
                                                              '#4B1111'),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                              // Text(
                                              //   "Rs  " +
                                              //       orders[index]["totalprice"],
                                              //   style: TextStyle(
                                              //       fontSize: (4 / 100) * width,
                                              //       color: Colors.black87,
                                              //       fontWeight: FontWeight.bold),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 16),
                                                child: Text(
                                                  "₹ " +
                                                      orders[index]
                                                          ["totalprice"],
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Hexcolor('#404040'),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  orders[index]["quantity"] ==
                                                          '1'
                                                      ? orders[index]
                                                              ["quantity"] +
                                                          " item"
                                                      : orders[index]
                                                              ["quantity"] +
                                                          " items",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Hexcolor('#737373'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Container(
                                        //         child: Text(
                                        //       "Pickup :",
                                        //       style: TextStyle(
                                        //           fontSize: (4 / 100) * width,
                                        //           color: Colors.black87,
                                        //           fontWeight: FontWeight.bold),
                                        //     )),
                                        //     Container(
                                        //         margin: EdgeInsets.all(5),
                                        //         child: Text(
                                        //           orders[index]["pickuptime"] ==
                                        //                   null
                                        //               ? "-"
                                        //               : formatter
                                        //                       .format(DateTime
                                        //                           .parse(orders[
                                        //                                       index]
                                        //                                   [
                                        //                                   "pickuptime"]
                                        //                               .substring(
                                        //                                   0,
                                        //                                   10)))
                                        //                       .toString() +
                                        //                   " " +
                                        //                   orders[index]
                                        //                           ["pickuptime"]
                                        //                       .substring(10),
                                        //           style: TextStyle(
                                        //               fontSize:
                                        //                   (4 / 100) * width,
                                        //               color: Colors.black54,
                                        //               fontWeight:
                                        //                   FontWeight.bold),
                                        //         )),
                                        //   ],
                                        // )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
        ),
      ),
    );
  }
}

// {id: 171, orderid: 1596874278642, userid: 22, datetime: 2020-08-25 15:19:29,
//  amount: 275, totalprice: 375, discounttype: null, discount: null, promoid: null,
//   quantity: 1, paymentmode: Net Banking, paymentstatus: 1, delieverycharges: 50,
//    tax: 49.5, gst: , invoiceid: null, invoiceurl: null,
//    delieveryaddress: x,,,Ghaziabad,New Delhi,21, distance: 14.0, ordertype: 0,
//     specialservice: , specialprice: 0, remarks: , pickuptime: 2020-08-08 6pm - 8pm,
//      pickedtime: null, deliveredtime: null, deliverytype: 1, trxnid: 309006330407,
//       outletid: 30, rating: null, review: null, cancelreason: null, orderstatus: 0,
//       deliveryboyid: 0, status: 0},
