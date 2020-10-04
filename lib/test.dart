//  Container(

//                     decoration: BoxDecoration(
//                       border: Border.all(color: Color.fromRGBO(28, 147, 85, 1)),
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                     margin: EdgeInsets.all(10),
//                     padding: EdgeInsets.all(10),
//                     child: Column(
//                       children: [
//                         Text(
//                           time == null ? "Select a time" :"Time: "+ time,
//                           style: TextStyle(
//                               fontSize: 17,
//                               color: Colors.black54,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(top:10),
//                           child: Row(
//                             children: [
//                               GestureDetector(onTap: (){
//                                 this.time="10am - 12pm";
//                                 print(time);
//                                 setState(() {
                                  
//                                 });
                                
//                               },
//                                                               child: Container(
//                                   width: 110,
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                         color: Color.fromRGBO(28, 147, 85, 1)),
//                                     borderRadius: BorderRadius.circular(5.0),
//                                   ),
//                                   margin: EdgeInsets.all(5),
//                                   padding: EdgeInsets.all(5),
//                                   child: Text("10am - 12pm"),
//                                 ),
//                               ),
//                               Container(
//                                 width: 110,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                       color: Color.fromRGBO(28, 147, 85, 1)),
//                                   borderRadius: BorderRadius.circular(5.0),
//                                 ),
//                                 margin: EdgeInsets.all(5),
//                                 padding: EdgeInsets.all(5),
//                                 child: Text("12pm - 2pm"),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Container(
//                               width: 110,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                     color: Color.fromRGBO(28, 147, 85, 1)),
//                                 borderRadius: BorderRadius.circular(5.0),
//                               ),
//                               margin: EdgeInsets.all(5),
//                               padding: EdgeInsets.all(5),
//                               child: Text("2pm - 4pm"),
//                             ),
//                             Container(
//                               width: 110,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                     color: Color.fromRGBO(28, 147, 85, 1)),
//                                 borderRadius: BorderRadius.circular(5.0),
//                               ),
//                               margin: EdgeInsets.all(5),
//                               padding: EdgeInsets.all(5),
//                               child: Text("4pm - 6pm"),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
              