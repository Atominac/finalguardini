import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jiffy/jiffy.dart';

import 'orderPlaced.dart';

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
    getdetails();
  }

  var outletname;
  getdetails() async {
    final user = await SharedPreferences.getInstance();
    outletname = user.getString("outletname");
    setState(() {});
  }

//    getjson() async{
//      webhook();
//     final user = await SharedPreferences.getInstance();

//     final String url =
//         "http://34.93.1.41/guardini/public/orders.php/create";
//     var response = await http.post(
//         //encode url
//         Uri.encodeFull(url),
//         headers: {
//           "accept": "application/json"
//         },
//         body: {"masterhash": user.getString("masterhash"),"data":jsonEncode(widget.order)},

// );

//         print(response.body);

//    }
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

  placeorder() async {
    _showdialogue();
    // return;
    final user = await SharedPreferences.getInstance();
    print(user.getString("masterhash"));
    print(json.encode({
      "masterhash": user.getString("masterhash"),
      "data": json.encode(widget.order)
    }));
    // return;

    final String url = "http://34.93.1.41/guardini/public/orders.php/create";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {
        "masterhash": user.getString("masterhash"),
        "data": json.encode(widget.order)
      },
    );
    print(jsonEncode({
      "masterhash": user.getString("masterhash"),
      "data": json.encode(widget.order)
    }));
    ////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(response.body);

    if (jsondecoded['message'] == "success") {
      // setState(() {});
      print("heyeyeyeyey");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderPlaced()),
      );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => Ordersuccess(jsondecoded['orderid'])),
      // );
    } else if (jsondecoded['message'] == "error_creating_order_details") {
      showsnack("cant't create order please retry");
    } else if (jsondecoded['message'] == "error_in_hash") {
      showsnack("Session expired login again and retry");
    } else {
      showsnack("cant't create order please retry");
    }
  }

  webhook() async {
    final user = await SharedPreferences.getInstance();

    final String url =
        "https://webhook.site/fdf3da52-295f-4e9a-ad12-84da6edcf258";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {
        "masterhash": user.getString("masterhash"),
        "data": jsonEncode(widget.order)
      },
    );

    print(response.body);
  }

  int _radioValue = 0;
  double _result = 0.0;

  showsnack(String message) {
    ////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scafoldkey.currentState.showSnackBar(snackBar);
  }

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
          child: Scaffold(
        key: _scafoldkey,
        backgroundColor: Hexcolor('#EFE9E0'),
        appBar: AppBar(title: Text("Review Details"),backgroundColor: Hexcolor('#219251'),),
        body: Stack(
          children: [
            
            Container(
              child: ListView(
                children: <Widget>[
                   Container(
               height: 80,
               width: size.width,
               color: Hexcolor('#219251'),
               child: Column(
                 children: [
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
                     margin: EdgeInsets.fromLTRB(16, 10, 16, 20),
                     child: Container(
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                           Container(
                             width: size.width * 0.7,
                             child: Text(
                               outletname == null ? "Loading.." : outletname,
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
                  Container(
                    // margin: EdgeInsets.only(top: 80),
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
                                'Discount',
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
                                widget.order["safekeeping"] == 0
                                    ?  widget.order["deliverytype"] == "3" ||  widget.order["deliverytype"] == "2"?"Express Charges":'Delivery Charges'
                                    : widget.order["deliverytype"] == "3" ||  widget.order["deliverytype"] == "2"?"Express Charges": "Safekeeping Charges",
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
                              padding: const EdgeInsets.only(top: 16, bottom: 0),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              padding: const EdgeInsets.only(top: 16, bottom: 16),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${Jiffy(widget.order["pickuptime"].toString().substring(0, widget.order["pickuptime"].toString().indexOf(" "))).format("do MMMM yyyy")}',
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
                      placeorder();
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
      ),
    );
  }
}
