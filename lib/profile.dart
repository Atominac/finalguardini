import 'package:flutter/material.dart';
import 'package:guardini/changepassword.dart';
import 'package:guardini/edit_profile.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'enteraddress.dart';
import 'login.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var name, mobile, email, status, address;
  final TextEditingController t1 = new TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    getdetails();
    getcredits();
  }

  var balancecredits;
// var balancestatus="loading...";
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
      balancecredits = "₹ " + data[0]["balancecredits"].toString();
      setState(() {});
    } else {
      Navigator.pop(context);
      showsnack("Some error has ouccered");
      balancecredits = "NOT VALID";
      setState(() {});
    }
    //parameter_missing
    //parameter_missing
    return 0;
  }

  getdetails() async {
    final user = await SharedPreferences.getInstance();
    name = user.getString("fullname");
    mobile = user.getString("mobileno");
    email = user.getString("email");
    address = user.getString("savedaddress");
    if (address == null) fetchaddress();
    print(address);
    setState(() {
      status = "1"; // data is loaded
    });
  }

  DatabaseReference databaseReference = new FirebaseDatabase().reference();

  logout() async {
    _showdialogue();
    final String url =
        "http://34.93.1.41/guardini/public/authenticate.php/user/destroysession";
    final user = await SharedPreferences.getInstance();
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {
        "sessiontoken": user.getString('session_token'),
        "masterhash": user.getString('masterhash')
      },
    );

    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      databaseReference.child('all/${user.getString("fcm_token")}').remove();
      databaseReference
          .child(
              'specefic/${user.getString("masterhash")}/${user.getString("fcm_token")}')
          .remove();
      user.clear();

      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return response.body;
    } else if (jsondecoded["message"] == "error_in_hash") {
      showsnack("Not valid user");
    } else if (jsondecoded["message"] == "error") {
      showsnack("Some error has ouccered");
    }
  }

  logoutdeleteaccount() async {
    _showdialogue();
    final String url =
        "http://34.93.1.41/guardini/public/authenticate.php/user/destroysession";
    final user = await SharedPreferences.getInstance();
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {
        "sessiontoken": user.getString('session_token'),
        "masterhash": user.getString('masterhash')
      },
    );

    var jsondecoded = json.decode(response.body);
    print(jsondecoded);
    if (jsondecoded['message'] == "success") {
      databaseReference.child('all/${user.getString("fcm_token")}').remove();
      databaseReference
          .child(
              'specefic/${user.getString("masterhash")}/${user.getString("fcm_token")}')
          .remove();
      deleteaccount();
    } else if (jsondecoded["message"] == "error_in_hash") {
      showsnack("Not valid user");
    } else if (jsondecoded["message"] == "error") {
      showsnack("Some error has ouccered");
    }
  }

  void deleteaccountdialogue() {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Please enter your password"),
          content: new TextField(
              controller: t1,
              obscureText: true,
              decoration: new InputDecoration(
                hintText: "Password",
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(color: Colors.teal),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Submit",
                style: TextStyle(color: Colors.teal),
              ),
              onPressed: () {
                if (t1.text.isEmpty) {
                  showsnack("please enter password");
                  Navigator.pop(context);
                } else {
                  logoutdeleteaccount();
                }
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //delete account api call
  deleteaccount() async {
    print(t1.text);
    _showdialogue();
    final user = await SharedPreferences.getInstance();
    print(user.getString("masterhash"));

    final String url =
        "http://34.93.1.41/guardini/public/authenticate.php/user/delete";

    var response = await http.post(
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {"masterhash": user.getString("masterhash"), "password": t1.text},
    );

    var jsondecoded = json.decode(response.body);
    print(jsondecoded);
    if (jsondecoded["message"] == "missing_parameters") {
      Navigator.pop(context);
      Navigator.pop(context);

      showsnack("Enter valid details");
    } else if (jsondecoded["message"] == "error_in_hash") {
      Navigator.pop(context);
      Navigator.pop(context);

      showsnack("Invalid User");
    } else if (jsondecoded["message"] == "password_not_match") {
      Navigator.pop(context);
      Navigator.pop(context);

      showsnack("Enter valid password");
    } else if (jsondecoded["message"] == "error") {
      Navigator.pop(context);
      Navigator.pop(context);

      showsnack("Cant delete account");
    } else if (jsondecoded["message"] == "success") {
      user.clear();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  showsnack(String message) {
    ////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scafoldkey.currentState.showSnackBar(snackBar);
  }

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();

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
      // flag = 1;
      setState(() {});
      user.setString("savedaddress", address);
      print("dfghjk");
      print(user.getString("savedaddress"));
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
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    return Scaffold(
      backgroundColor: Hexcolor('#F3EEE8'),
      key: _scafoldkey,
      body: status == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Container(
                  color: Hexcolor('#219251'),
                  height: size.height * 0.2,
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        child: Image.asset('assets/newuser.png'),
                      ),
                      Padding(padding: EdgeInsets.all(3)),
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 7),
                  child: Column(
                    children: <Widget>[
                      //Profile Details
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      //'PROFILE DETAILS'
                                      Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.perm_identity,
                                              size: 16,
                                              color: Hexcolor('#737373'),
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5)),
                                            Text(
                                              'WALLET BALANCE',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Hexcolor('#737373'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //Name
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 22, top: 14),
                                        child: Text(
                                          balancecredits == null
                                              ? "Loading"
                                              : balancecredits.toString(),
                                          style: TextStyle(
                                            color: Hexcolor('#404040'),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      //'PROFILE DETAILS'
                                      Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.perm_identity,
                                              size: 16,
                                              color: Hexcolor('#737373'),
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5)),
                                            Text(
                                              'PROFILE DETAILS',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Hexcolor('#737373'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //Name
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 22, top: 14),
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                            color: Hexcolor('#404040'),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      //Email
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 22, top: 3),
                                        child: Text(
                                          email,
                                          style: TextStyle(
                                            color: Hexcolor('#404040'),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      //Phone no
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 22, top: 3),
                                        child: Text(
                                          '+91 ' + mobile,
                                          style: TextStyle(
                                            color: Hexcolor('#404040'),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) =>
                            //                 EditProfile(
                            //                     name, mobile, email)));
                            //   },
                            //   child: Text(
                            //     'EDIT',
                            //     style: TextStyle(
                            //       color: Hexcolor('#00B6BC'),
                            //       fontSize: 10,
                            //       fontWeight: FontWeight.w500,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      //Saved Address
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      //'PROFILE DETAILS'
                                      Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 16,
                                              color: Hexcolor('#737373'),
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5)),
                                            Text(
                                              'SAVED PICKUP ADDRESS',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Hexcolor('#737373'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //'Home'
                                      address == null
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  left: 22, top: 14),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EnterAddress()));
                                                  setState(() {});
                                                },
                                                child: Text(
                                                  'ADD ADDRESS',
                                                  style: TextStyle(
                                                    color: Hexcolor('#00B6BC'),
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Column(
                                              children: [
                                                //     Container(
                                                //   margin: EdgeInsets.only(
                                                //       left: 22, top: 14),
                                                //   child: Text(
                                                //     'Home',
                                                //     style: TextStyle(
                                                //       color: Hexcolor('#404040'),
                                                //       fontSize: 14,
                                                //       fontWeight: FontWeight.w500,
                                                //     ),
                                                //   ),
                                                // ),
                                                //Address
                                                Container(
                                                  width: size.width * 0.7,
                                                  margin: EdgeInsets.only(
                                                      left: 22, top: 3),
                                                  child: Text(
                                                    address,
                                                    style: TextStyle(
                                                      color:
                                                          Hexcolor('#595959'),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                    ],
                                  ),
                                  address != null
                                      ? GestureDetector(
                                          onTap: () async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EnterAddress()));
                                            print("hry bitch");
                                            getdetails();
                                          },
                                          child: Text(
                                            'EDIT',
                                            style: TextStyle(
                                              color: Hexcolor('#00B6BC'),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      //Reset Password
                      GestureDetector(
                        onTap: () {
                          // Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePassword()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          color: Colors.white,
                          child: Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  size: 16,
                                  color: Hexcolor('#737373'),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Text(
                                  'RESET PASSWORD',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Hexcolor('#737373'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //About Us
                      GestureDetector(
                        onTap: () async {
                          var url = "https://www.guardini.in/";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          color: Colors.white,
                          child: Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Hexcolor('#737373'),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Text(
                                  'ABOUT US',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Hexcolor('#737373'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Privacy Policy
                      GestureDetector(
                        onTap: () {
                          showAboutDialog(
                              context: context,
                              applicationVersion: "1.0.0",
                              applicationIcon: Image.asset(
                                "assets/logo-white.png",
                                height: 50,
                                width: 50,
                              ));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          color: Colors.white,
                          child: Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.vpn_key,
                                  size: 16,
                                  color: Hexcolor('#737373'),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Text(
                                  'PRIVACY POLICY',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Hexcolor('#737373'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Logout
                      GestureDetector(
                        onTap: () {
                          logout();
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          color: Colors.white,
                          child: Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.exit_to_app,
                                  size: 16,
                                  color: Hexcolor('#737373'),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Text(
                                  'LOGOUT',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Hexcolor('#737373'),
                                  ),
                                ),
                              ],
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
