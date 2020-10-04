// import 'package:flutter/material.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import './homescreen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/services.dart';

// class OrderRating extends StatefulWidget {
//   Map detail;
//   OrderRating(this.detail);
//   @override
//   _OrderRatingState createState() => _OrderRatingState();
// }

// class _OrderRatingState extends State<OrderRating> {
//   double rate = 0;
//   final TextEditingController t1 = new TextEditingController(text: "");
//   final TextEditingController t2 = new TextEditingController(text: "");
//   final TextEditingController t3 = new TextEditingController(text: "");

//   final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();
//   showsnack(String message) {
//     print(message);
//     final snackBar = SnackBar(content: Text(message));
//     _scafoldkey.currentState.showSnackBar(snackBar);
//   }

//   void _showdialogue() {
//     showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (BuildContext context) {
//           return Center(
//             child: Container(child: CircularProgressIndicator()),
//           );
//         });
//   }

//   rateandreview() async {
//     final user = await SharedPreferences.getInstance();
//     print(widget.detail["orderid"]);
//     print(rate);
//     print(t1.text);
//     print({
//       "masterhash": user.getString("masterhash"),
//       "orderid": widget.detail["orderid"].toString(),
//       "rating": rate,
//       "review": t1.text == null ? "" : t1.text
//     });
//     _showdialogue();
//     final String url =
//         "http://34.93.1.41/guardini/public/orders.php/user/rating";

//     var response = await http.post(
//       //encode url
//       Uri.encodeFull(url),
//       headers: {"accept": "application/json"},
//       body: {
//         "masterhash": user.getString("masterhash"),
//         "orderid": widget.detail["orderid"].toString(),
//         "rating": rate.toString(),
//         "review": t1.text == null ? "" : t1.text
//       },
//     );
//     print("start");

//     var jsondecoded = json.decode(response.body);
//     print(response.body);
//     if (jsondecoded["message"] == "success") {
//       setState(() {});
//       Navigator.pop(context);
//       if (rate == 5) {
//         reffral();
//       } else {
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => HomeScreen()));
//       }
//     } else {
//       Navigator.pop(context);
//       showsnack("Please retry");
//     }
//   }

//   addreffral() async {
//     final user = await SharedPreferences.getInstance();
//     print(widget.detail["orderid"]);
//     print(rate);
//     print(t1.text);
//     print({
//       "masterhash": user.getString("masterhash"),
//       "mobileno":t3.text,
//       "name":t2.text
//     });
//     // return 0;
//     _showdialogue();
//     final String url =
//         "http://34.93.1.41/guardini/public/orders.php/user/reffral";

//     var response = await http.post(
//       //encode url
//       Uri.encodeFull(url),
//       headers: {"accept": "application/json"},
//       body: {
//         "masterhash": user.getString("masterhash"),
//         "mobileno": t3.text,
//         "name": t2.text
//       },
//     );
//     print("start");

//     var jsondecoded = json.decode(response.body);
//     print(response.body);
//     if (jsondecoded["message"] == "success") {
//       setState(() {});
//       Navigator.pop(context);
      
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => HomeScreen()));
      
//     } else {
//       Navigator.pop(context);
//       showsnack("Please retry");
//     }
//   }

