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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Hexcolor('#EFE9E0'),
          key: _scafoldkey,
          body: Stack(
            children: [
              ListView(
                children: <Widget>[
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                    color: Hexcolor('#219251'),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomeScreen(),
                                        ));
                                  },
                                ),
                              ),
                              Container(
                                child: Text(
                                  'All Outlets',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        //"Your location"
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          margin: EdgeInsets.only(top: 22),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.white.withOpacity(0.8),
                                size: 14,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 3),
                                child: Text(
                                  'Your Location',
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
                        //location display area
                        Container(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text(
                                      address == null
                                          ? disp
                                          : address.substring(0, 27) + "...",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          print(outlets[index]["geolocation"]);
                                          var x = getdist(
                                              outlets[index]["geolocation"]);
                                          final user = await SharedPreferences
                                              .getInstance();
                                          user.setString(
                                              "outletid", outlets[index]["id"]);
                                          user.setString("outletname",
                                              outlets[index]["name"]);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen()),
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
                                                      margin: EdgeInsets.only(
                                                          right: 16),
                                                      child: outlets[index]
                                                                  [
                                                                  "imageurl"] ==
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Container(
                                                            // margin: EdgeInsets.only(
                                                            //     bottom: 8,),
                                                            child: Text(
                                                              outlets[index][
                                                                              "locality"]
                                                                          .length >
                                                                      20
                                                                  ? outlets[index]
                                                                              [
                                                                              "locality"]
                                                                          .substring(
                                                                              0,
                                                                              17) +
                                                                      "..."
                                                                  : outlets[
                                                                          index]
                                                                      [
                                                                      "locality"],
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                          //Chips
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 8,
                                                                    bottom: 16),
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
                                                                          BorderRadius.circular(
                                                                              20)),
                                                                  child: Text(
                                                                    outlets[index]
                                                                        [
                                                                        "workingdays"],
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              8),
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
                                                                          BorderRadius.circular(
                                                                              20)),
                                                                  child: Text(
                                                                    outlets[index]
                                                                        [
                                                                        "workinghours"],
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
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
                                                                Icons
                                                                    .location_on,
                                                                size: 20,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              Container(
                                                                width:
                                                                    size.width *
                                                                        0.4,
                                                                child: Text(
                                                                  outlets[
                                                                              index]
                                                                          [
                                                                          "address1"] +
                                                                      ", " +
                                                                      outlets[index]
                                                                          [
                                                                          "address2"] +
                                                                      ", " +
                                                                      outlets[index]
                                                                          [
                                                                          "locality"] +
                                                                      ", " +
                                                                      outlets[index]
                                                                          [
                                                                          "province"] +
                                                                      ", " +
                                                                      outlets[index]
                                                                          [
                                                                          "country"] +
                                                                      ", " +
                                                                      outlets[index]
                                                                          [
                                                                          "postcode"],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
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
                                                            margin:
                                                                EdgeInsets.all(
                                                                    3),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .subdirectory_arrow_right,
                                                                  size: 15,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          28,
                                                                          147,
                                                                          85,
                                                                          1),
                                                                ),
                                                                Text(
                                                                  " " +
                                                                      getdist(outlets[
                                                                              index]
                                                                          [
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
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
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
              Container(
                color: Hexcolor('#145730'),
                height: 24,
              )
            ],
          ),
        ),
      ),
    );

//     return Scaffold(
//       key: _scafoldkey,
//       body: Container(
//         margin: EdgeInsets.all(10),
//         child: Column(
//           children: <Widget>[
//             Container(
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(240, 248, 255, 1),
//               ),
//               child: SizedBox(
//                 height: 100,
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   color: Color.fromRGBO(253, 186, 37, 1),
//                   child: Card(
//                     margin: EdgeInsetsDirectional.only(bottom: 5),
//                     child: Container(
//                       padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             child: Text(
//                               "Your location",
//                               style: TextStyle(
//                                   fontSize: 17,
//                                   color: Colors.black87,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           ),
//                           Container(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Row(
//                                   children: <Widget>[
//                                     Container(
//                                         child: Icon(
//                                       Icons.location_on,
//                                       color: Colors.red,
//                                     )),
//                                     Container(
//                                       margin: EdgeInsets.all(5),
//                                       child: Text(
//                                         address == null
//                                             ? disp
//                                             : address.substring(0, 27) + "...",
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             color: Colors.black87,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 //   Container(
//                                 //     child: Icon(
//                                 //       Icons.edit,
//                                 //       color: Color.fromRGBO(28, 147, 85, 1),
//                                 //     ),
//                                 //   ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(top: 10, bottom: 10),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Choose Outlet",
//                   style: TextStyle(
//                       fontSize: 17,
//                       color: Colors.black87,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             SizedBox(
//                 height: 40,
//                 child: Row(
//                   children: [
//                     Container(
//                       width: (80 / 100) * size.width,
//                       child: TextFormField(
//                         decoration: new InputDecoration(
//                           hintText: "Search",
//                           border: new OutlineInputBorder(
//                             borderRadius: const BorderRadius.all(
//                               const Radius.circular(5.0),
//                             ),
//                           ),
//                         ),
//                         keyboardType: TextInputType.text,
//                         controller: t1,
//                         onChanged: (value) {
// // _onChangeHandler(value);
//                           // setState(() {});
//                         },
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(left: 5),
//                       child: SizedBox(
//                         width: (12 / 100) * size.width,
//                         child: RaisedButton(
//                             onPressed: () {
//                               search();
//                             },
//                             color: Color.fromRGBO(38, 179, 163, 1),
//                             padding: EdgeInsets.all(2.0),
//                             child: Icon(
//                               Icons.search,
//                               color: Colors.white,
//                             )),
//                       ),
//                     )
//                   ],
//                 )),
//             Expanded(
//               child: flag == 0
//                   ? Column(
//                       children: [
//                         Container(
//                             margin: EdgeInsets.only(top: 10),
//                             child: Image.asset("assets/noitems.png"))
//                       ],
//                     )
//                   : outlets == null
//                       ? Center(
//                           child: CircularProgressIndicator(),
//                         )
//                       : Container(
//                           margin: EdgeInsets.only(top: 10),
//                           child: GridView.builder(
//                             itemCount: outlets.length,
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 2,
//                                     childAspectRatio: (itemWidth / itemHeight)),
//                             itemBuilder: (BuildContext context, int index) {
//                               return GestureDetector(
//                                 onTap: () async {
//                                   print(outlets[index]["geolocation"]);
//                                   var x =
//                                       getdist(outlets[index]["geolocation"]);
//                                   final user =
//                                       await SharedPreferences.getInstance();
//                                   user.setString(
//                                       "outletid", outlets[index]["id"]);
//                                   user.setString(
//                                       "outletname", outlets[index]["name"]);

//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => HomeScreen()),
//                                   );
//                                   // Navigator.push(
//                                   //     context,
//                                   //     MaterialPageRoute(
//                                   //         builder: (context) => Items(
//                                   //             x == "null"
//                                   //                 ? "0"
//                                   //                 : getdist(outlets[index]
//                                   //                     ["geolocation"]),
//                                   //             outlets[index]["locality"],
//                                   //             outlets[index]["workinghours"],
//                                   //             outlets[index]["workingdays"],
//                                   //             outlets[index]["id"],
//                                   //             outlets[index]["imageurl"])));
//                                 },
//                                 child: Card(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   color: Color.fromRGBO(253, 186, 37, 1),
//                                   child: Card(
//                                     margin:
//                                         EdgeInsetsDirectional.only(bottom: 5),
//                                     shadowColor: Colors.transparent,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     color: Color.fromRGBO(255, 250, 232, 1),
//                                     child: Container(
//                                       child: Column(
//                                         children: <Widget>[
//                                           Container(
//                                               color: Colors.white,
//                                               margin: EdgeInsets.only(top: 0),
//                                               child: outlets[index]
//                                                           ["imageurl"] ==
//                                                       null
//                                                   ? Image.asset(
//                                                       "assets/logohd.png")
//                                                   : Image.network(
//                                                       outlets[index]
//                                                           ["imageurl"],
//                                                       height: 110,
//                                                       width: 200,
//                                                     )),
//                                           Container(
//                                               margin: EdgeInsets.fromLTRB(
//                                                   10, 10, 10, 0),
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: <Widget>[
//                                                   Container(
//                                                     margin: EdgeInsets.all(5),
//                                                     child: Text(
//                                                       outlets[index]["locality"]
//                                                                   .length >
//                                                               15
//                                                           ? outlets[index][
//                                                                       "locality"]
//                                                                   .substring(
//                                                                       0, 12) +
//                                                               "..."
//                                                           : outlets[index]
//                                                               ["locality"],
//                                                       style: TextStyle(
//                                                           fontSize: 15,
//                                                           color: Colors.black87,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                   ),
//                                                   //  Row(
//                                                   //   mainAxisAlignment: MainAxisAlignment.start,
//                                                   //   children: <Widget>[
//                                                   //     Icon(
//                                                   //       Icons.call,
//                                                   //       size: 15,
//                                                   //       color: Color.fromRGBO(28, 147, 85, 1),
//                                                   //     ),
//                                                   //     Text("7011502604")
//                                                   //   ],
//                                                   // ),

//                                                   Container(
//                                                     margin: EdgeInsets.all(5),
//                                                     child: Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .start,
//                                                       children: <Widget>[
//                                                         Icon(
//                                                           Icons.calendar_today,
//                                                           size: 15,
//                                                           color: Color.fromRGBO(
//                                                               28, 147, 85, 1),
//                                                         ),
//                                                         Text(
//                                                           "  " +
//                                                               outlets[index][
//                                                                   "workingdays"],
//                                                           style: TextStyle(
//                                                               fontSize: 13,
//                                                               color: Colors
//                                                                   .black54,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   fetchdist != 1
//                                                       ? Container()
//                                                       : Container(
//                                                           margin:
//                                                               EdgeInsets.all(3),
//                                                           child: Row(
//                                                             children: [
//                                                               Icon(
//                                                                 LineAwesomeIcons
//                                                                     .car,
//                                                                 size: 15,
//                                                                 color: Color
//                                                                     .fromRGBO(
//                                                                         28,
//                                                                         147,
//                                                                         85,
//                                                                         1),
//                                                               ),
//                                                               Text(
//                                                                 " " +
//                                                                     getdist(outlets[
//                                                                             index]
//                                                                         [
//                                                                         "geolocation"]) +
//                                                                     " Km",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .black54,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                   Container(
//                                                     margin: EdgeInsets.all(3),
//                                                     child: Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .start,
//                                                       children: <Widget>[
//                                                         Icon(
//                                                           Icons.watch_later,
//                                                           size: 15,
//                                                           color: Color.fromRGBO(
//                                                               28, 147, 85, 1),
//                                                         ),
//                                                         Text(
//                                                           "  " +
//                                                               outlets[index][
//                                                                   "workinghours"],
//                                                           style: TextStyle(
//                                                               fontSize: 13,
//                                                               color: Colors
//                                                                   .black54,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   )
//                                                 ],
//                                               )),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//             )
//           ],
//         ),
//       ),
//     );
  }
}
