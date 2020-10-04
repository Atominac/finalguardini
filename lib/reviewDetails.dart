import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guardini/enteraddress.dart';
import 'package:guardini/paymenttype.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'orderPlaced.dart';
import 'ordersummary.dart';

class ReviewDetails extends StatefulWidget {
  var order;
  // var selecteditems;
  // var selectedindex;
  // var totalPrice;
  // var totalItems;

  ReviewDetails(
    // this.selecteditems,
    // this.selectedindex,
    this.order,
    // this.totalPrice,
    // this.totalItems,
  );
  @override
  _ReviewDetailsState createState() => _ReviewDetailsState();
}

class _ReviewDetailsState extends State<ReviewDetails> {
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
  }



   getjson() async{
     webhook();
    final user = await SharedPreferences.getInstance();

    final String url =
        "http://34.93.1.41/guardini/public/orders.php/create";
    var response = await http.post(
        //encode url
        Uri.encodeFull(url),
        headers: {
          "accept": "application/json"
        },
        body: {"masterhash": user.getString("masterhash"),"data":jsonEncode(widget.order)},

);
   
        print(response.body);

   
   }


    webhook() async{
    final user = await SharedPreferences.getInstance();

    final String url =
        "https://webhook.site/fdf3da52-295f-4e9a-ad12-84da6edcf258";
    var response = await http.post(
        //encode url
        Uri.encodeFull(url),
        headers: {
          "accept": "application/json"
        },
        body: {"masterhash": user.getString("masterhash"),"data":jsonEncode(widget.order)},

);
   
        print(response.body);

   
   }


  int _radioValue = 0;
  double _result = 0.0;

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
    orderdetails["address"] = address;
    orderdetails["pickuptime"] =
        date.toString().substring(0, 10) + " " + time.toString();
    if (specialservicename == null) {
      orderdetails["specialservice"] = "";
      orderdetails["specialprice"] = "0";
    } else {
      orderdetails["specialservice"] = specialservicename;
      orderdetails["specialprice"] = specialserviceprice;
      orderdetails["totalprice"] = orderdetails["price"] +
          orderdetails["deliveryprice"] +
          int.parse(specialserviceprice);
    }
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

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scafoldkey,
      backgroundColor: Hexcolor('#EFE9E0'),
      body: Stack(
        children: [
          Container(
            height: size.height,
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 161),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                        child: Text(
                          'BILL DETAILS',
                          style: TextStyle(
                            fontSize: 14,
                            color: Hexcolor('#595959'),
                          ),
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
                              '₹ ${widget.order["price"].toString()}',
                              // '₹ ${widget.totalPrice}',
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
                              widget.order["discount"] == null
                                  ? '₹ 0'
                                  : '₹ ${widget.order["discount"].toString()}',
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
                              '₹ ${widget.order["deliveryprice"].toString()}',
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
                              '₹ ${widget.order["tax"].toString()}',
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
                              '₹ ${widget.order["totalprice"].toString()}',
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
                  margin: EdgeInsets.only(
                    top: 5,
                  ),
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
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 50),
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                            child: Text(
                              'PICKUP DETAILS',
                              style: TextStyle(
                                fontSize: 14,
                                color: Hexcolor('#595959'),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 16, bottom: 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2, right: 4, left: 14),
                                  child: Icon(
                                    Icons.location_on,
                                    size: 14,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Home',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Hexcolor('#404040'),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.7,
                                      child: Text(
                                        widget.order["address"],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Hexcolor('#404040'),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 16, bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2, right: 4, left: 14),
                                  child: Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.order["pickuptime"].toString().substring(0, widget.order["pickuptime"].toString().indexOf(" "))}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Hexcolor('#404040'),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${widget.order["pickuptime"].toString().substring(widget.order["pickuptime"].toString().indexOf(" ") + 1)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Hexcolor('#404040'),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      // GestureDetector(
                      //   child: Container(
                      //     padding: EdgeInsets.only(top: 20, right: 16),
                      //     child: Text('EDIT'),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: 180,
              width: size.width,
              padding: EdgeInsets.only(top: 20),
              color: Hexcolor('#219251'),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () => Navigator.of(context).pop(),
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16),
                          child: Text(
                            'Review Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16, left: 16),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.store_mall_directory,
                          color: Colors.white.withOpacity(0.7),
                          size: 14,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            'Choose Outlet',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 10, 16, 20),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: size.width * 0.7,
                            child: Text(
                              '24/B Tempo House California, USA',
                              // address == null ? disp : address,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              'Change',
                              style: TextStyle(
                                fontSize: 13,
                                color: Hexcolor('#ABEDE6'),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {},
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
                height: 55,
                padding: EdgeInsets.only(
                  left: 16,
                  top: 7,
                  right: 16,
                ),
                width: size.width,
                color: Hexcolor('#FFC233'),
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => OrderPlaced()),
                    // );
                    getjson();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Confirm Booking",
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
                )),
          ),
        ],
      ),
    );
  }
}
