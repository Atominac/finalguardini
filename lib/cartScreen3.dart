import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guardini/enteraddress.dart';
import 'package:guardini/paymenttype.dart';
import 'package:guardini/promos.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import 'ordersummary.dart';

class Cart extends StatefulWidget {
  var order;
  var selecteditems;
  var selectedindex;
  var totalPrice;
  var totalItems;

  Cart(
    this.selecteditems,
    this.selectedindex,
    this.order,
    this.totalPrice,
    this.totalItems,
  );
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  var orderdetails;
  var items;
  var states = ["New Delhi", "Uttar Pradesh", "Haryana"];
  var currentitem = "Select City";
  var address;
  // var totalPrice = 0;
  // var totalItems = 0;
  var specialservicename;
  var specialserviceprice;
  var specialserviceselected = "Select Addon service";
  List<dynamic> special;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getspecialservices();
    orderdetails = widget.order;
    items = orderdetails["items"];
    print("hellooooooooooooooooooooooooo");
    print(widget.selecteditems);
    print("byeeeeeeeeee");
    print(widget.selectedindex);
    var tax = 0.0;
    var totalammount = orderdetails["price"];
    deliveryprice = 50;
    tax = ((18 / 100) * totalammount);
    print(orderdetails["price"] + tax.round() + deliveryprice);
    orderdetails["deliveryprice"] = deliveryprice;
    orderdetails["deliverytype"] = "1";
    orderdetails["tax"] = tax.round();
    // return;
    orderdetails["totalprice"] =
        orderdetails["price"] + tax.round() + deliveryprice;
    setState(() {});

