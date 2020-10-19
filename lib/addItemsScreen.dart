import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:guardini/addItems.dart';
import 'package:guardini/appupdate.dart';
import 'package:guardini/contactsupport.dart';
import 'package:guardini/maintenance.dart';
import 'package:guardini/orders.dart';
import 'package:guardini/outlets.dart';
import 'package:guardini/profile.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'home.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'orderrating.dart';
import 'package:package_info/package_info.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class AddItemsScreen extends StatefulWidget {
  var tab;
  AddItemsScreen(this.tab);
  @override
  _AddItemsScreenState createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = new TabController(length: 3, vsync: this);
    // appinfo();
    // start();
  }

 
  // appinfo() async{
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   String versionName = packageInfo.version;
  //   String versionCode = packageInfo.buildNumber;
  //   print(versionCode);
  // }




  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

 

 

  showsnack(String message) {
    //////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scafoldkey.currentState.showSnackBar(snackBar);
  }

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();

  Future<bool> _leave() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to exit? '),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  exit(0);
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _leave();
      },
      child: Scaffold(
        key: _scafoldkey,
        body: TabBarView(
          children: <Widget>[
            AddItems(0),
            Orders(),
            Profile(),
          ],
          controller: tabController,
        ),
        bottomNavigationBar: new Material(
          child: TabBar(
            labelColor: Color.fromRGBO(38, 179, 163, 1),
            controller: tabController,
            tabs: <Widget>[
              Tab(
                child: Container(
                  height: 100.0,
                  padding: EdgeInsets.all(0.0),
                  child: Column(
                    children: <Widget>[
                      // SvgPicture.asset('assets/icons/home_icon.svg'),
                      Text(
                        "Home",
                      ),
                    ],
                  ),
                ),
              ),
              Tab(
                  child: Container(
                      height: 100.0,
                      padding: EdgeInsets.all(0.0),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            LineAwesomeIcons.list,
                          ),
                          Text("Orders")
                        ],
                      ))),
              Tab(
                child: Container(
                  height: 100.0,
                  padding: EdgeInsets.all(00.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                      ),
                      Text("Profile")
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
