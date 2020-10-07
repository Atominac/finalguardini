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
  // String locality, workinhours, workingdays, outlet, distance, img;
  // AddItems(this.distance, this.locality, this.workinhours, this.workingdays,
  //     this.outlet, this.img);
  AddItems();
  @override
  _AddItemsState createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchitems();
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

      print(_result);
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
    //print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      flag = 1;
      setState(() {
        items = jsondecoded["data"];
      });
      // sortoutlets(outlets);
      print(items.length);
    } else if (jsondecoded['message'] == "no_item_found") {
      flag = 0;
      showsnack("No items found");
    } else {
      showsnack("Some error has ouccered");
    }
  }

  var category = [0, 0, 0]; //[2,3]
  additems(index) {
    print(category);
    print("category");

    selecteditems[index]["count"] = 0.toString();
    print("category");

    selecteditems[index]["paymenttype"] = [];

    for (var x = 0; x < selectedservices.length; x++) {
      itemdialogue = selectedservices[x];
      itemcount(index, "p", x);
    }
    // if (category[0] == 0 && category[1] == 0 && category[2] == 0) {
    //   selectedindex.removeWhere((item) => item == index);
    // }
    // for (var x = 0; x < category.length; x++) {
    //   category[x] = 0;
    // }
    //yha
    tempitems = 0;
  }

  itemcount(index, action, pricetype) {
    print("price type=" + pricetype.toString());
    // return;
    var price;
    selecteditems[index]["packgingtype"] = pkgoption;
    // if (pricetype == 0) {
    //   price = int.parse(selecteditems[index]["regularprice"]);
    // } else if (pricetype == 1) {
    //   price = int.parse(selecteditems[index]["delicateprice"]);
    // } else if (pricetype == 2) {
    //   price = int.parse(selecteditems[index]["premiumpressing"]);
    // }

    // for (var x = 0; x < selectedservices[index]["services"].length; x++) {
    //       if(selectedservices)
    // }
    print("hey yo bitch");
    // print(selecteditems[index]["services"][pricetype]["price"]);
    price = selecteditems[index]["services"][pricetype]["price"];
    print(price);
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
        print("price");
        totalprice += int.parse(price.toString());
        print("price");

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
          print("here");
          totalprice += price;
          print("here");

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

    print(selecteditems);
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
      print(paymenttype.length);
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
        print(price);
        // return;

        print("object");
        temptotalcount += 1;
        print(price);
        tempprice += int.parse(price);
        print("object yeh");
      }
    }
    totalprice = tempprice;
    totalitems = temptotalcount;
    setState(() {
      print("hey" + selecteditems[index]["count"].toString());
      print("yo" + selectedindex.toString());
    });

    print(selecteditems);
  }

  georderdetails() async {
    blank = [];
    var item;
    final user = await SharedPreferences.getInstance();

    // print("bdy");
    // print(orderdetails["outlet"]);

    // return;
    var flag = 0;
    for (int i = 0; i < selectedindex.length; i++) {
      var paymenttype = selecteditems[selectedindex[i]]["paymenttype"];
      // print(paymenttype.length);
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
        // print("item");
        // print(item);
        blank.add(item);
        // print(blank);
        flag++;
      }
    }
    // print(blank);
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

    print(orderdetails);
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
    // print(selectedservices);
    List<Widget> children = new List<Widget>();
    for (var i = 0; i < selecteditems[index]["services"].length; i++) {
      // print(selecteditems[index]["services"]);
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
                          print(selectedservices);

                          if (tempitems < 2) {
                            tempitems = 0;
                          } else {
                            tempitems -= 1;
                          }
                          print("temp" + tempitems.toString());
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
                            size: (4 / 100) * MediaQuery.of(context).size.width,
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
                          print("cat" + selectedservices[i].toString());
                          print(selectedservices);
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
                            size: (4 / 100) * MediaQuery.of(context).size.width,
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

  // checkItemsEmpty() {
  //   int cnt = 1;
  //   for (int i = 0; i < selectedindex.length; i++) {
  //     if (!(selecteditems[selectedindex][i]["count"]) == 0) {
  //       cnt = 0;
  //     }
  //   }
  //   setState(() {});
  //   return cnt;
  // }
  showModal() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Regular Wash',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the ypesetting industry. Lorem Ipsum has been the',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              Text(
                'Premium Wash',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the ypesetting industry. Lorem Ipsum has been the',
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

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        key: _scafoldkey,
        appBar: AppBar(
          title: Text(
            "Select items for drycleaning",
            style: TextStyle(fontSize: size.height > 1280 ? 16 : 14),
          ),
          backgroundColor: Hexcolor('#219251'),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Hexcolor('#FFC233'),
            indicatorWeight: 4,
            isScrollable: true,
            tabs: [
              Tab(
                text: 'All',
              ),
              Tab(
                text: 'Bottoms',
              ),
              Tab(
                text: 'Tops',
              ),
              Tab(
                text: 'Upholstery',
              ),
              Tab(
                text: 'Woolens',
              ),
              Tab(
                text: 'Accessories',
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {
        //     georderdetails();
        //   },
        //   icon: Icon(Icons.arrow_forward),
        //   label: Text("next"),
        //   backgroundColor: Color.fromRGBO(38, 179, 163, 1),
        // ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            Stack(
              children: [
                Container(
                  child: Column(
                    children: <Widget>[
                      //Search bar
//                   SizedBox(
//                     height: 40,
//                     child: Row(
//                       children: [
//                         Container(
//                           width: (80 / 100) * size.width,
//                           child: TextFormField(
//                             decoration: new InputDecoration(
//                               hintText: "Search",
//                               border: new OutlineInputBorder(
//                                 borderRadius: const BorderRadius.all(
//                                   const Radius.circular(5.0),
//                                 ),
//                               ),
//                             ),
//                             keyboardType: TextInputType.text,
//                             controller: t1,
//                             onChanged: (value) {
// // _onChangeHandler(value);
//                               setState(() {});
//                             },
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(left: 5),
//                           child: SizedBox(
//                             width: (12 / 100) * size.width,
//                             child: RaisedButton(
//                                 onPressed: () {
//                                   // if(t1.text==""){
//                                   //   showsnack("enter a keyword");
//                                   // }else{

//                                   search();
//                                   // }
//                                 },
//                                 color: Color.fromRGBO(38, 179, 163, 1),
//                                 padding: EdgeInsets.all(2.0),
//                                 child: Icon(
//                                   Icons.search,
//                                   color: Colors.white,
//                                 )),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
                      Container(
                        height: size.height * 0.8,
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: flag == 0
                            ? Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Center(
                                  child: Image.asset("assets/noitems.png"),
                                ),
                              )
                            : items == null
                                ? Container(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Container(
                                    height: size.height * 0.7,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showModal();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0,
                                                size.height > 1280 ? 10 : 6,
                                                0,
                                                size.height > 1280 ? 10 : 6),
                                            margin: EdgeInsets.only(
                                              top: 0,
                                              bottom: 5,
                                            ),
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
                                                fontSize: size.height > 1280
                                                    ? 12
                                                    : 10,
                                                color: Hexcolor('#00B6BC'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio:
                                                  size.height > 1280
                                                      ? 0.57
                                                      : 0.57,
                                              crossAxisSpacing:
                                                  size.height > 1280 ? 15 : 10,
                                              mainAxisSpacing: 16,
                                            ),
                                            itemCount: selecteditems.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromRGBO(
                                                          1, 25, 79, 0.2),
                                                      blurRadius: 4,
                                                      spreadRadius: 1,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      color:
                                                          Hexcolor('#EFE9E0'),
                                                      width: size.width * 0.4,
                                                      height: size.height > 1280
                                                          ? 150
                                                          : 120,
                                                      margin: EdgeInsets.all(8),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height:
                                                                size.height >
                                                                        1280
                                                                    ? 100
                                                                    : 90,
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child:
                                                                Image.network(
                                                              items[index]
                                                                  ["imageurl"],
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8.0),
                                                            child: Text(
                                                              items[index]
                                                                  ["name"],
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height >
                                                                            1280
                                                                        ? 16
                                                                        : 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 5, left: 8),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          items[index][
                                                                      "regularprice"] ==
                                                                  "0"
                                                              ? Container()
                                                              : Container(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "₹ " +
                                                                            items[index]["regularprice"] +
                                                                            " pp",
                                                                        style: TextStyle(
                                                                            fontSize: size.height > 1280
                                                                                ? 14
                                                                                : 12,
                                                                            color:
                                                                                Hexcolor('#737373'),
                                                                            fontWeight: FontWeight.w600),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          "Regular Care ",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize: size.height > 1280
                                                                                ? 12
                                                                                : 10,
                                                                            color:
                                                                                Hexcolor(
                                                                              '#737373',
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                          items[index][
                                                                      "delicateprice"] ==
                                                                  '0'
                                                              ? Container()
                                                              : Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              16),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "₹ " +
                                                                            items[index]["delicateprice"] +
                                                                            " pp",
                                                                        style: TextStyle(
                                                                            fontSize: size.height > 1280
                                                                                ? 14
                                                                                : 12,
                                                                            color:
                                                                                Hexcolor('#737373'),
                                                                            fontWeight: FontWeight.w600),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          "Premium Care ",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize: size.height > 1280
                                                                                ? 12
                                                                                : 10,
                                                                            color:
                                                                                Hexcolor(
                                                                              '#737373',
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    3),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 5),
                                                      // margin: EdgeInsets.only(
                                                      //     top: size.height * 0.12, bottom: 10),
                                                      child: InkWell(
                                                        onTap: () {
                                                          tempitems = 0;
                                                          selectedservices = List<
                                                                  int>.generate(
                                                              selecteditems
                                                                      .length +
                                                                  1,
                                                              (i) => 0);

                                                          print(selecteditems[
                                                                  index]
                                                              .containsKey(
                                                                  'paymenttype'));
                                                          print(
                                                              selectedservices);
                                                          // return;
                                                          if (selecteditems[
                                                                  index]
                                                              .containsKey(
                                                                  'paymenttype')) {
                                                            for (var x = 0;
                                                                x <
                                                                    selecteditems[index]
                                                                            [
                                                                            "paymenttype"]
                                                                        .length;
                                                                x++) {
                                                              selectedservices[
                                                                  selecteditems[
                                                                          index]
                                                                      [
                                                                      "paymenttype"][x]]++;
                                                              tempitems += 1;
                                                            }
                                                          }
                                                          print(tempitems);
                                                          print(
                                                              selectedservices);
                                                          // return;
                                                          priceoption(
                                                              selecteditems[
                                                                      index]
                                                                  ["name"],
                                                              selecteditems[
                                                                      index][
                                                                  "regularprice"],
                                                              selecteditems[
                                                                      index][
                                                                  "delicateprice"],
                                                              index,
                                                              "p");
                                                        },
                                                        // enableFeedback: true,
                                                        splashColor:
                                                            Color.fromRGBO(255,
                                                                194, 51, 0.3),
                                                        highlightColor:
                                                            Color.fromRGBO(255,
                                                                194, 51, 0.25),
                                                        child: Container(
                                                          width:
                                                              size.width * 0.4,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          194,
                                                                          51,
                                                                          0.4),
                                                                  border: Border
                                                                      .all(
                                                                    color: Hexcolor(
                                                                        '#FFC233'),
                                                                    width: 0.5,
                                                                  )),
                                                          height:
                                                              size.height > 1280
                                                                  ? 50
                                                                  : 30,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            selecteditems[index]
                                                                            [
                                                                            "count"] ==
                                                                        null ||
                                                                    selecteditems[index]
                                                                            [
                                                                            "count"] ==
                                                                        "0"
                                                                ? 'Add to basket'
                                                                : 'Edit',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  size.height >
                                                                          1280
                                                                      ? 15
                                                                      : 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Hexcolor(
                                                                  '#404040'),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
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
                      ),
                    ],
                  ),
                ),
                //Item pricing
                // checkItemsEmpty() == 0 ?
                // Container()
                Positioned(
                  bottom: 0,
                  child: Container(
                      height: size.height > 1280 ? 55 : 40,
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
                                      fontSize: size.height > 1280 ? 16 : 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    ' (Estimated)',
                                    style: TextStyle(
                                      color: Hexcolor('#404040'),
                                      fontSize: size.height > 1280 ? 10 : 8,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                totalitems.toString() + " pieces",
                                style: TextStyle(
                                  color: Hexcolor('#404040'),
                                  fontSize: size.height > 1280 ? 10 : 8,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              print(selecteditems);
                              georderdetails();
                            },
                            child: Row(
                              children: [
                                Text(
                                  "View Basket",
                                  style: TextStyle(
                                    color: Hexcolor('#252525'),
                                    fontSize: size.height > 1280 ? 14 : 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 8)),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: size.height > 1280 ? 14 : 12,
                                  color: Hexcolor('#252525'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
