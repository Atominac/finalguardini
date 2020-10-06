// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:guardini/orderrating.dart';
import 'package:guardini/outlets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'addItems.dart';
import 'items.dart';
import 'notifications.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  var mobile, email, status;
  String name;
  var address;
  var outlets;
  var disp;
  List finaloutlets = new List();

  final TextEditingController t1 = new TextEditingController(text: "");

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchpromos();
    fetchbanner();
    getdetails();
    getlocation();
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
  search() async {
    outlets = null;
    setState(() {});
    final user = await SharedPreferences.getInstance();
    print({"masterhash": user.getString('masterhash'), "search": t1.text});
    //  return 0;
    final String url =
        "http://34.93.1.41/guardini/public/listing.php/outlet/search";
    var response = await http.post(
        //encode url
        Uri.encodeFull(url),
        headers: {"accept": "application/json"},
        body: {"masterhash": user.getString('masterhash'), "search": t1.text});
    //print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      flag = 1;
      setState(() {
        outlets = jsondecoded["data"];
      });
      // sortoutlets(outlets);
      print(outlets.length);
    } else if (jsondecoded['message'] == "no_outlet_found") {
      showsnack("Nn results found. Fetching nearest outlets");
      // flag = 1;
      fetchoutlets();
      setState(() {});
    } else {
      showsnack("Some error has ouccered");
    }
  }

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
      showsnack("Some error has occured");
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

  var outletname = "";
  getdetails() async {
    final user = await SharedPreferences.getInstance();
    name = user.getString("fullname");
    mobile = user.getString("mobileno");
    email = user.getString("email");
    outletname = user.getString("outletname");
    setState(() {
      status = "1"; // data is loaded
    });
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

  var flag1 = 0;

  List promo = [];
  fetchpromos() async {
    final String url =
        "http://34.93.1.41/guardini/public/offers.php/offers/promos";
    var response = await http.get(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
    );
    ////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      for (var x in jsondecoded["data"]) {
        print(x["imageurl"]);

        promo.add(
          NetworkImage(x["imageurl"]),
        );
      }
      flag1 = 1;
      setState(() {});
    } else if (jsondecoded['message'] == "no_promos_found") {
      showsnack("No promos available");
    } else {
      showsnack("Some error has ouccered");
    }
  }

  List banner = [];
  var bannerflag = 0;
  fetchbanner() async {
    final String url =
        "http://34.93.1.41/guardini/public/listing.php/user/banner";
    var response = await http.get(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
    );
    ////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      for (var x in jsondecoded["data"]) {
        print(x["imageurl"]);

        banner.add(
          NetworkImage(x["imageurl"]),
        );
      }
      bannerflag = 1;
      setState(() {});
    } else if (jsondecoded['message'] == "no_banner_found") {
      showsnack("No promos available");
    } else {
      showsnack("Some error has ouccered");
    }
  }

  showsnack(String message) {
    //////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scafoldkey.currentState.showSnackBar(snackBar);
  }

  List<String> gridImages = [
    'assets/accessories.png',
    'assets/lehenga.png',
    'assets/outfits.png',
    'assets/shirt.png',
    'assets/trousers.png',
    'assets/upholestry.png',
  ];
  List<String> itemName = [
    'Accessories',
    'Lehenga',
    'Outfits',
    'Shirt',
    'Trousers',
    'Upholestry',
  ];

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String firstName = name;
    return Scaffold(
      backgroundColor: Hexcolor('#EFE9E0'),
      key: _scafoldkey,
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                color: Hexcolor('#219251'),
                child: Column(
                  children: <Widget>[
                    //"Hi, "user
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: ClipOval(
                              child: Image.asset(
                                "assets/newuser.png",
                                fit: BoxFit.cover,
                                width: (10 / 100) * size.width,
                                height: (10 / 100) * size.width,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(
                              'Hi, $firstName',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    //"Your location"
                    Container(
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
                    //location display area
                    Container(
                      child: Container(
                        // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: size.width * 0.7,
                                margin: EdgeInsets.all(5),
                                child: Text(
                                  outletname == null ? "" : outletname,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                  'Change',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Hexcolor('#ABEDE6'),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Outlets()),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              flag1 == 0
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  //Carousel
                  : Container(
                      color: Colors.white,
                      // width: size.width - 100,
                      height: size.shortestSide * 0.49,
                      margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                      padding: EdgeInsets.fromLTRB(16, 20, 16, 30),
                      child: Container(
                        // height: 200.0,
                        // width: 300.0,
                        child: Carousel(
                          images: promo,
                          showIndicator: true,
                          dotBgColor: Colors.transparent,
                          dotColor: Colors.grey[400],
                          dotIncreasedColor: Colors.amber,
                          dotHorizontalPadding: 5,
                          dotIncreaseSize: 1.1,
                          dotSpacing: 15,
                          dotSize: 6,
                          dotVerticalPadding: -10,
                        ),
                      ),
                    ),
              //GridView
              Container(
                height: 420,
                color: Colors.white,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width * 0.75,
                      child: Text(
                        'Drycleaning services for a wide range of options!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: size.width * 0.75,
                      margin: EdgeInsets.only(top: 5, bottom: 30),
                      child: Text(
                        'Choose a category to add garments to your basket',
                        style: TextStyle(
                          color: Hexcolor('#737373'),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 30,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: gridImages.length,
                        itemBuilder: (BuildContext context, int index) =>
                            Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                height: 100,
                                color: Hexcolor('#EFE9E0'),
                                child: Container(
                                  // color: Colors.amber,
                                  padding: EdgeInsets.all(10),
                                  // height: 10,
                                  // width: 10,
                                  child: Image.asset(
                                    gridImages[index],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddItems(),
                                  ),
                                );
                              },
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 3),
                              alignment: Alignment.center,
                              child: Text(
                                itemName[index],
                                style: TextStyle(
                                  fontSize: 12,
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
              //Other outlets
              Container(
                child: flag == 0
                    ? Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Image.asset("assets/noitems.png"),
                      )
                    : outlets == null
                        ? Center(
                            child: Center(
                              child: Text('Items'),
                            ),
                            // child: CircularProgressIndicator(),
                          )
                        : Container(
                            height: size.longestSide * 0.6,
                            color: Colors.white,
                            margin: EdgeInsets.only(top: 10, bottom: 0),
                            padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //"Other Guardini outlets near you"
                                Container(
                                  width: size.width,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Other Guardini outlets near you',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                //'We provide free pickup and delivery'
                                Container(
                                  width: size.width,
                                  margin: EdgeInsets.only(top: 5, bottom: 30),
                                  child: Text(
                                    'We provide free pickup and delivery',
                                    style: TextStyle(
                                      color: Hexcolor('#737373'),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 3,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          print(outlets[index]["geolocation"]);
                                          var x = getdist(
                                              outlets[index]["geolocation"]);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Items(
                                                  x == "null"
                                                      ? "0"
                                                      : getdist(outlets[index]
                                                          ["geolocation"]),
                                                  outlets[index]["locality"],
                                                  outlets[index]
                                                      ["workinghours"],
                                                  outlets[index]["workingdays"],
                                                  outlets[index]["id"],
                                                  outlets[index]["imageurl"]),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  //Outlet Image
                                                  Row(
                                                    children: [
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
                                                                outlets[index][
                                                                    "imageurl"],
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
                                                              width:
                                                                  size.width *
                                                                      0.45,
                                                              child: Text(
                                                                outlets[index][
                                                                    "locality"],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
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
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 8,
                                                                      bottom:
                                                                          16),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            3),
                                                                    decoration: BoxDecoration(
                                                                        color: Hexcolor(
                                                                            '#219251'),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20)),
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
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            3),
                                                                    decoration: BoxDecoration(
                                                                        color: Hexcolor(
                                                                            '#219251'),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20)),
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
                                                                    'DDA Complex, Rd Number 4, Sector 2, Shanti Niketan, New Delhi, Delhi 110021',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  fetchdist != 1
                                                      ? Container()
                                                      : Container(
                                                          margin:
                                                              EdgeInsets.all(3),
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
                                              child: index < 2
                                                  ? Divider(
                                                      thickness: 0.2,
                                                      color: Colors.black,
                                                    )
                                                  : Container(),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
              ), //View all outlets button
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
                margin: EdgeInsets.only(bottom: 10),
                color: Colors.white,
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: Hexcolor('FFEDC2'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Outlets(),
                      ),
                    );
                  },
                  elevation: 0,
                  child: Text(
                    'View all outlets',
                  ),
                ),
              ),
              //Testimonial
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 16, bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //"What our customers are saying"
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 24, 16, 24),
                      child: Text(
                        'What our customers are saying',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 190,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Row(
                            children: [
                              Container(
                                color: Color.fromRGBO(171, 237, 230, 0.5),
                                padding: EdgeInsets.only(right: 16),
                                margin: EdgeInsets.only(right: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 25, bottom: 15, left: 16),
                                      child:
                                          Image.asset('assets/quote_icon.png'),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(16, 0, 16, 16),
                                      width: size.shortestSide * 0.5,
                                      child: Text(
                                        'Amazing services. Personalized and good standards for drycleaning. Fully satisfied',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            height: 1.5),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(16, 0, 16, 16),
                                      width: size.shortestSide * 0.5,
                                      child: Text(
                                        '- Mr & Mrs John Doe',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            height: 1.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Color.fromRGBO(171, 237, 230, 0.5),
                                padding: EdgeInsets.only(right: 16),
                                margin: EdgeInsets.only(right: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 25, bottom: 15, left: 16),
                                      child:
                                          Image.asset('assets/quote_icon.png'),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(16, 0, 16, 16),
                                      width: size.shortestSide * 0.5,
                                      child: Text(
                                        'Amazing services. Personalized and good standards for drycleaning. Fully satisfied',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            height: 1.5),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(16, 0, 16, 16),
                                      width: size.shortestSide * 0.5,
                                      child: Text(
                                        '- Mr & Mrs John Doe',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            height: 1.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Color.fromRGBO(171, 237, 230, 0.5),
                                padding: EdgeInsets.only(right: 16),
                                margin: EdgeInsets.only(right: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 25, bottom: 15, left: 16),
                                      child:
                                          Image.asset('assets/quote_icon.png'),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(16, 0, 16, 16),
                                      width: size.shortestSide * 0.5,
                                      child: Text(
                                        'Amazing services. Personalized and good standards for drycleaning. Fully satisfied',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            height: 1.5),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(16, 0, 16, 16),
                                      width: size.shortestSide * 0.5,
                                      child: Text(
                                        '- Mr & Mrs John Doe',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            height: 1.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              bannerflag == 0
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  //Banner
                  : Container(
                      margin: EdgeInsets.only(top: 10),
                      child: SizedBox(
                        height: 520.0,
                        child: Carousel(
                          images: banner,
                          showIndicator: false,
                        ),
                      ),
                    ),
            ],
          ),
          Container(
            color: Hexcolor('#219251'),
            height: MediaQuery.of(context).padding.top,
          )
        ],
      ),
    );
  }
}
