import 'package:flutter/material.dart';
import 'package:guardini/paymentwebviiew.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  var order;
  PaymentScreen(this.order);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  void initState() {
    super.initState();
    // selectedRadio = 0;
    selectedRadioTile = 0;
  }

  payviagateway() async {
    final user = await SharedPreferences.getInstance();
    var ending = "?" +
        "masterhash=${user.getString("masterhash")}&order_id=${widget.order["orderid"]}";
    var full =
        "http://guardini.conexo.in/gatewaytest/NON_SEAMLESS_KIT/dataFrom.php" +
            ending;
    print(full);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentWebView(full, widget.order["orderid"]),
      ),
    );
  }

  getcredits() async {
    // _showdialogue();
    final user = await SharedPreferences.getInstance();

    final String url =
        "http://34.93.1.41/guardini/public/authenticate.php/user/getbalance";
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
      return int.parse(data[0]["balancecredits"]);
    } else {
      Navigator.pop(context);
      showsnack("Some error has ouccered");
      return null;
    }
  }

  payviawallet() async {
    var credits = await getcredits();
    print(credits);
    if (credits < int.parse(widget.order["totalprice"])) {
      showsnack("Please add amount to use this  method");
    } else {
      print("wow");
      walletpay();
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

  walletpay() async {
    _showdialogue();
    final user = await SharedPreferences.getInstance();

    final String url =
        "http://34.93.1.41/guardini/public/authenticate.php/user/balancededuct";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {"masterhash": user.getString("masterhash"),"amount":widget.order["totalprice"],"orderid":widget.order["orderid"]},
    );

    //print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);
    if (jsondecoded['message'] == "success") {
      showsnack("Payment successfull");
      Navigator.pop(context);
      Navigator.pop(context);

    }else if (jsondecoded['message'] == "invalid_order") {
      showsnack("Something went wrong with payment");
      Navigator.pop(context);
      Navigator.pop(context);

    } else if (jsondecoded['message'] == "actual_order_amt_0") {
      showsnack("Invalid order amount");
      Navigator.pop(context);
      Navigator.pop(context);

    } else if (jsondecoded['message'] == "payment_not_correct") {
      showsnack("Invalid amount");
      Navigator.pop(context);
      Navigator.pop(context);

    } else if (jsondecoded['message'] == "insufficient_fund") {
      showsnack("Insufficient balance");
      Navigator.pop(context);
      Navigator.pop(context);

    }else {
      Navigator.pop(context);
      showsnack("Some error has ouccered");
    }
  }

  payviacash() async{

_showdialogue();
    final user = await SharedPreferences.getInstance();

    final String url =
        "http://34.93.1.41/guardini/public/authenticate.php/user/paycash";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {"masterhash": user.getString("masterhash"),"orderid":widget.order["orderid"]},
    );

    //print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);
    if (jsondecoded['message'] == "success") {
      showsnack("Payment successfull");
      Navigator.pop(context);
      Navigator.pop(context);

    }else {
      Navigator.pop(context);
      showsnack("Some error has ouccered");
    }
  }

  var paytype = 0;
  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
    switch (selectedRadioTile) {
      case 1:
        paytype = 1;
        break;
      case 2:
        paytype = 2;
        // pay();
        break;
      case 3:
        paytype = 3;
        break;
      default:
    }
    print(selectedRadioTile);
  }

  showsnack(String message) {
    //////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scafoldkey.currentState.showSnackBar(snackBar);
  }

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();

  int selectedRadioTile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldkey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Payments'),
        backgroundColor: Hexcolor('#219251'),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25),
            alignment: Alignment.center,
            child: Text(
              'Booking Id: #${widget.order["orderid"].toString()}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            alignment: Alignment.center,
            child: Text(
              '₹ ${widget.order["totalprice"].toString()}',
              style: TextStyle(
                color: Hexcolor('#404040'),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            alignment: Alignment.center,
            child: Text(
              '${widget.order["quantity"].toString()} items',
              style: TextStyle(
                color: Hexcolor('#737373'),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 24),
            // color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                //   child: Text(
                //     'BILL DETAILS',
                //     style: TextStyle(
                //       fontSize: 14,
                //       color: Hexcolor('#595959'),
                //     ),
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
                        '₹ ${widget.order["amount"].toString()}',
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
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
                        '₹ ${widget.order["delieverycharges"].toString()}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
                Divider(
                  indent: 16,
                  endIndent: 16,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  indent: 16,
                  endIndent: 16,
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(16, 40, 16, 0),
                  child: Text(
                    'PAYMENT METHOD',
                    style: TextStyle(
                      color: Hexcolor('#404040'),
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: RadioListTile(
                          value: 1,
                          groupValue: selectedRadioTile,
                          title: Text(
                            "Wallet / PPD Adjustment",
                            style: TextStyle(fontSize: 14),
                          ),
                          onChanged: (val) {
                            print("Radio Tile pressed $val");
                            setSelectedRadioTile(val);
                          },
                          // activeColor: Colors.green,
                          // selected: true,
                        ),
                      ),
                      Container(
                        child: RadioListTile(
                          value: 2,
                          groupValue: selectedRadioTile,
                          title: Text("Online Payment"),
                          onChanged: (val) {
                            print("Radio Tile pressed $val");
                            setSelectedRadioTile(val);
                          },
                          // activeColor: Colors.green,
                          // selected: true,
                        ),
                      ),
                      Container(
                        child: RadioListTile(
                          value: 3,
                          groupValue: selectedRadioTile,
                          title: Text(
                            "Cash",
                            style: TextStyle(fontSize: 14),
                          ),
                          onChanged: (val) {
                            print("Radio Tile pressed $val");
                            setSelectedRadioTile(val);
                          },
                          // activeColor: Colors.green,
                          // selected: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40, bottom: 10, left: 25),
                  child: InkWell(
                    onTap: () {
                      print(widget.order);
                      // verifyotp(mainotp);
                      if (paytype == 1) {
                        payviawallet();
                      } else if (paytype == 2) {
                        payviagateway();
                      } else if (paytype == 3) {
                        payviacash();
                      } else {
                        showsnack("No orders available");
                      }
                    },
                    splashColor: Color.fromRGBO(255, 194, 51, 0.3),
                    highlightColor: Color.fromRGBO(255, 194, 51, 0.25),
                    child: Container(
                      width: 180,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 194, 51, 0.4),
                          border: Border.all(
                            color: Hexcolor('#FFC233'),
                            width: 0.5,
                          )),
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        'Make Payment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Hexcolor('#404040'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
