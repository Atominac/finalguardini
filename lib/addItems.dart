// import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:guardini/ordersummary.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'cartScreen.dart';

class AddItems extends StatefulWidget {
  var tab;
  AddItems(this.tab);
  // String locality, workinhours, workingdays, outlet, distance, img;
  // AddItems(this.distance, this.locality, this.workinhours, this.workingdays,
  //     this.outlet, this.img);
  // AddItems();
  @override
  _AddItemsState createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> with TickerProviderStateMixin {
  var items;
// Map selecteditems = new Map<int, String>();
  var selecteditems;
  var selectedindex = [];
  var blank;
  var orderdetails;
  var totalprice = 0;
  var totalitems = 0;
  var pkgoption = 1;
  var tempitems = 0;
  final TextEditingController t1 = new TextEditingController(text: "");
  TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    start();
  }

  start() async {
    await fetchcategories();
    await fetchitems();
    tabController = TabController(
      vsync: this,
      length: categories.length + 1,
      initialIndex: widget.tab + 1,
    );
  }

  var categories;
  fetchcategories() async {
    final String url =
        "http://34.93.1.41/guardini/public/listing.php/orders/itemcategory";
    var response = await http.get(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
    );
    //////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    //print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      setState(() {
        categories = jsondecoded["data"];
      });
    } else {
      setState(() {});
      showsnack("No categories found");
    }
  }

  gettabs() {
    //print("categories start hui");
    //print(categories);

    List<Widget> children = new List<Widget>();
    children.add(Tab(
      text: 'All',
    ));
    for (var index = 0; index < categories.length; index++) {
      children.add(Tab(
        text: categories[index]["name"],
      ));
    }
    return children;
  }

  getitemtabs(size) {
    //print("categories start hui");
    //print(categories);

    List<Widget> children = new List<Widget>();
    List<Widget> majorchildren = new List<Widget>();

    // children.add(Tab(
    //   text: 'All',
    // ));

    for (var index = 0; index < selecteditems.length; index++) {
       if(items[index]["name"].toLowerCase().contains(t1.text.toLowerCase())){
      children.add(Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(1, 25, 79, 0.2),
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Hexcolor('#EFE9E0'),
              width: size.width * 0.4,
              margin: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      items[index]["imageurl"],
                      height: 80,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      height: 80,
                      child: Text(
                        items[index]["name"],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: size.width * 0.4,
              decoration: BoxDecoration(
                  border: Border.all(color: Hexcolor('#FFC233'), width: 1)),
              child: RaisedButton(
                color: Hexcolor('FFEDC2'),
                padding: EdgeInsets.symmetric(vertical: 16),
                onPressed: () {
                  tempitems = 0;
                  selectedservices = List<int>.generate(
                      selecteditems[index]["services"].length, (i) => 0);

                  //print(selecteditems[index].containsKey('paymenttype'));
                  //print(selectedservices);
                  // return;
                  if (selecteditems[index].containsKey('paymenttype')) {
                    for (var x = 0;
                        x < selecteditems[index]["paymenttype"].length;
                        x++) {
                      selectedservices[selecteditems[index]["paymenttype"]
                          [x]]++;
                      tempitems += 1;
                    }
                  }
                  //print(tempitems);
                  //print(selectedservices);
                  // return;
                  priceoption(
                      selecteditems[index]["name"],
                      selecteditems[index]["regularprice"],
                      selecteditems[index]["delicateprice"],
                      index,
                      "p");
                },
                elevation: 0,
                child: Text(
                  selecteditems[index]["count"] == null ||
                          selecteditems[index]["count"] == "0"
                      ? 'Add to basket'
                      : 'Edit',
                ),
              ),
            ),
          ],
        ),
      ));
     } }

    majorchildren.add(
      Stack(
        children: [
          Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
             child: Column(
              children: <Widget>[
                // Search bar
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left:12),
                        width: (90 / 100) * size.width,
                        child: TextFormField(
                          decoration: new InputDecoration(
                            hintText: "Search",
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(0.0),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          controller: t1,
                          onChanged: (value) {
                            print("yo");
                            setState(() {});
                          },
                        ),
                      ),
                      
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 60),
                    child: flag == 0
                        ? ListView(
                            children: [
                              Column(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Image.asset("assets/noitems.png"))
                                ],
                              )
                            ],
                          )
                        : items == null
                            ? Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : ListView(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showModal();
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 12, 0, 12),
                                      margin: EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 5,
                                          right: 5),
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(171, 237, 230, 0.4),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(0, 182, 188, 0.4),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "What is Green and Premium care?",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Hexcolor('#00B6BC'),
                                            height: 1.5),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.64,
                                    padding: EdgeInsets.only(bottom: 32),
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.64,
                                      children: children,
                                      mainAxisSpacing: 10,
                                    ),
                                  ),
                                ],
                              ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                //print(selecteditems);
                georderdetails();
              },
              child: Container(
                  height: 55,
                  padding: EdgeInsets.only(
                    left: 16,
                    top: 7,
                    right: 16,
                    bottom: 7,
                  ),
                  width: size.width,
                  color: Hexcolor('#FFC233'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "₹ " + "${totalprice}",
                                // "₹ " + totalprice.toString(),
                                style: TextStyle(
                                  color: Hexcolor('#252525'),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                ' (Estimated)',
                                style: TextStyle(
                                  color: Hexcolor('#404040'),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                          Text(
                            totalitems.toString() + " pieces",
                            style: TextStyle(
                              color: Hexcolor('#404040'),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "View Basket",
                            // "₹ " + totalprice.toString(),
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
                    ],
                  )),
            ),
          ),
        ],
      ),
    );

    for (var i = 0; i < categories.length; i++) {
      children = [];
      for (var index = 0; index < selecteditems.length; index++) {
        if (categories[i]["id"] == selecteditems[index]["categoryid"]) {
          print(items[index]["name"].contains(t1.text));
          if(items[index]["name"].toLowerCase().contains(t1.text.toLowerCase())){
            children.add(Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(1, 25, 79, 0.2),
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Hexcolor('#EFE9E0'),
                  width: size.width * 0.4,
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          items[index]["imageurl"],
                          height: 80,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          height: 80,
                          child: Text(
                            items[index]["name"],
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width * 0.4,
                  decoration: BoxDecoration(
                      border: Border.all(color: Hexcolor('#FFC233'), width: 1)),
                  child: RaisedButton(
                    color: Hexcolor('FFEDC2'),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    onPressed: () {
                      tempitems = 0;
                      selectedservices = List<int>.generate(
                          selecteditems[index]["services"].length, (i) => 0);

                      //print(selecteditems[index].containsKey('paymenttype'));
                      //print(selectedservices);
                      // return;
                      if (selecteditems[index].containsKey('paymenttype')) {
                        for (var x = 0;
                            x < selecteditems[index]["paymenttype"].length;
                            x++) {
                          selectedservices[selecteditems[index]["paymenttype"]
                              [x]]++;
                          tempitems += 1;
                        }
                      }
                      //print(tempitems);
                      //print(selectedservices);
                      // return;
                      priceoption(
                          selecteditems[index]["name"],
                          selecteditems[index]["regularprice"],
                          selecteditems[index]["delicateprice"],
                          index,
                          "p");
                    },
                    elevation: 0,
                    child: Text(
                      selecteditems[index]["count"] == null ||
                              selecteditems[index]["count"] == "0"
                          ? 'Add to basket'
                          : 'Edit',
                    ),
                  ),
                ),
              ],
            ),
          ));
       
          }
          }
      }

      majorchildren.add(
        Stack(
          children: [
            Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),

              child: Column(
                children: <Widget>[
                  //Search bar
                  SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left:12),
                        width: (90 / 100) * size.width,
                        child: TextFormField(
                          decoration: new InputDecoration(
                            hintText: "Search",
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(0.0),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          controller: t1,
                          onChanged: (value) {
                            print("yo");
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 60),
                      child: flag == 0
                          ? ListView(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child:
                                            Image.asset("assets/noitems.png"))
                                  ],
                                )
                              ],
                            )
                          : items == null
                              ? Container(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : ListView(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showModal();
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 12, 0, 12),
                                        margin: EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 5,
                                            right: 5),
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(
                                              171, 237, 230, 0.4),
                                          border: Border.all(
                                            color: Color.fromRGBO(
                                                0, 182, 188, 0.4),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "What is premium and regular wash?",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Hexcolor('#00B6BC'),
                                              height: 1.5),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: size.height * 0.64,
                                      padding: EdgeInsets.only(bottom: 32),
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: GridView.count(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.64,
                                        children: children,
                                        mainAxisSpacing: 10,
                                      ),
                                    ),
                                  ],
                                ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  //print(selecteditems);
                  georderdetails();
                },
                child: Container(
                    height: 55,
                    padding: EdgeInsets.only(
                      left: 16,
                      top: 7,
                      right: 16,
                      bottom: 7,
                    ),
                    width: size.width,
                    color: Hexcolor('#FFC233'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "₹ " + "${totalprice}",
                                  // "₹ " + totalprice.toString(),
                                  style: TextStyle(
                                    color: Hexcolor('#252525'),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  ' (Estimated)',
                                  style: TextStyle(
                                    color: Hexcolor('#404040'),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              totalitems.toString() + " pieces",
                              style: TextStyle(
                                color: Hexcolor('#404040'),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "View Basket",
                              // "₹ " + totalprice.toString(),
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
                      ],
                    )),
              ),
            ),
          ],
        ),
      );
    }

    return TabBarView(
      controller: tabController,
      children: majorchildren,
    );
  }

  int _radioValue = 0;
  var _result = 0;
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _result = 1;
          pkgoption = _result;
          // deliveryprice = 50;
          // var totalamount = 0;
          // var tax = 0.0;
          // totalamount = orderdetails["price"];
          // tax = ((18 / 100) * totalamount);
          // orderdetails["deliverytype"] = "1";
          // orderdetails["tax"] = tax.round();
          // orderdetails["deliveryprice"] = deliveryprice;
          // orderdetails["totalprice"] =
          //     orderdetails["price"] + tax.round() + deliveryprice;

          break;
        case 1:
          _result = 2;
          pkgoption = _result;

          break;
        case 2:
          _result = 3;
          pkgoption = _result;

          break;
      }
      setState(() {});

      //print(_result);
      return;
    });
  }

  var flag = 1;

  fetchitems() async {
    final String url =
        "http://34.93.1.41/guardini/public/listing.php/items/listnew";
    var response = await http.get(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
    );
    //////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    //print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      setState(() {
        items = jsondecoded["data"];
        selecteditems = items;
        blank = items;
        for (var i = 0; i < items.length; i++) {}
      });
    } else {
      setState(() {});
      showsnack("No items found");
    }
  }

  search() async {
    items = null;
    setState(() {});
    final user = await SharedPreferences.getInstance();
    final String url =
        "http://34.93.1.41/guardini/public/listing.php/item/search";
    var response = await http.post(
        //encode url
        Uri.encodeFull(url),
        headers: {"accept": "application/json"},
        body: {"masterhash": user.getString('masterhash'), "search": t1.text});
    ////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    //print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      flag = 1;
      setState(() {
        items = jsondecoded["data"];
      });
      // sortoutlets(outlets);
      //print(items.length);
    } else if (jsondecoded['message'] == "no_item_found") {
      flag = 0;
      showsnack("No items found");
    } else {
      showsnack("Some error has ouccered");
    }
  }

  var category = [0, 0, 0]; //[2,3]
  additems(index) {
    //print(category);
    //print("category");

    selecteditems[index]["count"] = 0.toString();
    //print("category");

    selecteditems[index]["paymenttype"] = [];

    for (var x = 0; x < selectedservices.length; x++) {
      itemdialogue = selectedservices[x];
      itemcount(index, "p", x);
    }

    tempitems = 0;
  }

  itemcount(index, action, pricetype) {
    //print("price type=" + pricetype.toString());
    // return;
    var price;
    selecteditems[index]["packgingtype"] = pkgoption;

    //print("hey yo bitch");
    // //print(selecteditems[index]["services"][pricetype]["price"]);
    price = selecteditems[index]["services"][pricetype]["price"];
    //print(price);
    // return;
    price = int.parse(price);
    if (action == "p") {
      if (itemdialogue == 1) {
        if (selecteditems[index].containsKey('count')) {
          var count = int.parse(selecteditems[index]["count"]);
          count = count + 1;
          selecteditems[index]["count"] = count.toString();
          if (selectedindex.contains(index)) {
          } else {
            selectedindex.add(index);
          }
        } else {
          selecteditems[index]["count"] = "1";
          if (selectedindex.contains(index)) {
          } else {
            selectedindex.add(index);
          }
        }
        totalitems += 1;
        //print("price");
        totalprice += int.parse(price.toString());
        //print("price");

        // var ptype={"ptype":pricetype};
        if (selecteditems[index]["paymenttype"] == null) {
          selecteditems[index]["paymenttype"] = [pricetype];
        } else {
          selecteditems[index]["paymenttype"].add(pricetype);
        }
      } else {
        for (int z = 0; z < itemdialogue; z++) {
          if (selecteditems[index].containsKey('count')) {
            var count = int.parse(selecteditems[index]["count"]);
            count = count + 1;
            selecteditems[index]["count"] = count.toString();
            if (selectedindex.contains(index)) {
            } else {
              selectedindex.add(index);
            }
          } else {
            selecteditems[index]["count"] = "1";
            if (selectedindex.contains(index)) {
            } else {
              selectedindex.add(index);
            }
          }
          totalitems += 1;
          //print("here");
          totalprice += price;
          //print("here");

          // var ptype={"ptype":pricetype};
          if (selecteditems[index]["paymenttype"] == null) {
            selecteditems[index]["paymenttype"] = [pricetype];
          } else {
            selecteditems[index]["paymenttype"].add(pricetype);
          }
        }
      }
      itemdialogue = 1;
    }

    //print(selecteditems);
    // return;
    // if (action == "m") {
    //   if (selecteditems[index].containsKey('count')) {
    //     var count = int.parse(selecteditems[index]["count"]);
    //     if (count < 1) {
    //       selecteditems[index]["count"] = "0";
    //       //  totalitems = totalitems-count;
    //     } else {
    //       totalitems = totalitems - count;
    //       count = count - 1;
    //       totalitems = totalitems + count;
    //       // totalprice -= price;
    //       if (selecteditems[index]["paymenttype"].last == 1) {
    //         totalprice -= int.parse(selecteditems[index]["regularprice"]);
    //       } else if (selecteditems[index]["paymenttype"].last == 2) {
    //         totalprice -= int.parse(selecteditems[index]["delicateprice"]);
    //       }
    //       selecteditems[index]["paymenttype"].removeLast();
    //       selecteditems[index]["count"] = count.toString();
    //     }
    //     if (count < 1) {
    //       selectedindex.remove(index);
    //     }
    //   }
    //   // totalitems-=1;

    // }

    var tempprice = 0;
    var temptotalcount = 0;
    for (int i = 0; i < selectedindex.length; i++) {
      var paymenttype = selecteditems[selectedindex[i]]["paymenttype"];
      //print(paymenttype.length);
      for (int j = 0; j < paymenttype.length; j++) {
        var price;
        // if (paymenttype[j] == 0) {
        //   price = selecteditems[selectedindex[i]]["regularprice"];
        // } else if (paymenttype[j] == 1) {
        //   price = selecteditems[selectedindex[i]]["delicateprice"];
        // } else if (paymenttype[j] == 2) {
        //   price = selecteditems[selectedindex[i]]["premiumpressing"];
        // }
        price = selecteditems[selectedindex[i]]["services"][paymenttype[j]]
            ["price"];
        // price = selecteditems[index]["services"][pricetype]["price"];
        //print(price);
        // return;

        //print("object");
        temptotalcount += 1;
        //print(price);
        tempprice += int.parse(price);
        //print("object yeh");
      }
    }
    totalprice = tempprice;
    totalitems = temptotalcount;
    setState(() {
      //print("hey" + selecteditems[index]["count"].toString());
      //print("yo" + selectedindex.toString());
    });

    //print(selecteditems);
  }

  georderdetails() async {
    blank = [];
    var item;
    final user = await SharedPreferences.getInstance();

    // //print("bdy");
    // //print(orderdetails["outlet"]);

    // return;
    var flag = 0;
    for (int i = 0; i < selectedindex.length; i++) {
      var paymenttype = selecteditems[selectedindex[i]]["paymenttype"];
      // //print(paymenttype.length);
      for (int j = 0; j < paymenttype.length; j++) {
        var price;
        // if (paymenttype[j] == 0) {
        //   price = selecteditems[selectedindex[i]]["regularprice"];
        // } else if (paymenttype[j] == 1) {
        //   price = selecteditems[selectedindex[i]]["delicateprice"];
        // } else if (paymenttype[j] == 2) {
        //   price = selecteditems[selectedindex[i]]["premiumpressing"];
        // }

        price = selecteditems[selectedindex[i]]["services"][paymenttype[j]]
            ["price"];
        price = int.parse(price);

        item = {
          "id": selecteditems[selectedindex[i]]["id"],
          "name": selecteditems[selectedindex[i]]["name"],
          "price": price,
          "imgurl": selecteditems[selectedindex[i]]["imageurl"],
          "type": selecteditems[selectedindex[i]]["services"][paymenttype[j]]
              ["service_id"],
          "servicename": selecteditems[selectedindex[i]]["services"]
              [paymenttype[j]]["name"],
          "packagingoption": selecteditems[selectedindex[i]]["packgingtype"]
        };
        // //print("item");
        // //print(item);
        blank.add(item);
        // //print(blank);
        flag++;
      }
    }
    // //print(blank);
    orderdetails = item;
    orderdetails = {};
    if (user.getString("outletid") == null) {
      showsnack("Something Went wrong");
    } else {
      orderdetails["outlet"] = user.getString("outletid");
    }
    orderdetails["quantity"] = totalitems;
    orderdetails["price"] = totalprice;
    orderdetails["totalprice"] = totalprice;
    orderdetails["items"] = blank;

    //print(orderdetails);
    // return;
    if (flag == 0) {
      showsnack('Please add items');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Cart(selecteditems, selectedindex, orderdetails,
              totalprice, totalitems),
        ),
      );
    }
  }

  var selectedservices;
  getlist(name, regular, delicate, index, action) {
    // double height=200* double.parse(items.length);
    // //print(selectedservices);
    List<Widget> children = new List<Widget>();
    for (var i = 0; i < selecteditems[index]["services"].length; i++) {
      // //print(selecteditems[index]["services"]);
      children.add(
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "₹ " + selecteditems[index]["services"][i]["price"],
                    style: TextStyle(
                      fontSize: 16,
                      color: Hexcolor('#595959'),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    selecteditems[index]["services"][i]["name"],
                    style: TextStyle(
                      fontSize: 12,
                      color: Hexcolor('#219251'),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      child: GestureDetector(
                        onTap: () {
                          if (selectedservices[i] < 2) {
                            selectedservices[i] = 0;
                          } else {
                            selectedservices[i] -= 1;
                          }
                          //print(selectedservices);

                          if (tempitems < 2) {
                            tempitems = 0;
                          } else {
                            tempitems -= 1;
                          }
                          //print("temp" + tempitems.toString());
                          Navigator.pop(context);
                          priceoption(name, regular, delicate, index, action);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(1),
                              border: Border.all(
                                width: 1,
                                color: Hexcolor('#B0B0B0'),
                              )),
                          child: Icon(
                            LineAwesomeIcons.minus,
                            color: Colors.grey,
                            size: (5 / 100) * MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                    Container(
                      child: Text(
                        selectedservices[i].toString(),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                    Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      child: GestureDetector(
                        onTap: () {
                          selectedservices[i] += 1;
                          tempitems += 1;
                          //print("cat" + selectedservices[i].toString());
                          //print(selectedservices);
                          Navigator.pop(context);
                          priceoption(name, regular, delicate, index, action);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Hexcolor('FFEDC2'),
                              borderRadius: BorderRadius.circular(1),
                              border: Border.all(
                                width: 1,
                                color: Hexcolor('#FFC233'),
                              )),
                          child: Icon(
                            Icons.add,
                            color: Hexcolor('#737373'),
                            size: (5 / 100) * MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AlertDialog(
      title: Container(
        // width: MediaQuery.of(context).size.width *0.7,
        // height: MediaQuery.of(context).size.height * 0.5,
        // margin: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${tempitems} items',
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Hexcolor('#D1D1D1'),
            )
          ],
        ),
      ),
      content: Container(
        height: 340,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  'Services',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Column(children: children
//yha pe ana hai

                  ),
              Divider(
                thickness: 1,
                color: Hexcolor('#D1D1D1'),
              ),
              Container(
                child: Text(
                  'Packaging option',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: (value) {
                        _handleRadioValueChange(value);
                        Navigator.pop(context);
                        priceoption(name, regular, delicate, index, action);
                      },
                      toggleable: true,
                    ),
                    Text(
                      'Hanger',
                      style: TextStyle(
                        fontSize: 12,
                        color: Hexcolor('#219251'),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: (value) {
                      _handleRadioValueChange(value);
                      Navigator.pop(context);
                      priceoption(name, regular, delicate, index, action);
                    },
                    toggleable: true,
                  ),
                  Text(
                    'Folded',
                    style: TextStyle(
                      fontSize: 12,
                      color: Hexcolor('#219251'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 2,
                    groupValue: _radioValue,
                    onChanged: (value) {
                      _handleRadioValueChange(value);
                      Navigator.pop(context);
                      priceoption(name, regular, delicate, index, action);
                    },
                  ),
                  Text(
                    'Folded with hanger',
                    style: TextStyle(
                      fontSize: 12,
                      color: Hexcolor('#219251'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text("Close"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        new FlatButton(
          child: new Text("Add"),
          onPressed: () {
            additems(index);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  int selectedradio;
  var itemdialogue = 1;
  void priceoption(name, regular, delicate, index, action) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return getlist(name, regular, delicate, index, action);
      },
    );
  }

  showsnack(String message) {
    ////////print(message);
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

  showModal() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 230,
          padding: EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Green Care',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(
                  'Our intelligent Dry Cleaning process using Bio-degradable Multi Solvent with Softners is smell free, give fresh look to your valuable Items.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              Text(
                'Premium Care',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(
                  'Introducing PREMIUM service to ensure top quality using specialised cleaning treatments & customised premium packing for your precious branded garments / Items.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Random r = new Random();
    int rnd = r.nextInt(6);
    var size = MediaQuery.of(context).size;
    var width = size.width;

    return DefaultTabController(
      length: categories == null ? 1 : categories.length + 1,
      child: SafeArea(
        child: Scaffold(
          key: _scafoldkey,
          appBar: AppBar(
            title: Text("Select items for drycleaning"),
            backgroundColor: Hexcolor('#219251'),
            bottom: TabBar(
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Hexcolor('#FFC233'),
              indicatorWeight: 4,
              isScrollable: true,
              tabs: categories == null
                  ? [
                      Tab(
                        text: "All",
                      )
                    ]
                  : gettabs(),
            ),
          ),
          backgroundColor: Colors.white,
          body: selecteditems == null ? Stack() : getitemtabs(size),
        ),
      ),
    );
  }
}
