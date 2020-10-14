import 'package:flutter/material.dart';
import 'package:guardini/ordersummary.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class EnterAddress extends StatefulWidget {
  @override
  _EnterAddressState createState() => _EnterAddressState();
}

class _EnterAddressState extends State<EnterAddress> {
  var states = ["New Delhi", "Uttar Pradesh", "Haryana"];
  var currentstate = " ";
  var city = ["Gurugram", "New Delhi", "Ghaziabad"];
  var currentcity = " ";

  var address = "Fetching...";
  final TextEditingController t1 = new TextEditingController(text: "");
  final TextEditingController t2 = new TextEditingController(text: "");
  final TextEditingController t3 = new TextEditingController(text: "");
  final TextEditingController t4 = new TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();

  showsnack(String message) {
    ////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scafoldkey.currentState.showSnackBar(snackBar);
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

  createaddress() async {
    _showdialogue();
    final user = await SharedPreferences.getInstance();
    var x = {
      "masterhash": user.getString("masterhash"),
      "address1": t1.text,
      "address2": t2.text,
      "state": currentstate,
      "city": currentcity,
      "landmark": t3.text,
      "pincode": t4.text,
      "coordinates": user.getString("coordinates") == null
          ? " "
          : user.getString("coordinates")
    };
    print(x);
    final String url =
        "http://34.93.1.41/guardini/public/orders.php/address/create";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {
        "masterhash": user.getString("masterhash"),
        "address1": t1.text,
        "address2": t2.text,
        "state": currentstate,
        "city": currentcity,
        "landmark": t3.text,
        "pincode": t4.text,
        "coordinates": user.getString("coordinates") == null
            ? " "
            : user.getString("coordinates")
      },
    );
    //print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);
    if (jsondecoded['message'] == "address_created") {
      Navigator.pop(context);

      var ret = await fetchaddress();
      print("ret");
      print(ret);
      if (ret == 1) {
        Navigator.pop(context, address);
      }
    } else if (jsondecoded['message'] == "missing_parameters") {
      Navigator.pop(context);
      showsnack("Enter valid details");
    } else {
      showsnack("Some error has ouccered");
      Navigator.pop(context);
    }
  }

  var flag = 0;
  fetchaddress() async {
    _showdialogue();
    final user = await SharedPreferences.getInstance();

    final String url =
        "http://34.93.1.41/guardini/public/orders.php/address/latest";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {"masterhash": user.getString("masterhash")},
    );

