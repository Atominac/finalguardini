import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guardini/enteraddress.dart';
import 'package:guardini/reviewDetails.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderSummary extends StatefulWidget {
  var order;
  OrderSummary(this.order);

  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  var orderdetails;
  var items;
  var states = ["New Delhi", "Uttar Pradesh", "Haryana"];
  var currentitem = "Select City";
  var address;

  var specialservicename;
  var specialserviceprice;
  var specialserviceselected = "Select Addon service";
  List<dynamic> special;

  // var disp;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdetails();
    getspecialservices();
    orderdetails = widget.order;
    items = orderdetails["items"];
    print("hey");
    print(items);
    date = DateTime.now();
    
  }
   var outletname;
  getdetails() async {
    final user = await SharedPreferences.getInstance();
    outletname = user.getString("outletname");

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
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      setState(() {
        special = jsondecoded["data"];
      });
      print(special);
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
    print(todaydate.toString());
    var limitstring = todaydate.toString().substring(0, 10) + " 18:00:00";
    print(limitstring.toString());
    var ghgh = DateTime.parse(limitstring).difference(DateTime.now()).inMinutes;
    print(ghgh);
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate:
          ghgh < 0 ? DateTime.now().add(new Duration(days: 1)) : DateTime.now(),
      lastDate: DateTime(2050),
      firstDate:
          ghgh < 0 ? DateTime.now().add(new Duration(days: 1)) : DateTime.now(),
    );

    if (picked != null) {
      print("date: ${_date.toString()}");
      setState(() {
        _date = picked;
        date = _date;
        print("date: ${date.toString()}");
        print("dddddddddddddddddd");
      });
    }
    checktime = date.toString().substring(0, 10) + " 18:00:00";
    // _selecttime(context);
    // Navigator.pop(context);
    // datetime();
  }

  Future<Null> _selecttime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _time);
    if (picked != null && picked != _time) {
      print("date: ${_date.toString()}");
      setState(() {
        _time = picked;
        time = _time.hour.toString() + ":" + _time.minute.toString();
      });
      print(time);
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
                                print(orderdetails);
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
                                print(orderdetails);
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
                                print(orderdetails);
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
                                print(time);
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
                                print(time);
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
                              print(time);
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
                              print(time);
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
                              print(time);
                              setState(() {});
                              // Navigator.pop(context);
                              // datetime();
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
                              print(time);
                              setState(() {});
                              // Navigator.pop(context);
                              // datetime();
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
            'Add remarks if any',
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
                    TextField(
                        controller: t1,
                        maxLines: 5,
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
                Navigator.pop(context);
                creteorder();
              },
            ),
          ],
        );
      },
    );
  }
var deliverytime;
  void creteorder() {
    orderdetails["address"] = address;
    orderdetails["pickuptime"] =
        date.toString().substring(0, 10) + " " + time.toString();
    if(deliverytime==null){
       orderdetails["deliverytime"]="";
    }else{
       orderdetails["deliverytime"]=deliverytime;

    }
    orderdetails["remarks"] = t1.text;
    orderdetails["gst"] = "";
    print("here it e is: "+orderdetails["deliverytime"]);
    print(orderdetails);
    // return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReviewDetails(orderdetails)),
    );
  }

  var weekday = ["","MON", "TUE", "WED", "THU", "FRI", "SAT","SUN"];
  var dateindex = 0;
  var datearr = [];

  printdates() {
//   var date1=DateTime.now();
//   print("date1"+date1.toString());
//  var date2=date1.add(Duration(days: 1));
//   print("date2"+date2.toString());
    // return;
    var jdate = DateTime.now();
    var todaydate = DateTime.now();
    print("date========"+todaydate.toString());
    var limitstring = todaydate.toString().substring(0, 10) + " 18:00:00";
    print(limitstring.toString());
    var ghgh = DateTime.parse(limitstring).difference(DateTime.now()).inMinutes;
    // ghgh < 0 ? DateTime.now().add(new Duration(days: 1)) : DateTime.now(),
    if (ghgh < 0) {
      jdate = jdate.add(Duration(days: 1));
    }
    //  return;
    List<Widget> children = new List<Widget>();
    for (var index = 0; index < 7; index++) {
      datearr.add(jdate);
      children.add(
        GestureDetector(
          onTap: () {
            print("INDEX:" + index.toString());
            dateindex = index;
            // print("hey");

            // date=jdate.year.toString()+"-"+jdate.month.toString()+"-"+jdate.day.toString()+" "+jdate.hour.toString()+":"+jdate.minute.toString()+":"+jdate.seconds.toString();
            date = datearr[index];
            // print("hey");

            // print(date);
            // print("hey");

            checktime = jdate.toString().substring(0, 10) + " 18:00:00";
            // print("chk="+checktime);
            // print("hey");
            // print("date"+date);
            //  print(date.toString().substring(0, 10));
            print("finaldate" + date.toString());
            setState(() {});
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.115,
            height: 57,
            // alignment: Alignment.center,
            decoration: BoxDecoration(
              color: dateindex == index ? Hexcolor('#00B6BC') : Colors.white,
              border: Border.all(color: Hexcolor('#00B6BC'), width: 0.7),

              // borderRadius: BorderRadius.circular(5.0),
            ),
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${jdate.day}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Hexcolor('#252525'),
                  ),
                ),
                Text(
                  '${weekday[jdate.weekday]}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Hexcolor('#252525'),
                  ),
                )
              ],
            ),
          ),
        ),
      );
      jdate = jdate.add(Duration(days: 1));
    }
    // print(datearr);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: children,
      ),
    );
