import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:guardini/invoiceviewer.dart';
import 'package:guardini/orderTracking.dart';
import 'package:guardini/payments.dart';
import 'package:guardini/paymentwebviiew.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class OrderDetails extends StatefulWidget {
  var orderid;
  OrderDetails(this.orderid);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var orders;
  var items;
  var reason = [
    "Wrong item selection",
    "Wrong date delivery selection",
    "others"
  ];
  var selected = "Please select";
  var contact;
  var outletname;

  final TextEditingController t1 = new TextEditingController(text: "");

  fetchorders() async {
    final user = await SharedPreferences.getInstance();

    final String url =
        "http://34.93.1.41/guardini/public/orders.php/user/orderdetail";
    var response = await http.post(
        //encode url
        Uri.encodeFull(url),
        headers: {
          "accept": "application/json"
        },
        body: {
          "masterhash": user.getString("masterhash"),
          "orderid": widget.orderid
        });
    ////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      setState(() {
        orders = jsondecoded["order"][0];
        items = jsondecoded["orderdetails"];

        if(orders["paymentstatus"]=="0"){
          finalstatus=0;
        }else{
          finalstatus=1;
        }
        print("items");
        print(items);
      });
      print(orders["datetime"]);
      var x =
          DateTime.now().difference(DateTime.parse(orders["datetime"])).inHours;

      print("het" + x.toString());
      contact = jsondecoded["outletcontact"];
      outletname=jsondecoded["outletname"];
    } else if (jsondecoded['message'] == "no_orders_found") {
      showsnack("No orders available");
    } else {
      showsnack("Some error has ouccered");
    }
  }




 verifyresponse() async {
   _showdialogue();
    final user = await SharedPreferences.getInstance();

    final String url =
        "http://guardini.conexo.in/paytm/checksum/verifyresponse.php";
    var response = await http.post(
        //encode url
        Uri.encodeFull(url),
        headers: {
          "accept": "application/json"
        },
        body: {
          "masterhash": user.getString("masterhash"),
          "orderid": widget.orderid
        });
    ////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      finalstatus=1;
      showsnack("Payment Success");

      Navigator.pop(context);
      setState(() {
      
      });
      } else {
      showsnack("Payment Failed");
      Navigator.pop(context);

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

  cancelorder() async {
    Navigator.pop(context);
    _showdialogue();
    print("heyyyyyyyy");
    var cancelreason = "";
    if (selected == "Please select") {
      cancelreason = t1.text;
    } else {
      cancelreason = selected;
    }
    final user = await SharedPreferences.getInstance();

    final String url =
        "http://34.93.1.41/guardini/public/orders.php/user/cancelorder";
    var response = await http.post(
        //encode url
        Uri.encodeFull(url),
        headers: {
          "accept": "application/json"
        },
        body: {
          "masterhash": user.getString("masterhash"),
          "orderid": widget.orderid,
          "cancelreason": cancelreason
        });
    ////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      Navigator.pop(context);
      setState(() {
        fetchorders();
      });
    } else {
      showsnack("Some error has ouccered");
    }
  }

  calculateRegular(var sel) {
    int c1 = 0;
    for (int j = 0; j < sel["paymenttype"].length; j++) {
      if (sel["paymenttype"][j] == 0) {
        c1++;
      }
    }
    return c1;
  }

  calculatePremium(var sel) {
    int c2 = 0;
    for (int j = 0; j < sel["paymenttype"].length; j++) {
      if (sel["paymenttype"][j] == 1) {
        c2++;
      }
    }
    return c2;
  }

  getlist() {
    // double height=200* double.parse(items.length);
    List<Widget> children = new List<Widget>();
    for (var i = 0; i < items.length; i++) {
      children.add(
        Container(
          color: Colors.white,
          // margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Hexcolor('#EFE9E0'),
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: MediaQuery.of(context).size.height * .1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        items[i]["imageurl"],
                        scale: 1.5,
                      ),
                    ),
                  ),
                  Container(
                    // width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            items[i]["itemname"],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 2),
                          child: Text(
                            "₹ " + items[i]["price"],
                            style: TextStyle(
                                fontSize: 12, color: Hexcolor('#595959')),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 3),
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text(
                             items[i]["servicename"],
                            // 'Regular Wash (${calculateRegular(items[i])}), Premium Wash (${calculatePremium(items[i])})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Hexcolor('#737373'),
                            ),
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.all(5),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: <Widget>[
                        //       Icon(
                        //         Icons.calendar_today,
                        //         size: 15,
                        //         color: Color.fromRGBO(38, 179, 163, 1),
                        //       ),
                        //       Text(
                        //         items[i]["pricecategory"] == 1
                        //             ? "  Regular Wash"
                        //             : "  Delicate Wash",
                        //         style: TextStyle(
                        //             fontSize: 15,
                        //             color: Colors.black54,
                        //             fontWeight: FontWeight.bold),
                        //       )
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              i == items.length - 1
                  ? Container()
                  : Divider(
                      height: 20,
                      thickness: 0.5,
                      color: Hexcolor('#D1D1D1'),
                    ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: children,
    );
  }

  void canceldialogue() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            'Reason of cancelation',
            style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          content: Container(
            child: SizedBox(
              height: 150,
              width: 150,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: DropdownButton<String>(
                      items: reason.map((String listitem) {
                        return DropdownMenuItem<String>(
                          value: listitem,
                          child: Text(listitem,
                              style: TextStyle(
                                fontSize: (4 / 100) *
                                    MediaQuery.of(context).size.width,
                              )),
                        );
                      }).toList(),
                      onChanged: (String selected) {
                        setState(() {
                          this.selected = selected;
                          Navigator.pop(context);
                          canceldialogue();
                        });
                      },
                      hint: Text(selected),
                    ),
                  ),
                  TextField(
                      inputFormatters: [
                        new WhitelistingTextInputFormatter(
                            RegExp("[a-zA-Z0-9 ]")),
                      ],
                      controller: t1,
                      decoration: new InputDecoration(
                        hintText: "Others, if any",
                      )),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Cancel order"),
              onPressed: () {
                cancelorder();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void amountdetails() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            'Amount details',
            style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          content: Container(
            child: SizedBox(
              height: 150,
              width: 150,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Price : ",
                        style: TextStyle(
                            fontSize:
                                (4 / 100) * MediaQuery.of(context).size.width,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Rs. " + orders["amount"].toString(),
                        style: TextStyle(
                            fontSize:
                                (4 / 100) * MediaQuery.of(context).size.width,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                       orders["safekeeping"]=="0" ? "Delivery Charges : ":"Safekeeping Charges",
                        style: TextStyle(
                            fontSize:
                                (4 / 100) * MediaQuery.of(context).size.width,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        orders["delieverycharges"] == null
                            ? "Rs 0"
                            : "Rs " + orders["delieverycharges"].toString(),
                        style: TextStyle(
                            fontSize:
                                (4 / 100) * MediaQuery.of(context).size.width,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Discount : ",
                        style: TextStyle(
                            fontSize:
                                (4 / 100) * MediaQuery.of(context).size.width,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                   orders["ppdstatus"]==0?   Text(
                        orders["discounttype"] == null
                            ? "-"
                            : orders["discounttype"] == "0"
                                ? "  " + orders["discount"] + "% off"
                                : "  Rs " + orders["discount"] + " off",
                        style: TextStyle(
                            fontSize:
                                (4 / 100) * MediaQuery.of(context).size.width,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ):Text(orders["ppddiscount"]+" %",
                        style: TextStyle(
                            fontSize:
                                (4 / 100) * MediaQuery.of(context).size.width,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Tax : ",
                        style: TextStyle(
                            fontSize:
                                (4 / 100) * MediaQuery.of(context).size.width,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "GST@18% " + orders["tax"],
                        style: TextStyle(
                            fontSize:
                                (4 / 100) * MediaQuery.of(context).size.width,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Total price : ",
                        style: TextStyle(
                            fontSize:
                                (4 / 100) * MediaQuery.of(context).size.width,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Rs " + orders["totalprice"].toString(),
                        style: TextStyle(
                            fontSize:
                                (4 / 100) * MediaQuery.of(context).size.width,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showsnack(String message) {
    //////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scafoldkey.currentState.showSnackBar(snackBar);
  }

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    fetchorders();
  }
  var finalstatus=0;

  var formatter = new DateFormat("dd-MMM-yy");

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    return Scaffold(
      backgroundColor: Hexcolor('#F3EEE8'),
      key: _scafoldkey,
      appBar: AppBar(
        title: Text("Booking Details"),
        backgroundColor: Hexcolor('#219251'),
        actions: [
          GestureDetector(
            onTap: () async {
              var url = "tel://" + contact.toString();
              print(url);
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
        //       Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => PaymentWebView("http://guardini.conexo.in/gatewaytest/NON_SEAMLESS_KIT/success.php",widget.orderid),
        //   ),
        // );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: Icon(Icons.call),
            ),
          ),
        ],
      ),
      body: orders == null
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListView(
              children: [
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 5),
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Booking id:  #" + orders["orderid"],
                            style: TextStyle(
                              fontSize: 12,
                              color: Hexcolor('#595959'),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 3)),
                          Text(
                            outletname,
                            style: TextStyle(
                              fontSize: 14,
                              color: Hexcolor('#404040'),
                              fontWeight: FontWeight.w500,
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

                      orders["status"] == "1"
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Hexcolor('#DF7272'),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                "Cancelled",
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Hexcolor('#4B1111'),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Hexcolor('#72D8DF'),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                orders["orderstatus"] == "0"
                                    ? "Ongoing"
                                    : orders["orderstatus"] == "1"
                                        ? "Order picked"
                                        : orders["orderstatus"] == "2"
                                            ? "Reached Outlet"
                                            : orders["orderstatus"] == "3"
                                                ? "Processing"
                                                : orders["orderstatus"] == "4"
                                                    ? "order Processed"
                                                    : orders["orderstatus"] ==
                                                            "5"
                                                        ? "Out for delivery"
                                                        : orders["orderstatus"] ==
                                                                "6"
                                                            ? "Ready for pickup"
                                                            : "Delivered",
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Hexcolor('#4B1111'),
                                  fontWeight: FontWeight.w500,
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

                orders["status"] == "1"
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          print("hey");
                          print(orders["status"] + orders["deliverytype"]);
                          // return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeliveryTimeline(
                                    orders["orderstatus"],
                                    orders["deliverytype"])),
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 24, bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "BOOKING STATUS",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Hexcolor('#595959'),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 3)),
                                  Row(
                                    children: [
                                      Text(
                                        orders["orderstatus"] == "0"
                                            ? "Booking details shared with vendor >"
                                            : orders["orderstatus"] == "1"
                                                ? "Order picked >"
                                                : orders["orderstatus"] == "2"
                                                    ? "Reached Outlet >"
                                                    : orders["orderstatus"] ==
                                                            "3"
                                                        ? "Processing >"
                                                        : orders["orderstatus"] ==
                                                                "4"
                                                            ? "order Processed >"
                                                            : orders["orderstatus"] ==
                                                                    "5"
                                                                ? "Out for delivery >"
                                                                : orders["orderstatus"] ==
                                                                        "6"
                                                                    ? "Ready for pickup >"
                                                                    : "Delivered >",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Hexcolor('#00B6BC'),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
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
                            ],
                          ),
                        ),
                      ),
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Text(
                              'ORDER DETAILS',
                              style: TextStyle(
                                color: Hexcolor('#595959'),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Text(
                              orders["quantity"] + " items",
                              style: TextStyle(
                                color: Hexcolor('#595959'),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: getlist(),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Text(
                          'PAYMENT DETAILS',
                          style: TextStyle(
                            color: Hexcolor('#595959'),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    orders["invoiceurl"]==null?  GestureDetector(
                                      onTap: () {
                                        amountdetails();
                                      },
                                      child: Text(
                                        'DETAILS',
                                        style: TextStyle(
                                          color: Hexcolor('#00B6BC'),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ):GestureDetector(
                                      onTap: () async{
                                        //hereeee
                                        var url = orders["invoiceurl"];
                                        print(url);
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                      child: Text(
                                        'INVOICE',
                                        style: TextStyle(
                                          color: Hexcolor('#00B6BC'),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                     ],),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  'Status',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Hexcolor('#737373'),
                                  ),
                                ),
                              ),
                               orders["paymentstatus"] == "2"?Text(
                                      'Failed',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Hexcolor('#595959'),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ):
                            finalstatus==0
                                  ? Text(
                                      'Pending',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Hexcolor('#595959'),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : Text(
                                      'Paid',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Hexcolor('#595959'),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ],
                          ),
                            Padding(padding: EdgeInsets.only(left: 30)),
                       
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  'Total Price',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Hexcolor('#737373'),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  '₹ ${orders["totalprice"]}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Hexcolor('#595959'),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(left: 30)),
                         orders["paymentstatus"] == "0" &&  orders["paymentmode"] == null
                                  ? Container()
                                  : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  'Mode of payment',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Hexcolor('#737373'),
                                  ),
                                ),
                              ),
                               Text(
                                      '${orders["paymentmode"]}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Hexcolor('#595959'),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                   (int.parse(orders["orderstatus"]) > 1 &&
                              orders["paymentstatus"] == "0" &&   orders["paymentmode"] == null) && finalstatus==0
                          ? Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: FlatButton(
                                      onPressed: () async{
                                  var ret=  await  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentScreen(orders),
                                      ),
                                    );

                                    print("yo bro chl gy ahai yeh");
                                  if(ret==1){

                                    verifyresponse();
                                  }else{
                                    fetchorders();
                                  }
                                      },
                                      child: Text("PAY"),
                                      textColor: Colors.white,
                                      color: Hexcolor("#FFC233"),
                                      minWidth: 80,
                                      height: 40,
                                    ))
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),

                Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Text(
                          'PICKUP DETAILS',
                          style: TextStyle(
                            color: Hexcolor('#595959'),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5, top: 3),
                            child: Icon(
                              Icons.location_on,
                              size: 14,
                              color: Hexcolor('#737373'),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Home',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Hexcolor('#737373'),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                width: size.width * 0.8,
                                child: Text(
                                  orders["delieveryaddress"] == null
                                      ? "-"
                                      : orders["delieveryaddress"],
                                  // overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Hexcolor('#404040'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5, top: 3),
                            child: Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Hexcolor('#737373'),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                orders["pickuptime"] == null
                                    ? "-"
                                    : formatter
                                        .format(DateTime.parse(
                                            orders["pickuptime"]
                                                .substring(0, 10)))
                                        .toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Hexcolor('#737373'),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                width: size.width * 0.7,
                                child: Text(
                                  orders["pickuptime"].substring(11),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Hexcolor('#404040'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  // margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     FlatButton(
                      //       child: const Text(
                      //         'INVOICE',
                      //         style: TextStyle(
                      //             color: Color.fromRGBO(
                      //                 38, 179, 163, 1)),
                      //       ),
                      //       onPressed: () async {
                      //         if (orders["invoiceurl"] == null) {
                      //           showsnack(
                      //               "Invoice not been generated yet");
                      //         } else {
                      //           // var url = orders["invoiceurl"];
                      //           // print(url);
                      //           // if (await canLaunch(url)) {
                      //           //   await launch(url);
                      //           // } else {
                      //           //   throw 'Could not launch $url';
                      //           // }

                      //           // #############################################################################################################################
                      //           // ######################################## changed code ############
                      //           // ###################################################
                      //           // Navigator.push(
                      //           //   context,
                      //           //   MaterialPageRoute(
                      //           //       builder: (context) =>
                      //           //           InvoiceViewer(orders[
                      //           //               "invoiceurl"])),
                      //           // );
                      //         }
                      //       },
                      //     ),
                      //     FlatButton(
                      //       child: const Text(
                      //         'AMOUNT DETAILS',
                      //         style: TextStyle(
                      //             color: Color.fromRGBO(
                      //                 38, 179, 163, 1)),
                      //       ),
                      //       onPressed: () {
                      //         amountdetails();
                      //       },
                      //     ),
                      //   ],
                      // )
                      Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.fromLTRB(16, 20, 16, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Text(
                                'DELIVERY DETAILS',
                                style: TextStyle(
                                  color: Hexcolor('#595959'),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 5, top: 3),
                                  child: Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Hexcolor('#737373'),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Home',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Hexcolor('#737373'),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.8,
                                      child: Text(
                                        orders["delieveryaddress"] == null
                                            ? "-"
                                            : orders["delieveryaddress"],
                                        // overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Hexcolor('#404040'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Container(
                //   child: Row(
                //     children: <Widget>[
                //       GestureDetector(
                //         onTap: () {
                //           // _selectdate(context);
                //           print("hey");
                //         },
                //         child: Card(
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10.0),
                //           ),
                //           color: Color.fromRGBO(253, 186, 37, 1),
                //           child: Card(
                //             margin:
                //                 EdgeInsetsDirectional.only(bottom: 5),
                //             child: Container(
                //               width:
                //                   (MediaQuery.of(context).size.width /
                //                           2) -
                //                       40,
                //               margin: EdgeInsets.all(10),
                //               child: Column(
                //                 children: <Widget>[
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment
                //                             .spaceBetween,
                //                     children: <Widget>[
                //                       Text(
                //                         "Mode",
                //                         style: TextStyle(
                //                             fontSize:
                //                                 (3.5 / 100) * width,
                //                             color: Colors.black87,
                //                             fontWeight:
                //                                 FontWeight.bold),
                //                       ),
                //                       Icon(Icons.keyboard_arrow_down)
                //                     ],
                //                   ),
                //                   Container(
                //                     child: Divider(),
                //                   ),
                //                   Container(
                //                     child: Text(
                //                       orders["paymentmode"] == "0"
                //                           ? "Cash on delivery"
                //                           : "Other",
                //                       style: TextStyle(
                //                           fontSize:
                //                               (3.75 / 100) * width,
                //                           color: Colors.black54,
                //                           fontWeight:
                //                               FontWeight.bold),
                //                     ),
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //       GestureDetector(
                //         onTap: () {},
                //         child: Card(
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10.0),
                //           ),
                //           color: Color.fromRGBO(253, 186, 37, 1),
                //           child: Card(
                //             margin:
                //                 EdgeInsetsDirectional.only(bottom: 5),
                //             child: Container(
                //               width:
                //                   (MediaQuery.of(context).size.width /
                //                           2) -
                //                       40,
                //               margin: EdgeInsets.all(10),
                //               child: Column(
                //                 children: <Widget>[
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment
                //                             .spaceBetween,
                //                     children: <Widget>[
                //                       Text(
                //                         "Status",
                //                         style: TextStyle(
                //                             fontSize:
                //                                 (3.5 / 100) * width,
                //                             color: Colors.black87,
                //                             fontWeight:
                //                                 FontWeight.bold),
                //                       ),
                //                       Icon(Icons.keyboard_arrow_down)
                //                     ],
                //                   ),
                //                   Container(
                //                     child: Divider(),
                //                   ),
                //                   Container(
                //                     child: Text(
                //                       orders["paymentstatus"] == "0"
                //                           ? "Pending"
                //                           : "Paid",
                //                       style: TextStyle(
                //                           fontSize:
                //                               (3.75 / 100) * width,
                //                           color: Colors.black54,
                //                           fontWeight:
                //                               FontWeight.bold),
                //                     ),
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Container(
                //   margin: EdgeInsets.all(10),
                //   child: Row(
                //     children: <Widget>[
                //       GestureDetector(
                //         onTap: () {
                //           // _selectdate(context);
                //           print("hey");
                //         },
                //         child: Card(
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10.0),
                //           ),
                //           color: Color.fromRGBO(253, 186, 37, 1),
                //           child: Card(
                //             margin: EdgeInsetsDirectional.only(bottom: 5),
                //             child: Container(
                //               width:
                //                   (MediaQuery.of(context).size.width / 2) - 40,
                //               margin: EdgeInsets.all(10),
                //               child: Column(
                //                 children: <Widget>[
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceBetween,
                //                     children: <Widget>[
                //                       Text(
                //                         "Special Service",
                //                         style: TextStyle(
                //                             fontSize: (3.5 / 100) * width,
                //                             color: Colors.black87,
                //                             fontWeight: FontWeight.bold),
                //                       ),
                //                       Icon(Icons.keyboard_arrow_down)
                //                     ],
                //                   ),
                //                   Container(
                //                     child: Divider(),
                //                   ),
                //                   Container(
                //                     child: Text(
                //                       orders["specialservice"] == null
                //                           ? "-"
                //                           : orders["specialservice"].length > 15
                //                               ? orders["specialservice"]
                //                                       .toString()
                //                                       .substring(0, 13) +
                //                                   "..."
                //                               : orders["specialservice"],
                //                       style: TextStyle(
                //                           fontSize: (3.75 / 100) * width,
                //                           color: Colors.black54,
                //                           fontWeight: FontWeight.bold),
                //                     ),
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //       GestureDetector(
                //         onTap: () {},
                //         child: Card(
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10.0),
                //           ),
                //           color: Color.fromRGBO(253, 186, 37, 1),
                //           child: Card(
                //             margin: EdgeInsetsDirectional.only(bottom: 5),
                //             child: Container(
                //               width:
                //                   (MediaQuery.of(context).size.width / 2) - 40,
                //               margin: EdgeInsets.all(10),
                //               child: Column(
                //                 children: <Widget>[
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceBetween,
                //                     children: <Widget>[
                //                       Text(
                //                         "Remarks",
                //                         style: TextStyle(
                //                             fontSize: (3.5 / 100) * width,
                //                             color: Colors.black87,
                //                             fontWeight: FontWeight.bold),
                //                       ),
                //                       Icon(Icons.keyboard_arrow_down)
                //                     ],
                //                   ),
                //                   Container(
                //                     child: Divider(),
                //                   ),
                //                   Container(
                //                     child: Text(
                //                       orders["remarks"] == null
                //                           ? "-"
                //                           : orders["remarks"].length > 15
                //                               ? orders["remarks"] + "..."
                //                               : orders["remarks"],
                //                       style: TextStyle(
                //                           fontSize: (3.75 / 100) * width,
                //                           color: Colors.black54,
                //                           fontWeight: FontWeight.bold),
                //                     ),
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                orders["status"] == "1"
                    ? Container()
                    : DateTime.now()
                                .difference(DateTime.parse(orders["datetime"]))
                                .inHours >
                            1
                ? Container(
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
                                  "Can't cancel order after one hour",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                        color: Colors.grey,
                        textTheme: ButtonTextTheme.normal,
                        height: 50.0,
                        minWidth: 600,
                        onPressed: () {}),
                  )
                : Container(
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
                                  "Cancel Orders",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                        color: Colors.red,
                        textTheme: ButtonTextTheme.normal,
                        height: 50.0,
                        minWidth: 600,
                        onPressed: () {
                          canceldialogue();
                        }),
                  ),
              ],
            ),
    );
  }
}