    return;
    // print("hey");
    // print(items);
  }

  var deliveryprice = 1;

  int _radioValue = 0;
  int _result = 0;
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _result = 1;

          deliveryprice = 50;
          var totalamount = 0;
          var tax = 0.0;
          totalamount = orderdetails["price"];
          tax = ((18 / 100) * totalamount);
          orderdetails["deliverytype"] = "1";
          orderdetails["tax"] = tax.round();
          orderdetails["deliveryprice"] = deliveryprice;
          orderdetails["totalprice"] =
              orderdetails["price"] + tax.round() + deliveryprice;

          // orderdetails["deliveryprice"] = deliveryprice;
          // orderdetails["deliverytype"] = "1";
          // // return;
          // orderdetails["totalprice"]=orderdetails["price"]+tax.round()+deliveryprice;

          break;
        case 1:
          _result = 2;

          deliveryprice = 100;
          var totalamount = 0;
          var tax = 0.0;
          totalamount = orderdetails["price"];
          tax = ((18 / 100) * totalamount);
          orderdetails["deliverytype"] = "1";
          orderdetails["deliveryprice"] = deliveryprice;
          orderdetails["tax"] = tax.round();
          orderdetails["totalprice"] =
              orderdetails["price"] + tax.round() + deliveryprice;
          break;
        case 2:
          _result = 3;

          deliveryprice = 0;
          var totalamount = 0;
          var tax = 0.0;
          totalamount = orderdetails["price"];
          tax = ((18 / 100) * totalamount);
          orderdetails["deliverytype"] = "1";
          orderdetails["deliveryprice"] = deliveryprice;
          orderdetails["tax"] = tax.round();
          orderdetails["totalprice"] =
              orderdetails["price"] + tax.round() + deliveryprice;

          break;
      }
      setState(() {});
      return;
    });
  }

  getspecialservices() async {
    final String url =
        "http://34.93.1.41/guardini/public/listing.php/orders/specialservice";
    var response = await http.get(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
    );
    ////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    // print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      setState(() {
        special = jsondecoded["data"];
      });
      // print(special);
    } else {
      showsnack("Some error has ouccered");
    }
  }

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  var date, time;
  var formatter = new DateFormat("dd-MMM-yy");
  var checktime;
  Future<Null> _selectdate(BuildContext context) async {
    //   DateTime now = DateTime.now();
    //   String formattedTime = DateFormat.Hms();
    //   print(formattedTime);
    //  var ghgh= DateTime.parse(formattedTime).difference(DateTime.parse("06:0000")).inHours;
    var todaydate = DateTime.now();
    // print(todaydate.toString());
    var limitstring = todaydate.toString().substring(0, 10) + " 18:00:00";
    // print(limitstring.toString());
    var ghgh = DateTime.parse(limitstring).difference(DateTime.now()).inMinutes;
    // print(ghgh);
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate:
          ghgh < 0 ? DateTime.now().add(new Duration(days: 1)) : DateTime.now(),
      lastDate: DateTime(2050),
      firstDate:
          ghgh < 0 ? DateTime.now().add(new Duration(days: 1)) : DateTime.now(),
    );

    if (picked != null) {
      // print("date: ${_date.toString()}");
      setState(() {
        _date = picked;
        date = _date;
        // print("date: ${date.toString()}");
      });
    }
    checktime = date.toString().substring(0, 10) + " 18:00:00";
    // _selecttime(context);
    Navigator.pop(context);
    datetime();
  }

  Future<Null> _selecttime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _time);
    if (picked != null && picked != _time) {
      // print("date: ${_date.toString()}");
      setState(() {
        _time = picked;
        time = _time.hour.toString() + ":" + _time.minute.toString();
      });
      // print(time);
    }
  }

  void deliveryoption() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            'Please select the type of Delivery',
            style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          content: Container(
            margin: EdgeInsets.only(top: 20),
            child: SizedBox(
              height: 350,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromRGBO(253, 186, 37, 1)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Self Pickup",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          width: 50,
                          child: RaisedButton(
                            onPressed: () {
                              // itemcount(index, action, 1);
                              orderdetails["deliverytype"] = "0";
                              orderdetails["deliveryprice"] = 0;
                              var totalprice = orderdetails["deliveryprice"] +
                                  orderdetails["price"];
                              orderdetails["totalprice"] = totalprice;
                              setState(() {
                                // print(orderdetails);
                              });
                              Navigator.of(context).pop();
                            },
                            color: Color.fromRGBO(38, 179, 163, 1),
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              "+ add",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromRGBO(253, 186, 37, 1)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Normal",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹ " + "50",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          width: 50,
                          child: RaisedButton(
                            onPressed: () {
                              // itemcount(index, action, 1);
                              orderdetails["deliverytype"] = "1";
                              orderdetails["deliveryprice"] = 50;
                              var totalprice = orderdetails["deliveryprice"] +
                                  orderdetails["price"];
                              orderdetails["totalprice"] = totalprice;
                              setState(() {
                                // print(orderdetails);
                              });
                              Navigator.of(context).pop();
                            },
                            color: Color.fromRGBO(38, 179, 163, 1),
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              "+ add",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromRGBO(253, 186, 37, 1)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Express",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹ " + "100",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          width: 50,
                          child: RaisedButton(
                            onPressed: () {
                              // itemcount(index, action, 2);
                              orderdetails["deliverytype"] = "2";
                              orderdetails["deliveryprice"] = 100;
                              var totalprice = orderdetails["deliveryprice"] +
                                  orderdetails["price"];
                              orderdetails["totalprice"] = totalprice;
                              setState(() {
                                // print(orderdetails);
                              });
                              Navigator.pop(context);
                            },
                            color: Color.fromRGBO(38, 179, 163, 1),
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              "+ add",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
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

  void datetime() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            'Please select time of pickup',
            style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          content: Container(
            margin: EdgeInsets.only(top: 40),
            child: SizedBox(
              height: 350,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromRGBO(253, 186, 37, 1)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              date == null
                                  ? "Select date"
                                  : formatter.format(date).toString(),
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          width: 60,
                          child: RaisedButton(
                            onPressed: () {
                              // itemcount(index, action, 1);
                              _selectdate(context);
                            },
                            color: Color.fromRGBO(38, 179, 163, 1),
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              "Select",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromRGBO(253, 186, 37, 1)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              time == null ? "Select time" : time.toString(),
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          width: 60,
                          child: RaisedButton(
                            onPressed: () {
                              // itemcount(index, action, 1);
                              Navigator.pop(context);
                              if (date == null) {
                                // _selectdate(context);
                                showsnack("Please select date");
                              } else {
                                timeslot();
                              }
                            },
                            color: Color.fromRGBO(38, 179, 163, 1),
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              "Select",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Continue"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void timeslot() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            'Please select a time slot',
            style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: 200,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      DateTime.parse(date.toString().substring(0, 10) +
                                      " 09:00:00")
                                  .difference(DateTime.now())
                                  .inMinutes <=
                              0
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                this.time = "9am-10am";
                                // print(time);
                                setState(() {});
                                Navigator.pop(context);
                                datetime();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromRGBO(38, 179, 163, 1)),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "9am-10am",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                      DateTime.parse(date.toString().substring(0, 10) +
                                      " 10:00:00")
                                  .difference(DateTime.now())
                                  .inMinutes <=
                              0
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                this.time = "10am-12pm";
                                // print(time);
                                setState(() {});
                                Navigator.pop(context);
                                datetime();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromRGBO(38, 179, 163, 1)),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "10am-12pm",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    DateTime.parse(date.toString().substring(0, 10) +
                                    " 12:00:00")
                                .difference(DateTime.now())
                                .inMinutes <=
                            0
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              this.time = "12pm-2pm";
                              // print(time);
                              setState(() {});
                              Navigator.pop(context);
                              datetime();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(38, 179, 163, 1)),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "12pm-2pm",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                    DateTime.parse(date.toString().substring(0, 10) +
                                    " 14:00:00")
                                .difference(DateTime.now())
                                .inMinutes <=
                            0
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              this.time = "2pm-4pm";
                              // print(time);
                              setState(() {});
                              Navigator.pop(context);
                              datetime();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(38, 179, 163, 1)),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "2pm-4pm",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                  ],
                ),
                Row(
                  children: [
                    DateTime.parse(date.toString().substring(0, 10) +
                                    " 16:00:00")
                                .difference(DateTime.now())
                                .inMinutes <=
                            0
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              this.time = "4pm-6pm";
                              // print(time);
                              setState(() {});
                              Navigator.pop(context);
                              datetime();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(38, 179, 163, 1)),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "4pm-6pm",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                    DateTime.parse(date.toString().substring(0, 10) +
                                    " 18:00:00")
                                .difference(DateTime.now())
                                .inMinutes <=
                            0
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              this.time = "6pm-7pm";
                              // print(time);
                              setState(() {});
                              Navigator.pop(context);
                              datetime();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(38, 179, 163, 1)),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "6pm-7pm",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
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
              child: new Text("Continue"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  final TextEditingController t1 = new TextEditingController(text: "");
  // final TextEditingController t2 = new TextEditingController(text: "");

  void remarks() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            'Please select addon service or add remarks if any',
            style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Container(
              child: SizedBox(
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color.fromRGBO(253, 186, 37, 1)),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Text(
                            "Addon service",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            child: DropdownButton<String>(
                              items: special.map((var listitem) {
                                return DropdownMenuItem<String>(
                                  value: jsonEncode(listitem),
                                  child: Text(
                                    listitem["name"] +
                                        " Rs " +
                                        listitem["price"],
                                    style: TextStyle(
                                        fontSize: (4 / 100) *
                                            MediaQuery.of(context).size.width),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String selected) {
                                setState(() {
                                  var temp = jsonDecode(selected);
                                  this.specialservicename = temp["name"];
                                  this.specialserviceprice = temp["price"];
                                  this.specialserviceselected =
                                      specialservicename;
                                  Navigator.pop(context);
                                  remarks();
                                });
                              },
                              hint: Text(specialserviceselected),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                        controller: t1,
                        inputFormatters: [
                          new WhitelistingTextInputFormatter(
                              RegExp("[a-zA-Z0-9 ]")),
                        ],
                        decoration: new InputDecoration(
                          hintText: "Write remarks, if any",
                        )),
                    // TextField(
                    //     controller: t2,
                    //     inputFormatters: [
                    //       new WhitelistingTextInputFormatter(
                    //           RegExp("[a-zA-Z0-9 ]")),
                    //     ],
                    //     decoration: new InputDecoration(
                    //       hintText: "GSTIN (optional)",
                    //     )),
                  ],
                ),
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
              child: new Text("Continue"),
              onPressed: () {
                creteorder();
              },
            ),
          ],
        );
      },
    );
  }

  void creteorder() {
    setState(() {
      print(orderdetails);
    });

    return;
    // orderdetails["address"] = address;
    // orderdetails["pickuptime"] =
    //     date.toString().substring(0, 10) + " " + time.toString();
    // if (specialservicename == null) {
    //   orderdetails["specialservice"] = "";
    //   orderdetails["specialprice"] = "0";
    // } else {
    //   orderdetails["specialservice"] = specialservicename;
    //   orderdetails["specialprice"] = specialserviceprice;
    //   orderdetails["totalprice"] = orderdetails["price"] +
    //       orderdetails["deliveryprice"] +
    //       int.parse(specialserviceprice);
    // }
    orderdetails["remarks"] = t1.text;
    orderdetails["gst"] = "";
    // print(orderdetails);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentType(orderdetails)),
    );
  }

  showsnack(String message) {
    ////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scafoldkey.currentState.showSnackBar(snackBar);
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

  calculateEachTotal(sel) {
    int c1 = 0, c2 = 0;
    int regp, delp;
    int sum = 0;
    for (int j = 0; j < sel["paymenttype"].length; j++) {
      if (sel["paymenttype"][j] == 0) {
        c1++;
      } else
        c2++;
    }
    regp = c1 * int.parse(sel["regularprice"]);
    delp = c2 * int.parse(sel["delicateprice"]);
    sum = regp + delp;
    // totalPrice = totalPrice + sum;
    // totalItems = totalItems + c1 + c2;
    return sum;
  }

  // checkIfEmpty() {
  //   int flag = 0;
  //   for (var i = 0;
  //       i < widget.selectedindex.length;
  //       i++) {
  //     if (widget.selecteditems[widget.selectedindex]["count"] == 0) {
  //       flag = 1;
  //     } else
  //       flag = 0;
  //   }
  //   return flag;

  // }

  // calculateTotal(widget.selecteditems[0]);

  List<String> gridImagess = [
    'assets/accessories.png',
    'assets/lehenga.png',
    'assets/outfits.png',
    'assets/shirt.png',
    'assets/trousers.png',
    'assets/upholestry.png',
  ];
  List<String> itemm = [
    'Accessories',
    'Lehenga',
    'Outfits',
    'Shirt',
    'Trousers',
    'Upholestry',
  ];
  var discounttemp = "0";

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scafoldkey,
      appBar: AppBar(
        title: Text("Your Basket"),
        backgroundColor: Hexcolor('#219251'),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     // georderdetails();
      //     if (address == null) {
      //       showsnack("Please enter address");
      //     } else if (date == null || time == null) {
      //       datetime();
      //     } else if (orderdetails["deliverytype"] == null) {
      //       deliveryoption();
      //     } else {
      //       remarks();
      //     }
      //   },
      //   label: Text("Next"),
      //   icon: Icon(Icons.arrow_forward),
      //   backgroundColor: Color.fromRGBO(38, 179, 163, 1),
      // ),
      backgroundColor: Hexcolor('#EFE9E0'),
      body: Stack(
        children: [
          Container(
            height: 600,
            child: ListView(
              children: <Widget>[
                Container(
                  height: size.height * 0.55,
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.only(bottom: 5),
                  color: Colors.white,
                  // child: items.length == 0
                  // ? Center(
                  //     child: Container(
                  //       margin: EdgeInsets.all(10),
                  //       child: Text(
                  //         "No items selected. No worries our pickup guy will help you creating the order at the time of pickup ",
                  //         overflow: TextOverflow.fade,
                  //         maxLines: 5,
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //             fontSize: 15,
                  //             color: Colors.black54,
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //   )
                  // :
                  child: ListView.builder(
                    itemCount: widget.selectedindex.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Colors.white,
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                color: Hexcolor('#EFE9E0'),
                                width: size.width * 0.2,
                                height: size.height * .11,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    widget.selecteditems[index]["imageurl"],
                                    scale: 1.5,
                                  ),
                                ),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        widget.selecteditems[widget
                                            .selectedindex[index]]["name"],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 4),
                                      width: size.width * .42,
                                      child: Text(
                                        'Regular Wash (${calculateRegular(widget.selecteditems[widget.selectedindex[index]])}), Premium Wash (${calculatePremium(widget.selecteditems[widget.selectedindex[index]])})',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Hexcolor('#595959'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Text(
                                  "₹ " +
                                      calculateEachTotal(widget.selecteditems[
                                              widget.selectedindex[index]])
                                          .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  width: size.width,
                  color: Colors.white,
                  // height: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                        child: Text(
                          'DELIVERY DETAILS',
                          style: TextStyle(),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Radio(
                                value: 0,
                                groupValue: _radioValue,
                                onChanged: _handleRadioValueChange,
                                toggleable: false,
                              ),
                              title: Text(
                                'Standard',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Hexcolor('#00B6BC'),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                '(within 7 days)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Hexcolor('#00B6BC'),
                                ),
                              ),
                              trailing: Text(
                                '₹ 50',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Hexcolor('#00B6BC'),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: Radio(
                                value: 1,
                                groupValue: _radioValue,
                                onChanged: _handleRadioValueChange,
                                toggleable: true,
                              ),
                              title: Text(
                                'Express',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                '(within 2 days)',
                                style: TextStyle(fontSize: 12),
                              ),
                              trailing: Text(
                                '₹ 100',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            ListTile(
                              leading: Radio(
                                value: 2,
                                groupValue: _radioValue,
                                onChanged: _handleRadioValueChange,
                              ),
                              title: Text(
                                'Self Pickup from Outlet',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              // subtitle: Text('(within 7 days)'),
                              trailing: Text(
                                '₹ 0',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var offer;
                    var totalammount = orderdetails["price"];
                    var discount;
                    var tax;

                    if (orderdetails["items"].length == 0) {
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
                        totalammount = orderdetails["price"];
                        print(totalammount);
                        // print("ss" + orderdetails["specialprice"]);
                        // totalammount += int.parse(orderdetails["specialprice"]);
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
                          orderdetails["offertype"] = offer["type"];
                        }
                        if (offer["type"] == "1") {
                          print("value");
                          discount = int.parse(offer["value"]);
                          if (discount > int.parse(offer["max"])) {
                            discount = int.parse(offer["max"]);
                          }
                          totalammount = totalammount - discount;
                          orderdetails["offertype"] = offer["type"];
                        }
                        tax = ((18 / 100) * totalammount);
                        totalammount = totalammount + tax.round();
                        if (totalammount < 0) {
                          totalammount = 0;
                        }
                        totalammount += orderdetails["deliveryprice"];
                        orderdetails["offervalue"] = offer["value"];
                        print(totalammount);
                        orderdetails["totalprice"] = totalammount;
                        discounttemp = discount.toString();
                        setState(() {});
                      }
                      showsnack("Promo Applied");
                    }
                  },
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        'APPLY PROMO CODE',
                        style: TextStyle(
                          fontSize: 14,
                          color: Hexcolor('#00B6BC'),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: Hexcolor('#00B6BC'),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                        child: Text(
                          'BILL DETAILS',
                          style: TextStyle(),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cart Total',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '₹ ${orderdetails["price"]}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Promo Code',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '₹ ${discounttemp}',
                              style: TextStyle(
                                color: Hexcolor('#72DF97'),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery Charges',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '₹ ${orderdetails["deliveryprice"]}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Taxes',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '₹ ${orderdetails["tax"]}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Price',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '₹ ${orderdetails["totalprice"]}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                        child: Text(
                          'Note: The total price is only an estimate on the basis of the type of wash chosen and may change on close inspection on the material of the item.',
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 80),
                  color: Colors.white,
                  width: size.width,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(8, 8, 24, 8),
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(171, 237, 230, 0.4),
                      border: Border.all(
                        color: Color.fromRGBO(0, 182, 188, 0.4),
                      ),
                    ),
                    child: Text(
                      "Payment is only processed either on the time of pickup or the the time of delivery. Online payment and Cash on Delivery, both are accepted.",
                      style: TextStyle(
                          fontSize: 12,
                          color: Hexcolor('#00B6BC'),
                          height: 1.5),
                    ),
                  ),
                ), // Positioned(
                //   child: Container(
                //     padding: EdgeInsets.all(10),
                //     child: Column(
                //       children: <Widget>[
                //         Row(
                //           children: <Widget>[
                //             Text(
                //               "₹ " +
                //                   orderdetails["price"].toString() +
                //                   " (" +
                //                   orderdetails["quantity"].toString() +
                //                   " item(s) )",
                //               style: TextStyle(
                //                   fontSize: subheading,
                //                   color: Colors.black87,
                //                   fontWeight: FontWeight.bold),
                //             )
                //           ],
                //         ),
                // Text(
                //   orderdetails["deliveryprice"] == null
                //       ? "₹ 0"
                //       : "₹ " +
                //           orderdetails["deliveryprice"]
                //               .toString(),
                //   style: TextStyle(
                //       fontSize: subheading,
                //       color: Colors.black87,
                //       fontWeight: FontWeight.bold),
                // ),
                // Row(
                //   children: <Widget>[
                //     Text(
                //       "Total price : ",
                //       style: TextStyle(
                //           fontSize: subheading,
                //           color: Colors.black54,
                //           fontWeight: FontWeight.bold),
                //     ),
                //     Text(
                //       "₹ " +
                //           orderdetails["totalprice"].toString() +
                //           " (GST extra as applicable)",
                //       style: TextStyle(
                //           fontSize: subheading,
                //           color: Colors.black87,
                //           fontWeight: FontWeight.bold),
                //     )
                //   ],
                // ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
                height: 55,
                padding: EdgeInsets.only(
                  left: 16,
                  top: 7,
                  right: 16,
                  bottom: 7,
                ),
                width: size.width,
                color: Hexcolor('#FFC233'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "₹ " + orderdetails["totalprice"].toString(),
                              // totalPrice.toString(),
                              // "₹ " + totalprice.toString(),
                              style: TextStyle(
                                color: Hexcolor('#252525'),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              ' (Estimated)',
                              style: TextStyle(
                                color: Hexcolor('#404040'),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        Text(
                          (widget.totalItems).toString() + ' pieces',
                          style: TextStyle(
                            color: Hexcolor('#404040'),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        print("dhgdi");
                        // creteorder();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderSummary(orderdetails)),
                        );

                        // checkIfEmpty();
                      },
                      child: Row(
                        children: [
                          Text(
                            "Fill Pickup Details",
                            // "₹ " + totalprice.toString(),
                            style: TextStyle(
                              color: Hexcolor('#252525'),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Hexcolor('#252525'),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
