import 'package:flutter/material.dart';
import 'package:guardini/paymentwebviiew.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

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


pay() async{
  final user = await SharedPreferences.getInstance();
   var ending="?"+"masterhash=${user.getString("masterhash")}&order_id=${widget.order["orderid"]}";
   var full ="http://guardini.conexo.in/gatewaytest/NON_SEAMLESS_KIT/dataFrom.php"+ending;
    print(full);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebView("http://guardini.conexo.in/gatewaytest/NON_SEAMLESS_KIT/success.php",widget.order["orderid"]),
          ),
        );
}
  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
    switch (selectedRadioTile) {
      case 1:
        break;
      case 2:
      pay();
        break;
      case 3:
        break;
      default:
    }
    print(selectedRadioTile);
  }

  int selectedRadioTile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            "Wallet",
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