    //print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    var data = jsondecoded["data"];
    print(jsondecoded);
    if (jsondecoded['message'] == "success") {
      address = data["address1"] +
          "," +
          data["address2"] +
          "," +
          data["landmark"] +
          "," +
          data["city"] +
          "," +
          data["state"] +
          "," +
          data["pincode"];
      Navigator.pop(context);
      flag = 1;
      setState(() {});
      user.setString("savedaddress", address);
      print(1);
      return 1;
    } else if (jsondecoded['message'] == "missing_parameters") {
      Navigator.pop(context);

      showsnack("Enter valid details");

      Navigator.pop(context);
    } else if (jsondecoded['message'] == "no_address_found") {
      address = "No address found. please add a new one";
      // flag=0;
      setState(() {});
      Navigator.pop(context);
    } else if (jsondecoded['message'] == "error_fetching_data") {
      showsnack("Cant Fetch address add a new one");

      Navigator.pop(context);
    } else if (jsondecoded['message'] == "error_in_hash") {
      showsnack("Invaid user");

      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      showsnack("Some error has ouccered");
    }
    //parameter_missing
    //parameter_missing
    return 0;
  }

  @override
  void initState() {
    super.initState();
    print("1");
    Future.delayed(Duration.zero, () {
      fetchaddress();
    });
    // fetchaddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scafoldkey,
        appBar: AppBar(
          title: Text("Delivery address"),
          backgroundColor: Hexcolor('#219251'),
        ),
        backgroundColor: Hexcolor('#EFE9E0'),
        body: ListView(
          children: <Widget>[
           flag==0?Container(): GestureDetector(
              onTap: () {
                if (flag == 0) {
                  showsnack("Add new address");
                } else {
                  Navigator.pop(context, address);
                }
              },
              child: Container(
                margin: EdgeInsetsDirectional.only(top: 5),
                padding: EdgeInsets.only(bottom: 16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 24, 0, 00),
                      child: Text(
                        "SAVED ADDRESS",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Divider(),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.home,
                                color: Colors.black54,
                                size: 16,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                              ),
                              Text(
                                'Home',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Hexcolor('#595959')),
                              )
                            ],
                          ),
                          Text(
                            address,
                            // overflow: TextOverflow.fade,
                            maxLines: 5,
                            style: TextStyle(
                              fontSize: 12,
                              color: Hexcolor('#595959'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.only(top: 5),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 16, 10, 0),
                      child: Text(
                        "Add new address",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 14, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'House No./ Building No.',
                            style: TextStyle(
                              color: Hexcolor('#737373'),
                              fontSize: 12,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                          ),
                          TextFormField(
                            // inputFormatters: [
                            //   new WhitelistingTextInputFormatter(
                            //       RegExp("[a-zA-Z0-9 ]")),
                            // ],
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Color.fromRGBO(239, 233, 224, 0.75),
                            ),
                            keyboardType: TextInputType.text,
                            controller: t1,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Address';
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Street Name / Complex Name',
                            style: TextStyle(
                              color: Hexcolor('#737373'),
                              fontSize: 12,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                          ),
                          TextFormField(
                            // inputFormatters: [
                            //   new WhitelistingTextInputFormatter(
                            //       RegExp("[a-zA-Z0-9 ]")),
                            // ],
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Color.fromRGBO(239, 233, 224, 0.75),
                            ),
                            keyboardType: TextInputType.text,
                            controller: t2,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Locality',
                            style: TextStyle(
                              color: Hexcolor('#737373'),
                              fontSize: 12,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                          ),
                          TextFormField(
                            // inputFormatters: [
                            //   new WhitelistingTextInputFormatter(
                            //       RegExp("[a-zA-Z0-9 ]")),
                            // ],
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Color.fromRGBO(239, 233, 224, 0.75),
                            ),
                            keyboardType: TextInputType.text,
                            controller: t3,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pincode',
                            style: TextStyle(
                              color: Hexcolor('#737373'),
                              fontSize: 12,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                          ),
                          TextFormField(
                            // inputFormatters: [
                            //   new WhitelistingTextInputFormatter(
                            //       RegExp("[a-zA-Z0-9 ]")),
                            // ],
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Color.fromRGBO(239, 233, 224, 0.75),
                            ),
                            keyboardType: TextInputType.text,
                            controller: t4,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Pincode';
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(16, 20, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'City',
                                  style: TextStyle(
                                    color: Hexcolor('#737373'),
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(239, 233, 224, 0.75),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: DropdownButton<String>(
                                    items: city.map(
                                      (String listitem) {
                                        return DropdownMenuItem<String>(
                                          value: listitem,
                                          child: Text(listitem),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (String selected) {
                                      setState(() {
                                        this.currentcity = selected;
                                        // enteraddress();
                                      });
                                    },
                                    hint: Text(currentcity),
                                    isExpanded: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'State',
                                  style: TextStyle(
                                    color: Hexcolor('#737373'),
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(239, 233, 224, 0.75),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: DropdownButton<String>(
                                    items: states.map((String listitem) {
                                      return DropdownMenuItem<String>(
                                        value: listitem,
                                        child: Text(listitem),
                                      );
                                    }).toList(),
                                    onChanged: (String selected) {
                                      setState(
                                        () {
                                          this.currentstate = selected;
                                          // enteraddress();
                                        },
                                      );
                                    },
                                    hint: Text(currentstate),
                                    isExpanded: true,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 16, top: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Save address as",
                  //   style: TextStyle(
                  //     fontSize: 17,
                  //     color: Colors.black54,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  // Row(
                  //   children: [
                  //     Row(
                  //       children: [
                  //         Radio(
                  //           value: 2,
                  //           groupValue: 0,
                  //           onChanged: null,
                  //         ),
                  //         Text('Home'),
                  //       ],
                  //     ),
                  //     Row(
                  //       children: [
                  //         Radio(
                  //           value: 2,
                  //           groupValue: 0,
                  //           onChanged: null,
                  //         ),
                  //         Text('Work'),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(3),
                        ),
                        child: Container(
                          child: Text(
                            "Save address",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                        color: Hexcolor("#FFC233"),
                        textTheme: ButtonTextTheme.normal,
                        height: 50.0,
                        minWidth: MediaQuery.of(context).size.width * 0.4,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            print("object");
                            // verifymobile();
                            if (currentcity == " ") {
                              showsnack(
                                  "Please select city or use previous address");
                            }
                            if (currentstate == " ") {
                              showsnack(
                                  "Please select State or use previous address");
                            } else {
                              createaddress();
                            }
                          }
                        }),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
