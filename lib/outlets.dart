import 'package:flutter/material.dart';
import 'package:guardini/homescreen.dart';
import 'package:guardini/items.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';
import 'dart:async';

class Outlets extends StatefulWidget {
  @override
  _OutletsState createState() => _OutletsState();
}

class _OutletsState extends State<Outlets> {
  // final TextEditingController t1 = new TextEditingController(text: "");
  var mobile, email, status;
  var address;
  var outlets;
  var disp;
  List finaloutlets = new List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // start();
    getlocation();
    // stop();
    print("outlets");
  }

  var loc = 1;
  LocationData _locationData;
  var fetchdist = 1;
  getlocation() async {
    disp = "Fetching location";
    setState(() {});
    final user = await SharedPreferences.getInstance();

    Location location = new Location();
    print("get location");

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    print("get location");
    disp = "Asking for permission...";
    setState(() {});
    _serviceEnabled = await location.serviceEnabled();
    print(_serviceEnabled);

    if (!_serviceEnabled) {
      print("not enabled");
      disp = "Requesting permission...";
      setState(() {});

      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        fetchdist = 0;
        print("not location");
        setState(() {});
        loc = 0;
        fetchoutlets();
        disp = "Permission denied";
        setState(() {});

        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    print(_permissionGranted);
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        fetchdist = 0;
        setState(() {});
        fetchoutlets();
        loc = 0;
        disp = "Permission denied";
        setState(() {});
        return;
      }
    }
    print("location");
    disp = "Locating...";
    setState(() {});
    _locationData = await location.getLocation();
    fetchoutlets();
    print("location");
    print(_locationData.latitude);
    print(_locationData.longitude);
    user.setString(
        "coordinates",
        _locationData.latitude.toString() +
            "," +
            _locationData.longitude.toString());
    fetchadddress(_locationData.latitude, _locationData.longitude);
  }

  final Distance distance = new Distance();

  fetchadddress(lat, log) async {
    print("fetch address");
    disp = "Getting Address...";
    setState(() {});
    print(lat);
    print(log);
    final coordinates = new Coordinates(lat, log);
    address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      address = address.first.addressLine;
    });
    print(address);
    disp = "Getting nearest outlets...";
    setState(() {});
  }

  var flag = 1;
  // search() async {
  //   outlets = null;
  //   setState(() {});
  //   final user = await SharedPreferences.getInstance();
  //   print({"masterhash": user.getString('masterhash'), "search": t1.text});
  //   //  return 0;
  //   final String url =
  //       "http://34.93.1.41/guardini/public/listing.php/outlet/search";
  //   var response = await http.post(
  //       //encode url
  //       Uri.encodeFull(url),
  //       headers: {"accept": "application/json"},
  //       body: {"masterhash": user.getString('masterhash'), "search": t1.text});
  //   //print("login response"+response.body);
  //   var jsondecoded = json.decode(response.body);
  //   print(jsondecoded);

  //   if (jsondecoded['message'] == "success") {
  //     flag = 1;
  //     setState(() {
  //       outlets = jsondecoded["data"];
  //     });
  //     // sortoutlets(outlets);
  //     print(outlets.length);
  //   } else if (jsondecoded['message'] == "no_outlet_found") {
  //     showsnack("Nn results found. Fetching nearest outlets");
  //     // flag = 1;
  //     fetchoutlets();
  //     setState(() {});
  //   } else {
  //     showsnack("Some error has ouccered");
  //   }
  // }

  fetchoutlets() async {
    final String url =
        "http://34.93.1.41/guardini/public/listing.php/outlets/list";
    var response = await http.get(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
    );
    //print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      setState(() {
        outlets = jsondecoded["data"];
      });
      sortoutlets(outlets);
      print(outlets.length);
    } else {
      showsnack("Some error has ouccered");
    }
  }

  sortoutlets(outlets) {
    print("sort outlet");

    for (int i = 0; i < outlets.length; i++) {
      outlets[i]["dist"] = getdist(outlets[i]["geolocation"]);
    }

    for (int j = 0; j < outlets.length - 1; j++) {
      // Checking the condition for two
      // simultaneous elements of the array
      if (double.parse(outlets[j]["dist"]) >
          double.parse(outlets[j + 1]["dist"])) {
        // Swapping the elements.
        var temp = outlets[j];
        outlets[j] = outlets[j + 1];
        outlets[j + 1] = temp;

        // updating the value of j = -1
        // so after getting updated for j++
        // in the loop it becomes 0 and
        // the loop begins from the start.
        j = -1;
      }
    }

    finaloutlets = outlets;
  }

  getdist(location) {
    print("get dist");

    if (_locationData == null) {
      return "null";
    }
    var coordinates = location.split(",");
    final Distance distance = new Distance();
    print(coordinates[1]);
    // km = 423
    final double km = distance.as(
        LengthUnit.Kilometer,
        new LatLng(double.parse(coordinates[0]), double.parse(coordinates[1])),
        new LatLng(_locationData.latitude, _locationData.longitude));
    // print(km);
    return km.toString();
  }

  Timer searchOnStoppedTyping;

  _onChangeHandler(value) {
    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(() =>
        searchOnStoppedTyping = new Timer(duration, () => searchoutlet(value)));
  }

  searchoutlet(string) {
    print("search outlet");
    if (string.length == 0) {
      finaloutlets = outlets;
    }
    for (int i = 0; i < outlets.length; i++) {
      if (outlets[i]["address1"].indexOf(string) > -1) {
        finaloutlets.add(outlets[i]);
      }
    }

    print(finaloutlets);
  }

  showsnack(String message) {
    ////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scafoldkey.currentState.showSnackBar(snackBar);
  }

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();
  var outletname = "";
  getdetails() async {
    final user = await SharedPreferences.getInstance();
    outletname = user.getString("outletname");
    setState(() {
      status = "1"; // data is loaded
    });
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      },
      child: Scaffold(
        backgroundColor: Hexcolor('#EFE9E0'),
        key: _scafoldkey,
        appBar: AppBar(
        title: Text("All Outlets"),
        backgroundColor: Hexcolor('#219251'),
      ),
        body: ListView(
          children: <Widget>[
            //Other outlets
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  outlets == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : outlets.isEmpty
                          ? Container(
                              margin: EdgeInsets.only(
                                top: 10,
                              ),
                              child: Image.asset("assets/noitems.png"),
                            )
                          :
                          //'We provide free pickup and delivery'
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: outlets.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () async {
                                    print(outlets[index]["geolocation"]);
                                    var x =
                                        getdist(outlets[index]["geolocation"]);
                                    final user =
                                        await SharedPreferences.getInstance();
                                    user.setString(
                                        "outletid", outlets[index]["id"]);
                                    user.setString(
                                        "outletname", outlets[index]["name"]);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()),
                                    );
                                  },
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //Outlet Image
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 16),
                                                child: outlets[index]
                                                            ["imageurl"] ==
                                                        null
                                                    ? Image.asset(
                                                        "assets/logohd.png")
                                                    : Image.network(
                                                        outlets[index]
                                                            ["imageurl"],
                                                        height: 70,
                                                        width: 70,
                                                      ),
                                              ),

                                              Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      // margin: EdgeInsets.only(
                                                      //     bottom: 8,),
                                                      child: Text(
                                                        outlets[index]["locality"]
                                                                    .length >
                                                                20
                                                            ? outlets[index][
                                                                        "locality"]
                                                                    .substring(
                                                                        0, 17) +
                                                                "..."
                                                            : outlets[index]
                                                                ["locality"],
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    //Chips
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 8, bottom: 16),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        3),
                                                            decoration: BoxDecoration(
                                                                color: Hexcolor(
                                                                    '#219251'),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            child: Text(
                                                              outlets[index][
                                                                  "workingdays"],
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8),
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        3),
                                                            decoration: BoxDecoration(
                                                                color: Hexcolor(
                                                                    '#219251'),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            child: Text(
                                                              outlets[index][
                                                                  "workinghours"],
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    //Outlet Address
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons.location_on,
                                                          size: 20,
                                                          color: Colors.green,
                                                        ),
                                                        Container(
                                                          width:
                                                              size.width * 0.4,
                                                          child: Text(
                                                            outlets[index][
                                                                    "address1"] +
                                                                ", " +
                                                                outlets[index][
                                                                    "address2"] +
                                                                ", " +
                                                                outlets[index][
                                                                    "locality"] +
                                                                ", " +
                                                                outlets[index][
                                                                    "province"] +
                                                                ", " +
                                                                outlets[index][
                                                                    "country"] +
                                                                ", " +
                                                                outlets[index][
                                                                    "postcode"],
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              fetchdist != 1
                                                  ? Container()
                                                  : Container(
                                                      margin: EdgeInsets.all(3),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .subdirectory_arrow_right,
                                                            size: 15,
                                                            color:
                                                                Color.fromRGBO(
                                                                    28,
                                                                    147,
                                                                    85,
                                                                    1),
                                                          ),
                                                          Text(
                                                            " " +
                                                                getdist(outlets[
                                                                        index][
                                                                    "geolocation"]) +
                                                                " Km",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Divider(
                                            thickness: 0.2,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
