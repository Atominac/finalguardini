import 'package:flutter/material.dart';
import 'package:guardini/ordersummary.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Items extends StatefulWidget {
  String locality, workinhours, workingdays, outlet, distance,img;
  Items(this.distance, this.locality, this.workinhours, this.workingdays,
      this.outlet,this.img);
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  var items;
// Map selecteditems = new Map<int, String>();
  var selecteditems;
  var selectedindex = [];
  var blank;
  var orderdetails;
  var totalprice = 0;
  
  var totalitems = 0;

  final TextEditingController t1 = new TextEditingController(text: "");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchitems();
    selectedradio = 0;
  }
  var flag=1;

  fetchitems() async {
    final String url =
        "http://34.93.1.41/guardini/public/listing.php/items/list";
    var response = await http.get(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
    );
    ////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      setState(() {
        items = jsondecoded["data"];
        selecteditems = items;
        blank = items;
      });
    } else {
      setState(() {
        
      });
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
    //print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      flag=1;
      setState(() {
        items = jsondecoded["data"];
      });
      // sortoutlets(outlets);
      print(items.length);
    } else if (jsondecoded['message'] == "no_item_found") {
       flag=0;
      showsnack("No items found");
    } else {
      showsnack("Some error has ouccered");
    }
  }

  itemcount(index, action, pricetype) {
    print(index);
    var price;
    if (pricetype == 1) {
      price = int.parse(selecteditems[index]["regularprice"]);
    } else {
      price = int.parse(selecteditems[index]["delicateprice"]);
    }

    if (action == "p") {
      if (itemdialogue == 1) {
        if (selecteditems[index].containsKey('count')) {
          var count = int.parse(selecteditems[index]["count"]);
          count = count + 1;
          selecteditems[index]["count"] = count.toString();
          if (selectedindex.contains(index)) {
            print(' is present in the list ');
          } else {
            selectedindex.add(index);
          }
        } else {
          selecteditems[index]["count"] = "1";
          if (selectedindex.contains(index)) {
            print(' is present in the list ');
          } else {
            selectedindex.add(index);
          }
        }
        totalitems += 1;
        totalprice += price;
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
              print(' is present in the list ');
            } else {
              selectedindex.add(index);
            }
          } else {
            selecteditems[index]["count"] = "1";
            if (selectedindex.contains(index)) {
              print(' is present in the list ');
            } else {
              selectedindex.add(index);
            }
          }
          totalitems += 1;
          totalprice += price;
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
    if (action == "m") {
      if (selecteditems[index].containsKey('count')) {
        var count = int.parse(selecteditems[index]["count"]);
        if (count < 1) {
          selecteditems[index]["count"] = "0";
          //  totalitems = totalitems-count;
        } else {
          totalitems = totalitems - count;
          count = count - 1;
          totalitems = totalitems + count;
          // totalprice -= price;
          if (selecteditems[index]["paymenttype"].last == 1) {
            totalprice -= int.parse(selecteditems[index]["regularprice"]);
          } else if (selecteditems[index]["paymenttype"].last == 2) {
            totalprice -= int.parse(selecteditems[index]["delicateprice"]);
          }
          selecteditems[index]["paymenttype"].removeLast();
          selecteditems[index]["count"] = count.toString();
        }
        if (count < 1) {
          selectedindex.remove(index);
        }
      }
      // totalitems-=1;

    }
    setState(() {
      print(selecteditems[index]["count"]);
      print(selectedindex);
    });
    print(selecteditems);
  }

  georderdetails() {
    blank = [];
    var item;

    print(selectedindex);
    for (int i = 0; i < selectedindex.length; i++) {
      var paymenttype = selecteditems[selectedindex[i]]["paymenttype"];
      print(paymenttype.length);
      for (int j = 0; j < paymenttype.length; j++) {
        var price;
        if (paymenttype[j] == 1) {
          price = selecteditems[selectedindex[i]]["regularprice"];
        } else if (paymenttype[j] == 2) {
          price = selecteditems[selectedindex[i]]["delicateprice"];
        }
        item = {
          "id": selecteditems[selectedindex[i]]["id"],
          "name": selecteditems[selectedindex[i]]["name"],
          "price": price,
          "imgurl": selecteditems[selectedindex[i]]["imageurl"],
          "type": paymenttype[j],
        };
        print("item");
        print(item);
        blank.add(item);
        print(blank);
      }
    }
    print(blank);
    orderdetails = item;
    orderdetails = {};
    orderdetails["quantity"] = totalitems;
    orderdetails["price"] = totalprice;
    orderdetails["outlet"] = widget.outlet;
    orderdetails["distance"] = widget.distance;
    orderdetails["totalprice"] = totalprice;
    orderdetails["items"] = blank;

    print(orderdetails);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderSummary(orderdetails)),
    );
  }

  int selectedradio;
  var itemdialogue = 1;
  void priceoption(regular, delicate, index, action) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            'Please select the type of wash',
            style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          content: Container(
            margin: EdgeInsets.only(top: 5),
            child: SizedBox(
              child: Column(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color.fromRGBO(253, 186, 37, 1)),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "No. of items",
                            style: TextStyle(
                                fontSize: (4 / 100) *
                                    MediaQuery.of(context).size.width,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                           width:
                                (6 / 100) * MediaQuery.of(context).size.width,
                            height:
                                (6 / 100) * MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              onPressed: () {
                                if (itemdialogue < 2) {
                                  itemdialogue = 1;
                                } else {
                                  itemdialogue -= 1;
                                }
                                Navigator.pop(context);
                                priceoption(regular, delicate, index, action);
                              },
                              color: Colors.white,
                              padding: EdgeInsets.all(2.0),
                              child: Icon(
                                LineAwesomeIcons.minus,
                                color: Colors.grey,
                                size: (4 / 100) *
                                    MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          Container(
                           width:
                                (6 / 100) * MediaQuery.of(context).size.width,
                            height:
                                (6 / 100) * MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(5.0),
                                  topRight: const Radius.circular(5.0),
                                  bottomLeft: const Radius.circular(5.0),
                                  bottomRight: const Radius.circular(5.0),
                                )),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(itemdialogue.toString(),style: TextStyle(fontSize: (4 / 100) *
                                    MediaQuery.of(context).size.width,),),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          Container(
                            width:
                                (6 / 100) * MediaQuery.of(context).size.width,
                            height:
                                (6 / 100) * MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              onPressed: () {
                                // itemcount(index, "p");
                                itemdialogue += 1;
                                Navigator.pop(context);
                                priceoption(regular, delicate, index, action);
                              },
                              color: Colors.white,
                              padding: EdgeInsets.all(2.0),
                              child: Icon(
                                Icons.add,
                                color: Colors.grey,
                                size: (4 / 100) *
                                    MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),
                        ],
                      )),
                  regular == "0"
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(253, 186, 37, 1)),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Regular Care",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "₹. " + regular,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Container(
                                width: 50,
                                child: RaisedButton(
                                  onPressed: () {
                                    itemcount(index, action, 1);
                                    Navigator.of(context).pop();
                                  },
                                  color: Color.fromRGBO(38, 179, 163, 1),
                                  padding: EdgeInsets.all(2.0),
                                  child: Text(
                                    "+ add",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  delicate == "0"
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(253, 186, 37, 1)),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Premium Care",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "₹. " + delicate,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Container(
                                width: 50,
                                child: RaisedButton(
                                  onPressed: () {
                                    itemcount(index, action, 2);
                                    Navigator.of(context).pop();
                                  },
                                  color: Color.fromRGBO(38, 179, 163, 1),
                                  padding: EdgeInsets.all(2.0),
                                  child: Text(
                                    "+ add",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showsnack(String message) {
    //////print(message);
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
  // var size = MediaQuery.of(context).size;
  //   var width = size.width;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;

    return Scaffold(
      key: _scafoldkey,
      appBar: AppBar(
        title: Text("Add Items"),
        backgroundColor: Color.fromRGBO(38, 179, 163, 1),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          georderdetails();
        },
        icon: Icon(Icons.arrow_forward),
        label: Text("next"),
        backgroundColor: Color.fromRGBO(38, 179, 163, 1),
      ),
      backgroundColor: Color.fromRGBO(240, 248, 255, 1),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Color.fromRGBO(253, 186, 37, 1),
                child: Card(
                  margin: EdgeInsetsDirectional.only(bottom: 5),
                  child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Image.network(
                                widget.img,
                                height: 50,
                                width: 50,
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 10, 10, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.all(5),
                                            child: Text(
                                              widget.locality,
                                              style: TextStyle(
                                                  fontSize: (5 / 100) * width,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          //  Row(
                                          //   mainAxisAlignment: MainAxisAlignment.start,
                                          //   children: <Widget>[
                                          //     Icon(
                                          //       Icons.call,
                                          //       size: 15,
                                          //       color: Color.fromRGBO(28, 147, 85, 1),
                                          //     ),
                                          //     Text("7011502604")
                                          //   ],
                                          // ),

                                          Container(
                                            margin: EdgeInsets.all(5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.calendar_today,
                                                  size: (4 / 100) * width,
                                                  color: Color.fromRGBO(
                                                      28, 147, 85, 1),
                                                ),
                                                Text(
                                                  "  " + widget.workingdays,
                                                  style: TextStyle(
                                                      fontSize:
                                                          (4 / 100) * width,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(3),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.watch_later,
                                                  size: (4 / 100) * width,
                                                  color: Color.fromRGBO(
                                                      28, 147, 85, 1),
                                                ),
                                                Text(
                                                  "  " + widget.workinhours,
                                                  style: TextStyle(
                                                      fontSize:
                                                          (4 / 100) * width,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              
                            ],
                          ),
                          Divider(color: Colors.grey),
                          GestureDetector(
                            onTap: () {
                              georderdetails();
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        LineAwesomeIcons.shopping_cart,
                                        size: 27,
                                      ),
                                      Text(
                                        totalitems.toString() + " item(s)",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "₹ " + totalprice.toString(),
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ),
            SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Container(
                      width: (80 / 100) * size.width,
                      child: TextFormField(
                        decoration: new InputDecoration(
                          hintText: "Search",
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(5.0),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        controller: t1,
                        onChanged: (value) {
// _onChangeHandler(value);
                          setState(() {});
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: SizedBox(
                        width: (12 / 100) * size.width,
                        child: RaisedButton(
                            onPressed: () {
                              // if(t1.text==""){
                              //   showsnack("enter a keyword");
                              // }else{

                              search();
                              // }
                            },
                            color: Color.fromRGBO(38, 179, 163, 1),
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            )),
                      ),
                    )
                  ],
                )),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  "All items",
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: flag == 0
                  ? ListView(
                    children: [
                      Column(
                      children: [Container(margin: EdgeInsets.only(top:10),child: Image.asset("assets/noitems.png"))],
                    )
                    ],
                  )
                  : items == null
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Color.fromRGBO(253, 186, 37, 1),
                          child: Card(
                            margin: EdgeInsetsDirectional.only(bottom: 3),
                            child: Container(
                                margin: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          child: Image.network(
                                            items[index]["imageurl"],
                                            height: 50,
                                            width: 50,
                                          ),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Container(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    items[index]["name"],
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                items[index]["regularprice"] ==
                                                        "0"
                                                    ? Container()
                                                    : Container(
                                                        margin:
                                                            EdgeInsets.all(5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons
                                                                  .info_outline,
                                                              size: 15,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      28,
                                                                      147,
                                                                      85,
                                                                      1),
                                                            ),
                                                            Text(
                                                              " Regular: ",
                                                              style: TextStyle(
                                                                  fontSize: (3.5 / 100) * width,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              "₹ " +
                                                                  items[index][
                                                                      "regularprice"],
                                                              style: TextStyle(
                                                                  fontSize: (3.5 / 100) * width,
                                                                  color: Colors
                                                                      .black54,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                items[index]["delicateprice"] ==
                                                        '0'
                                                    ? Container()
                                                    : Container(
                                                        margin:
                                                            EdgeInsets.all(3),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Tooltip(
                                                              message:
                                                                  "Extra care for light colours and delicate fabrics",
                                                              preferBelow:
                                                                  false,
                                                              child: Icon(
                                                                Icons
                                                                    .info_outline,
                                                                size: 15,
                                                                color: Colors
                                                                    .orangeAccent,
                                                              ),
                                                            ),
                                                            Text(
                                                              " Premium: ",
                                                              style: TextStyle(
                                                                  fontSize:  (3.5 / 100) * width,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              "₹ " +
                                                                  selecteditems[
                                                                          index]
                                                                      [
                                                                      "delicateprice"],
                                                              style: TextStyle(
                                                                  fontSize:  (3.5 / 100) * width,
                                                                  color: Colors
                                                                      .black54,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            // Tooltip(
                                                            //   message:
                                                            //       "Extra care for light colours and delicate fabrics",
                                                            //   preferBelow:
                                                            //       false,
                                                            //   child: Container(
                                                            //     margin: EdgeInsets
                                                            //         .only(
                                                            //             left:
                                                            //                 10),
                                                            //     child: Icon(
                                                            //       Icons.info,
                                                            //       size: 15,
                                                            //       color: Colors
                                                            //           .orangeAccent,
                                                            //     ),
                                                            //   ),
                                                            // )
                                                          ],
                                                        ),
                                                      )
                                              ],
                                            )),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: (6 / 100) * width,
                                          height: (6 / 100) * width,
                                          child: RaisedButton(
                                            onPressed: () {
                                              itemcount(index, "m", 0);
                                            },
                                            color: Colors.white,
                                            padding: EdgeInsets.all(2.0),
                                            child: Icon(
                                              LineAwesomeIcons.minus,
                                              color: Colors.grey,
                                              size: (4 / 100) * width,
                                            ),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.all(3)),
                                        Container(
                                          width: (6 / 100) * width,
                                          height: (6 / 100) * width,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  new BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(5.0),
                                                topRight:
                                                    const Radius.circular(5.0),
                                                bottomLeft:
                                                    const Radius.circular(5.0),
                                                bottomRight:
                                                    const Radius.circular(5.0),
                                              )),
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: selecteditems[index]
                                                      .containsKey('count')
                                                  ? Text(
                                                      selecteditems[index]
                                                              ["count"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: (4 / 100) *
                                                              width),
                                                    )
                                                  : Text(
                                                      "0",
                                                      style: TextStyle(
                                                          fontSize: (4 / 100) *
                                                              width),
                                                    )),
                                        ),
                                        Padding(padding: EdgeInsets.all(3)),
                                        Container(
                                          width: (6 / 100) * width,
                                          height: (6 / 100) * width,
                                          child: RaisedButton(
                                            onPressed: () {
                                              // itemcount(index, "p");
                                              priceoption(
                                                  selecteditems[index]
                                                      ["regularprice"],
                                                  selecteditems[index]
                                                      ["delicateprice"],
                                                  index,
                                                  "p");
                                            },
                                            color: Colors.white,
                                            padding: EdgeInsets.all(2.0),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.grey,
                                              size: (4 / 100) * width,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        ));
                      }),
            )
          ],
        ),
      ),
    );
  }
}