//   void reffral() {
//     // flutter defined function
//     print(widget.detail);
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         // return object of type Dialog
//         return AlertDialog(
//           title: Column(
//             children: [
//               Container(
//                   margin: EdgeInsets.all(10),
//                   child: Image.asset(
//                     "assets/discount.png",
//                     height: 50,
//                     width: 50,
//                   )),
//               Text(
//                 'Refer a friend and earn rewards',
//                 style: TextStyle(
//                     fontSize: 17,
//                     color: Colors.black87,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           content: Container(
//             child: SizedBox(
//               height: 150,
//               child: Column(
//                 children: <Widget>[
//                   TextField(
//                       controller: t2,
//                       decoration: new InputDecoration(
//                         hintText: "Name",
//                       )),
//                   TextField(
//                       controller: t3,
//                       decoration: new InputDecoration(
//                         hintText: "Mobile no.",
//                       )),
//                 ],
//               ),
//             ),
//           ),
//           actions: <Widget>[
//             // usually buttons at the bottom of the dialog
//             new FlatButton(
//               child: new Text("Close"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             new FlatButton(
//               child: new Text("Continue"),
//               onPressed: () {
//                 if(t2.text=="" || t3.text==""){
//                     showsnack("Please enter mobile no. and name");
//                 }else{
//                   addreffral();
//                 }
//                 // creteorder();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print(widget.detail);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: (){
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => HomeScreen()));
//       },
//       child: Scaffold(
//           key: _scafoldkey,
//           appBar: AppBar(
//             title: Text("Rating & Review"),
//             backgroundColor: Color.fromRGBO(38, 179, 163, 1),
//           ),
//           body: ListView(
//             children: <Widget>[
//               Container(
//                 padding: EdgeInsets.all(10),
//                 child: Column(
//                   children: <Widget>[
//                     Align(
//                         alignment: Alignment.center,
//                         child: Image.asset(
//                           "assets/ordercomplete.png",
//                           height: 250,
//                         )),
//                     Container(
//                       padding: EdgeInsets.all(5),
//                       child: Center(
//                         child: Text(
//                           "Rate Your Experience",
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Colors.grey,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SmoothStarRating(
//                         allowHalfRating: false,
//                         onRated: (v) {
//                           rate = v;
//                           setState(() {});
//                         },
//                         starCount: 5,
//                         rating: rate,
//                         size: 40.0,
//                         color: Colors.orangeAccent,
//                         borderColor: Colors.grey,
//                         spacing: 10),
//                     Card(
//                       child: Container(
//                         padding: EdgeInsets.all(10),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             Center(
//                               child: Text(
//                                 "Summary",
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   color: Colors.black87,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.all(10),
//                             ),
//                             Row(
//                               children: <Widget>[
//                                 Text(
//                                   "Order id :",
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(3),
//                                 ),
//                                 Text(
//                                   widget.detail["orderid"],
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.black38,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding: EdgeInsets.all(3),
//                             ),
//                             Row(
//                               children: <Widget>[
//                                 Text(
//                                   "Order Date :",
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(3),
//                                 ),
//                                 Text(
//                                   widget.detail["datetime"],
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.black38,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding: EdgeInsets.all(3),
//                             ),
//                             Row(
//                               children: <Widget>[
//                                 Text(
//                                   "Completion Date :",
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(3),
//                                 ),
//                                 Text(
//                                   widget.detail["deliveredtime"] == null
//                                       ? " "
//                                       : widget.detail["deliveredtime"],
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.black38,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding: EdgeInsets.all(3),
//                             ),
//                             Row(
//                               children: <Widget>[
//                                 Text(
//                                   "Items :",
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(3),
//                                 ),
//                                 Text(
//                                   widget.detail["quantity"],
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.black38,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
//                               child: TextField(
//                                       inputFormatters: [
//                                         new WhitelistingTextInputFormatter(
//                                             RegExp("[a-zA-Z0-9 ]")),
//                                       ],
//                                   controller: t1,
//                                   decoration: new InputDecoration(
//                                     hintText: "Write a review(Optional)",
//                                   )),
//                             ),
//                             ButtonTheme.bar(
//                               // make buttons use the appropriate styles for cards
//                               child: ButtonBar(
//                                 children: <Widget>[
//                                   FlatButton(
//                                     child: const Text('Submit'),
//                                     onPressed: () {
//                                       if (rate == 0) {
//                                         showsnack(
//                                             "Please rate before submitting");
//                                       } else if (t1.text.length > 60) {
//                                         showsnack(
//                                             "Review not more than 60 letters");
//                                       } else {
//                                         rateandreview();
//                                       }
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           )),
//     );
//   }
// }
