import 'package:flutter/material.dart';
import 'package:guardini/failed.dart';
import 'package:guardini/ordersuccess.dart';
import 'package:guardini/promos.dart';
import 'package:guardini/terms.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentType extends StatefulWidget {
  var orderdetails;
  PaymentType(this.orderdetails);
  @override
  _PaymentTypeState createState() => _PaymentTypeState();
}

class _PaymentTypeState extends State<PaymentType> {
  showsnack(String message) {
    //////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scafoldkey.currentState.showSnackBar(snackBar);
  }

  var selectedtype;

  var offer;
  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();
  var order;
  var immutable;
  var totalammount;
  var tax;
  var discount;
  @override
  void initState() {
    super.initState();
    discount = 0;
    tax = 0;
    totalammount = 0;
    order = widget.orderdetails;
    print("object");
    print(order["totalprice"]);
    totalammount = order["price"];
    
    totalammount+=int.parse(order["specialprice"]);
    print("hey");
    tax = ((18 / 100) * totalammount);
    totalammount = totalammount + tax.round();
    totalammount+=order["deliveryprice"];
  }

  paymenttype(type) {
    if (type == "0") {
      selectedtype = "Cash on delivery";
      order["paymenttype"] = "0";
    } else {
      showsnack("Coming Soon...");
      order["paymenttype"] = "";
      selectedtype = null;
    }

    setState(() {});
    print(order);
  }

  placeorder() async {
    _showdialogue();
    final user = await SharedPreferences.getInstance();
    print(user.getString("masterhash"));
    final String url = "http://34.93.1.41/guardini/public/orders.php/create";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {
        "masterhash": user.getString("masterhash"),
        "data": json.encode(order)
      },
    );
    print(jsonEncode({
      "masterhash": user.getString("masterhash"),
      "data": json.encode(order)
    }));
    ////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(response.body);

    if (jsondecoded['message'] == "success") {
      setState(() {});
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Ordersuccess(jsondecoded['orderid'])),
      );
    } else if (jsondecoded['message'] == "error_creating_order_details") {
      showsnack("cant't create order please retry");
    } else if (jsondecoded['message'] == "error_in_hash") {
      showsnack("Session expired login again and retry");
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Orderfailed()),
      );
    }
  }

  Future<bool> confirm() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment type will be cash on delivery!!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text('Place Order'),
                onPressed: () {
                  placeorder();
                }),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;

    return Scaffold(
        key: _scafoldkey,
        appBar: AppBar(
          title: Text("Select payment type "),
          backgroundColor: Color.fromRGBO(38, 179, 163, 1),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            order["totalprice"] = totalammount;
            order["tax"] = tax;
            if (offer != null) {
              order["promoid"] = offer["promoid"];
            }
            print(order["totalprice"]);
            order["paymenttype"] = "0";
            confirm();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => Orderfailed()),
            // );
          },
          icon: Icon(Icons.arrow_forward),
          label: Text("Place Order"),
          backgroundColor: Color.fromRGBO(38, 179, 163, 1),
        ),
        body: ListView(
          children: [
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.orangeAccent),
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 40, right: 40),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Amount: ",
                                    style: TextStyle(
                                        fontSize: (5 / 100) *width,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "INR " + order["price"].toString(),
                                    style: TextStyle(
                                        fontSize:(5 / 100) *width,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Delivery Charges: ",
                                    style: TextStyle(
                                        fontSize: (5 / 100) *width,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    order["deliveryprice"] == null
                                        ? "INR 0"
                                        : "INR " +
                                            order["deliveryprice"].toString(),
                                    style: TextStyle(
                                        fontSize: (5 / 100) *width,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Special Service: ",
                                    style: TextStyle(
                                        fontSize: (5 / 100) *width,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    order["specialprice"] == null
                                        ? "INR 0"
                                        : "INR " +
                                            order["specialprice"].toString(),
                                    style: TextStyle(
                                        fontSize:(5 / 100) *width,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              discount == null || discount == 0
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Discount: ",
                                          style: TextStyle(
                                              fontSize: (5 / 100) *width,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          order["offertype"] == "0"
                                              ? "  " +
                                                  order["offervalue"] +
                                                  "% off " +
                                                  discount.toString()
                                              : "  INR " +
                                                  order["offervalue"] +
                                                  " off " +
                                                  discount.toString(),
                                          style: TextStyle(
                                              fontSize: (5 / 100) *width,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "GST @ 18%",
                                    style: TextStyle(
                                        fontSize: (5 / 100) *width,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    tax.toStringAsFixed(2).toString(),
                                    style: TextStyle(
                                        fontSize: (5 / 100) *width,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.white,
                                thickness: 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Estimate price: ",
                                    style: TextStyle(
                                        fontSize: (5 / 100) *width,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "INR " + totalammount.toString(),
                                    style: TextStyle(
                                        fontSize: (5 / 100) *width,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              Text(
                                "*Final amount may vary after Inspection of articles at outlet",
                                style: TextStyle(
                                    fontSize: (5 / 100) *width,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Terms()),
                                  );
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: '*By placing order you accept our ',
                                    style: TextStyle(
                                        fontSize: (5 / 100) *width,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'terms & conditions',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent)),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (order["items"].length == 0) {
                        showsnack("Please select items to add an offer");
                      } else {
                        offer = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Promos(totalammount)),
                        );
                        if (offer != null) {
                          totalammount = 0;
                          discount = 0;
                          totalammount = order["price"];
                          print(totalammount);
                          print("ss" + order["specialprice"]);
                          totalammount += int.parse(order["specialprice"]);
                          print(offer);
                          print(totalammount);
                          if (offer["type"] == "0") {
                            print("percent");
                            var value = int.parse(offer["value"]);
                            discount = (value / 100) * totalammount;
                            if (discount > int.parse(offer["max"])) {
                              discount = int.parse(offer["max"]);
                            }
                            totalammount = totalammount - discount;
                            order["offertype"] = offer["type"];
                          }
                          if (offer["type"] == "1") {
                            print("value");
                            discount = int.parse(offer["value"]);
                            if (discount > int.parse(offer["max"])) {
                              discount = int.parse(offer["max"]);
                            }
                            totalammount = totalammount - discount;
                            order["offertype"] = offer["type"];
                          }
                          tax = ((18 / 100) * totalammount);
                          totalammount = totalammount + tax.round();
                          if (totalammount < 0) {
                            totalammount = 0;
                          }
                          totalammount += order["deliveryprice"];
                          order["offervalue"] = offer["value"];
                          print(totalammount);

                          setState(() {});
                        }
                      }
                    },
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(LineAwesomeIcons.ticket),
                            title: Text('Add Promo'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