// return children;
  }

  var slotselected = 0;
  var delslotselected = 0;

  showsnack(String message) {
    //////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scafoldkey.currentState.showSnackBar(snackBar);
  }

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var heading = (2.5 / 100) * height;
    var subheading = (2 / 100) * height;
    var i = 16;
    return SafeArea(
          child: Scaffold(
        key: _scafoldkey,
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
            ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 165),
                  padding: EdgeInsets.only(top: 18, left: 16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "Pickup Address and Date",
                          style: TextStyle(
                            fontSize: 16,
                            // color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.8,
                        child: Text(
                          'Our correspondent will arrive at this address on the specified date to pickup clothes',
                          style: TextStyle(
                            fontSize: 14,
                            color: Hexcolor('#737373'),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Divider
                Container(
                  color: Colors.white,
                  child: Divider(
                    thickness: 1.2,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    address = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EnterAddress()),
                    );
                    setState(() {});
                  },
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.grey[400],
                              size: 14,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 6),
                            ),
                            Text(
                              address == null
                                  ? "SET PICKUP ADRESS"
                                  : address.length > 30
                                      ? address.substring(0, 30) + "..."
                                      : address,
                              style: TextStyle(
                                fontSize: 14,
                                color: Hexcolor('#00B6BC'),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Hexcolor('#00B6BC'),
                          size: heading,
                        )
                      ],
                    ),
                  ),
                ),
                //Divider
                Container(
                  color: Colors.white,
                  child: Divider(
                    thickness: 1.2,
                  ),
                ),

                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.watch_later,
                              color: Hexcolor('#737373'),
                              size: 14,
                            ),
                            Padding(padding: EdgeInsets.only(left: 8)),
                            Text(
                              'SET DATE',
                              style: TextStyle(
                                color: Hexcolor('#737373'),
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                      printdates(),
                      GestureDetector(
                        onTap: () {
                          _selectdate(context);
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            "SELECT A CUSTOM DATE",
                            style: TextStyle(
                              color: Hexcolor('#00B6BC'),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                //Divider
                Container(
                  color: Colors.white,
                  child: Divider(
                    thickness: 1.2,
                  ),
                ),

                Container(
                  // height: 150,
                  padding: EdgeInsets.only(left: 16, bottom: 40, top: 8),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.watch_later,
                            color: Hexcolor('#737373'),
                            size: 14,
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Text(
                            'SET PICKUP TIME',
                            style: TextStyle(
                              color: Hexcolor('#737373'),
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Wrap(
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
                                      slotselected = 1;
                                      print(time);
                                      setState(() {});
                                      // Navigator.pop(context);
                                      // datetime();
                                    },
                                    child: Container(
                                      width: size.width * 0.27,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: slotselected == 1
                                            ? Hexcolor('#00B6BC')
                                            : Colors.white,

                                        border: Border.all(
                                            color: Hexcolor('#00B6BC'),
                                            width: 0.7),
                                        // borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 4),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        "9 am - 10 am",
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
                                      slotselected = 2;
                                      this.time = "10am-12pm";
                                      print(time);
                                      setState(() {});
                                      // Navigator.pop(context);
                                      // datetime();
                                    },
                                    child: Container(
                                      width: size.width * 0.27,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: slotselected == 2
                                            ? Hexcolor('#00B6BC')
                                            : Colors.white,
                                        border: Border.all(
                                          color: Hexcolor('#00B6BC'),
                                          width: 0.7,
                                        ),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 4),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        "10 am - 12 pm",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                            DateTime.parse(date.toString().substring(0, 10) +
                                            " 12:00:00")
                                        .difference(DateTime.now())
                                        .inMinutes <=
                                    0
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      slotselected = 3;
                                      this.time = "12 pm - 2 pm";
                                      print(time);
                                      setState(() {});
                                      // Navigator.pop(context);
                                      // datetime();
                                    },
                                    child: Container(
                                      width: size.width * 0.27,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: slotselected == 3
                                            ? Hexcolor('#00B6BC')
                                            : Colors.white,
                                        border: Border.all(
                                          color: Hexcolor('#00B6BC'),
                                          width: 0.7,
                                        ),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 4),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        "12 pm - 2 pm",
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
                                      slotselected = 4;
                                      this.time = "2 pm - 4 pm";
                                      print(time);
                                      setState(() {});
                                      // Navigator.pop(context);
                                      // datetime();
                                    },
                                    child: Container(
                                      width: size.width * 0.27,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: slotselected == 4
                                            ? Hexcolor('#00B6BC')
                                            : Colors.white,
                                        border: Border.all(
                                          color: Hexcolor('#00B6BC'),
                                          width: 0.7,
                                        ),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 4),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        "2 pm - 4 pm",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                            DateTime.parse(date.toString().substring(0, 10) +
                                            " 16:00:00")
                                        .difference(DateTime.now())
                                        .inMinutes <=
                                    0
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      this.time = "4 pm - 6 pm";
                                      slotselected = 5;
                                      print(time);
                                      setState(() {});
                                      // Navigator.pop(context);
                                      // datetime();
                                    },
                                    child: Container(
                                      width: size.width * 0.27,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: slotselected == 5
                                            ? Hexcolor('#00B6BC')
                                            : Colors.white,
                                        border: Border.all(
                                          color: Hexcolor('#00B6BC'),
                                          width: 0.7,
                                        ),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 4),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        "4 pm - 6 pm",
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
                                      slotselected = 6;
                                      this.time = "6pm-7pm";
                                      print(time);
                                      setState(() {});
                                      // Navigator.pop(context);
                                      // datetime();
                                    },
                                    child: Container(
                                      width: size.width * 0.27,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: slotselected == 6
                                            ? Hexcolor('#00B6BC')
                                            : Colors.white,
                                        border: Border.all(
                                          color: Hexcolor('#00B6BC'),
                                          width: 0.7,
                                        ),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 4),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        "6 pm - 7 pm",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),



                 Container(
                  // height: 150,
                  padding: EdgeInsets.only(left: 16, bottom: 40, top: 8),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.watch_later,
                            color: Hexcolor('#737373'),
                            size: 14,
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Text(
                            'SUITABLE DELIVERY TIME',
                            style: TextStyle(
                              color: Hexcolor('#737373'),
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Wrap(
                          children: [
                            GestureDetector(
                                    onTap: () {
                                      this.deliverytime = "9am-10am";
                                      delslotselected = 1;
                                      print(time);
                                      setState(() {});
                                      // Navigator.pop(context);
                                      // datetime();
                                    },
                                    child: Container(
                                      width: size.width * 0.27,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: delslotselected == 1
                                            ? Hexcolor('#00B6BC')
                                            : Colors.white,

                                        border: Border.all(
                                            color: Hexcolor('#00B6BC'),
                                            width: 0.7),
                                        // borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 4),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        "9 am - 10 am",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                            GestureDetector(
                                    onTap: () {
                                      delslotselected = 2;
                                      deliverytime = "10am-12pm";
                                      print(time);
                                      setState(() {});
                                      // Navigator.pop(context);
                                      // datetime();
                                    },
                                    child: Container(
                                      width: size.width * 0.27,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: delslotselected == 2
                                            ? Hexcolor('#00B6BC')
                                            : Colors.white,
                                        border: Border.all(
                                          color: Hexcolor('#00B6BC'),
                                          width: 0.7,
                                        ),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 4),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        "10 am - 12 pm",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                            GestureDetector(
                                    onTap: () {
                                      delslotselected = 3;
                                      deliverytime = "12 pm - 2 pm";
                                      print(time);
                                      setState(() {});
                                      // Navigator.pop(context);
                                      // datetime();
                                    },
                                    child: Container(
                                      width: size.width * 0.27,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: delslotselected == 3
                                            ? Hexcolor('#00B6BC')
                                            : Colors.white,
                                        border: Border.all(
                                          color: Hexcolor('#00B6BC'),
                                          width: 0.7,
                                        ),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 4),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        "12 pm - 2 pm",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                           GestureDetector(
                                    onTap: () {
                                      delslotselected = 4;
                                      deliverytime = "2 pm - 4 pm";
                                      print(time);
                                      setState(() {});
                                      // Navigator.pop(context);
                                      // datetime();
                                    },
                                    child: Container(
                                      width: size.width * 0.27,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: delslotselected == 4
                                            ? Hexcolor('#00B6BC')
                                            : Colors.white,
                                        border: Border.all(
                                          color: Hexcolor('#00B6BC'),
                                          width: 0.7,
                                        ),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 4),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        "2 pm - 4 pm",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                            GestureDetector(
                                    onTap: () {
                                      deliverytime = "4 pm - 6 pm";
                                      delslotselected = 5;
                                      print(time);
                                      setState(() {});
                                      // Navigator.pop(context);
                                      // datetime();
                                    },
                                    child: Container(
                                      width: size.width * 0.27,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: delslotselected == 5
                                            ? Hexcolor('#00B6BC')
                                            : Colors.white,
                                        border: Border.all(
                                          color: Hexcolor('#00B6BC'),
                                          width: 0.7,
                                        ),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 4),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        "4 pm - 6 pm",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                            GestureDetector(
                                    onTap: () {
                                      delslotselected = 6;
                                      deliverytime = "6pm-7pm";
                                      print(time);
                                      setState(() {});
                                      // Navigator.pop(context);
                                      // datetime();
                                    },
                                    child: Container(
                                      width: size.width * 0.27,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: delslotselected == 6
                                            ? Hexcolor('#00B6BC')
                                            : Colors.white,
                                        border: Border.all(
                                          color: Hexcolor('#00B6BC'),
                                          width: 0.7,
                                        ),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 4),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        "6 pm - 7 pm",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  color: Colors.white,
                )
                // Container(
                //   height: 300,
                //   color: Colors.red,
                //   child: Column(
                //     children: <Widget>[
                //       SizedBox(
                //         child: Column(
                //           children: <Widget>[
                //             Row(
                //               children: <Widget>[
                //                 GestureDetector(
                //                   onTap: () {
                //                     datetime();
                //                     print("hey");
                //                   },
                //                   child: Card(
                //                     shape: RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.circular(10.0),
                //                     ),
                //                     color: Color.fromRGBO(253, 186, 37, 1),
                //                     child: Card(
                //                       margin: EdgeInsetsDirectional.only(bottom: 5),
                //                       child: Container(
                //                         width:
                //                             (MediaQuery.of(context).size.width / 2) -
                //                                 40,
                //                         margin: EdgeInsets.all(10),
                //                         child: Column(
                //                           children: <Widget>[
                //                             Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment.spaceBetween,
                //                               children: <Widget>[
                //                                 Text(
                //                                   "Pickup time",
                //                                   style: TextStyle(
                //                                       fontSize: heading,
                //                                       color: Colors.black87,
                //                                       fontWeight: FontWeight.bold),
                //                                 ),
                //                                 Icon(
                //                                   Icons.keyboard_arrow_down,
                //                                   size: heading,
                //                                 )
                //                               ],
                //                             ),
                //                             Container(
                //                               child: Divider(),
                //                             ),
                //                             Container(
                //                               child: Text(
                //                                 date == null || time == null
                //                                     ? "-"
                //                                     : formatter
                //                                             .format(date)
                //                                             .toString() +
                //                                         " " +
                //                                         time,
                //                                 style: TextStyle(
                //                                     fontSize: subheading,
                //                                     color: Colors.black54,
                //                                     fontWeight: FontWeight.bold),
                //                               ),
                //                             )
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //                 GestureDetector(
                //                   onTap: () {
                //                     deliveryoption();
                //                   },
                //                   child: Card(
                //                     shape: RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.circular(10.0),
                //                     ),
                //                     color: Color.fromRGBO(253, 186, 37, 1),
                //                     child: Card(
                //                       margin: EdgeInsetsDirectional.only(bottom: 5),
                //                       child: Container(
                //                         width:
                //                             (MediaQuery.of(context).size.width / 2) -
                //                                 40,
                //                         margin: EdgeInsets.all(10),
                //                         child: Column(
                //                           children: <Widget>[
                //                             Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment.spaceBetween,
                //                               children: <Widget>[
                //                                 Text(
                //                                   "Delivery type",
                //                                   style: TextStyle(
                //                                       fontSize: heading,
                //                                       color: Colors.black87,
                //                                       fontWeight: FontWeight.bold),
                //                                 ),
                //                                 Icon(
                //                                   Icons.keyboard_arrow_down,
                //                                   size: heading,
                //                                 )
                //                               ],
                //                             ),
                //                             Container(
                //                               child: Divider(),
                //                             ),
                //                             Container(
                //                               child: Text(
                //                                 orderdetails["deliverytype"] == null
                //                                     ? "-"
                //                                     : orderdetails["deliverytype"] ==
                //                                             "0"
                //                                         ? "Pickup"
                //                                         : orderdetails[
                //                                                     "deliverytype"] ==
                //                                                 "1"
                //                                             ? "Normal Rs " +
                //                                                 orderdetails[
                //                                                         "deliveryprice"]
                //                                                     .toString()
                //                                             : "Express Rs " +
                //                                                 orderdetails[
                //                                                         "deliveryprice"]
                //                                                     .toString(),
                //                                 style: TextStyle(
                //                                     fontSize: subheading,
                //                                     color: Colors.black54,
                //                                     fontWeight: FontWeight.bold),
                //                               ),
                //                             )
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             )
                //           ],
                //         ),
                //       ),
                //       Expanded(
                //           flex: 11,
                //           child: Card(
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(10.0),
                //             ),
                //             color: Color.fromRGBO(253, 186, 37, 1),
                //             child: Card(
                //               margin: EdgeInsetsDirectional.only(bottom: 5),
                //               child: Container(
                //                 padding: EdgeInsets.all(10),
                //                 child: Column(
                //                   children: <Widget>[
                //                     Row(
                //                       children: <Widget>[
                //                         Text(
                //                           "Price : ",
                //                           style: TextStyle(
                //                               fontSize: subheading,
                //                               color: Colors.black54,
                //                               fontWeight: FontWeight.bold),
                //                         ),
                //                         Text(
                //                           "₹ " +
                //                               orderdetails["price"].toString() +
                //                               " (" +
                //                               orderdetails["quantity"].toString() +
                //                               " item(s) )",
                //                           style: TextStyle(
                //                               fontSize: subheading,
                //                               color: Colors.black87,
                //                               fontWeight: FontWeight.bold),
                //                         )
                //                       ],
                //                     ),
                //                     Row(
                //                       children: <Widget>[
                //                         Text(
                //                           "Delivery Charges : ",
                //                           style: TextStyle(
                //                               fontSize: subheading,
                //                               color: Colors.black54,
                //                               fontWeight: FontWeight.bold),
                //                         ),
                //                         Text(
                //                           orderdetails["deliveryprice"] == null
                //                               ? "₹ 0"
                //                               : "₹ " +
                //                                   orderdetails["deliveryprice"]
                //                                       .toString(),
                //                           style: TextStyle(
                //                               fontSize: subheading,
                //                               color: Colors.black87,
                //                               fontWeight: FontWeight.bold),
                //                         )
                //                       ],
                //                     ),
                //                     Divider(),
                //                     Row(
                //                       children: <Widget>[
                //                         Text(
                //                           "Total price : ",
                //                           style: TextStyle(
                //                               fontSize: subheading,
                //                               color: Colors.black54,
                //                               fontWeight: FontWeight.bold),
                //                         ),
                //                         Text(
                //                           "₹ " +
                //                               orderdetails["totalprice"].toString() +
                //                               " (GST extra as applicable)",
                //                           style: TextStyle(
                //                               fontSize: subheading,
                //                               color: Colors.black87,
                //                               fontWeight: FontWeight.bold),
                //                         )
                //                       ],
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ),
                //           ))
                //     ],
                //   ),
                // ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                height: 140,
                width: size.width,
                color: Hexcolor('#219251'),
                child: Column(
                  children: [
                    Container(
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
                              'Pickup Details',
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
                              'Outlet',
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
                      margin: EdgeInsets.fromLTRB(16, 10, 16, 24),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: size.width * 0.7,
                              child: Text(
                                outletname==null?"Loading..":outletname,
                                // address == null ? disp : address,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
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
              child: GestureDetector(
                onTap: (){
                   if (address == null) {
                            showsnack("Please enter address");
                          } else if (date == null || time == null) {
                            showsnack("Please select date and time");
                          } else {
                            remarks();
                            print(widget.order);
                          }
                },
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Review Details",
                              // "₹ " + totalprice.toString(),
                              style: TextStyle(
                                color: Hexcolor('#252525'),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 5)),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Hexcolor('#252525'),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
