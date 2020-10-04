import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DeliveryTimeline extends StatefulWidget {
 String status,deltype;
 DeliveryTimeline(this.status, this.deltype);
  @override
  _DeliveryTimelineState createState() => _DeliveryTimelineState();
}

class _DeliveryTimelineState extends State<DeliveryTimeline> {
  var status;
  var deliverytype;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    status=int.parse(widget.status);
    deliverytype=widget.deltype;
  print(status);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.05,
            isFirst: true,
            indicatorStyle: const IndicatorStyle(
              indicator: Icon(
                Icons.radio_button_checked,
                size: 14,
                color: Color.fromRGBO(0, 182, 188, 0.7),
              ),
              width: 14,
              color: Colors.red,
              padding: EdgeInsets.all(1),
            ),
            rightChild: const _RightChild(
              asset: '',
              title: 'Booking details shared with vendor',
              message: 'Recieved details',
            ),
            topLineStyle: const LineStyle(
              color: Color.fromRGBO(0, 182, 188, 0.7),
              width: 2,
            ),
          ),
          
          
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.05,
            indicatorStyle: const IndicatorStyle(
              indicator: Icon(
                Icons.radio_button_checked,
                size: 14,
                color: Color.fromRGBO(0, 182, 188, 0.7),
              ),
              width: 14,
              color: Colors.red,
              padding: EdgeInsets.all(0.9),
            ),
            rightChild: const _RightChild(
              asset: '',
              title: 'Order Placed',
              message: 'Your order has been confirmed.',
            ),
            topLineStyle: const LineStyle(
              color: Color.fromRGBO(0, 182, 188, 0.7),
              width: 2,
            ),
          ),
           status>0?TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.05,
            indicatorStyle: const IndicatorStyle(
              indicator: Icon(
                Icons.radio_button_checked,
                size: 14,
                color: Color.fromRGBO(0, 182, 188, 0.7),
              ),
              width: 14,
              color: Colors.red,
              padding: EdgeInsets.all(0.9),
            ),
            rightChild: const _RightChild(
              asset: '',
              title: 'Pickup Conducted',
              message: 'We are preparing your order.',
            ),
            topLineStyle: const LineStyle(
              color: Color.fromRGBO(0, 182, 188, 0.7),
              width: 2,
            ),
            bottomLineStyle: const LineStyle(
              color:  Color.fromRGBO(0, 182, 188, 0.7),
              width: 2,
            ),
          ):TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.05,
            indicatorStyle: const IndicatorStyle(
              indicator: Icon(
                Icons.radio_button_unchecked,
                size: 14,
                color: Colors.amber,
              ),
              width: 14,
              color: Colors.red,
              padding: EdgeInsets.all(0.9),
            ),
            rightChild: const _RightChild(
              asset: '',
              title: 'Pickup Conducted',
              message: 'We are preparing your order.',
            ),
            topLineStyle: const LineStyle(
              color: Colors.amber,
              width: 2,
            ),
            bottomLineStyle: const LineStyle(
              color: Colors.amber,
              width: 2,
            ),
          ),
         status>1 ?TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.05,
            indicatorStyle: const IndicatorStyle(
              indicator: Icon(
                Icons.radio_button_checked,
                size: 14,
                color: Color.fromRGBO(0, 182, 188, 0.7),
              ),
              width: 14,
              color: Colors.red,
              padding: EdgeInsets.all(0.9),
            ),
            rightChild: const _RightChild(
              asset: '',
              title: 'Recieved at Outlet',
              message: 'Garments are under inspecton',
            ),
            topLineStyle: const LineStyle(
              color: Color.fromRGBO(0, 182, 188, 0.7),
              width: 2,
            ),
            bottomLineStyle: const LineStyle(
              color: Color.fromRGBO(0, 182, 188, 0.7),
              width: 2,
            ) ,
          ):TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.05,
            indicatorStyle: const IndicatorStyle(
              indicator: Icon(
                Icons.radio_button_unchecked,
                size: 14,
                color: Colors.amber,
              ),
              width: 14,
              color: Colors.red,
              padding: EdgeInsets.all(0.9),
            ),
            rightChild: const _RightChild(
              asset: '',
              title: 'Recieved at Outlet',
              message: 'Garments are under inspecton',
            ),
            topLineStyle: const LineStyle(
              color: Colors.amber,
              width: 2,
            ),
            bottomLineStyle: const LineStyle(
              color: Colors.amber,
              width: 2,
            ),
          ),
           status>2?TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.05,
            indicatorStyle: const IndicatorStyle(
              indicator: Icon(
                Icons.radio_button_checked,
                size: 14,
                color: Color.fromRGBO(0, 182, 188, 0.7),
              ),
              width: 14,
              color: Colors.red,
              padding: EdgeInsets.all(0.9),
            ),
            rightChild: const _RightChild(
              asset: '',
              title: 'Processing',
              message: 'We are taking care of your clothes',
            ),
            topLineStyle: const LineStyle(
              color: Color.fromRGBO(0, 182, 188, 0.7),
              width: 2,
            ),
            bottomLineStyle: const LineStyle(
              color: Color.fromRGBO(0, 182, 188, 0.7),
              width: 2,
            ),
          ):TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.05,
            indicatorStyle: const IndicatorStyle(
              indicator: Icon(
                Icons.radio_button_unchecked,
                size: 14,
                color: Colors.amber,
              ),
              width: 14,
              color: Colors.red,
              padding: EdgeInsets.all(0.9),
            ),
            rightChild: const _RightChild(
              asset: '',
              title: 'Processing',
              message: 'We are taking care of your clothes',
            ),
            topLineStyle: const LineStyle(
              color: Colors.amber,
              width: 2,
            ),
            bottomLineStyle: const LineStyle(
              color: Colors.amber,
              width: 2,
            ),
          ),
         status>3?  TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.05,
            indicatorStyle: const IndicatorStyle(
              indicator: Icon(
                Icons.radio_button_checked,
                size: 14,
                color: Color.fromRGBO(0, 182, 188, 0.7),
              ),
              width: 14,
              color: Colors.red,
              padding: EdgeInsets.all(0.9),
            ),
            rightChild: const _RightChild(
              asset: '',
              title: 'Reached Outlet',
              message: 'Garments are back at the outlet',
            ),
            topLineStyle: const LineStyle(
              color: Color.fromRGBO(0, 182, 188, 0.7),
              width: 2,
            ),
            bottomLineStyle: const LineStyle(
              color:  Color.fromRGBO(0, 182, 188, 0.7),
              width: 2,
            ),
          ):TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.05,
            indicatorStyle: const IndicatorStyle(
              indicator: Icon(
                Icons.radio_button_unchecked,
                size: 14,
                color: Colors.amber,
              ),
              width: 14,
              color: Colors.red,
              padding: EdgeInsets.all(0.9),
            ),
            rightChild: const _RightChild(
              asset: '',
              title: 'Reached Outlet',
              message: 'Garments are back at the outlet',
            ),
            topLineStyle: const LineStyle(
              color: Colors.amber,
              width: 2,
            ),
            bottomLineStyle: const LineStyle(
              color: Colors.amber,
              width: 2,
            ),
          ),
         deliverytype=="2"? status>4?TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.05,
            indicatorStyle: const IndicatorStyle(
              indicator: Icon(
                Icons.radio_button_checked,
                size: 14,
                color: Color.fromRGBO(0, 182, 188, 0.7),
              ),
              width: 14,
              color: Colors.red,
              padding: EdgeInsets.all(0.9),
            ),
            rightChild: const _RightChild(
              asset: '',
              title: 'Ready for pickup',
              message: 'Please collect your garments from the outlet',
            ),
            topLineStyle: const LineStyle(
              color: Color.fromRGBO(0, 182, 188, 0.7),
              width: 2,
            ),
            bottomLineStyle: const LineStyle(
              color: Color.fromRGBO(0, 182, 188, 0.7),
              width: 2,
            ),
          ):TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.05,
            indicatorStyle: const IndicatorStyle(
              indicator: Icon(
                Icons.radio_button_unchecked,
                size: 14,
                color: Colors.amber,
              ),
              width: 14,
              color: Colors.red,
              padding: EdgeInsets.all(0.9),
            ),
            rightChild: const _RightChild(
              asset: '',
              title: 'Ready for pickup',
              message: 'Please collect your garments from the outlet',
            ),
            topLineStyle: const LineStyle(
              color: Colors.amber,
              width: 2,
            ),
            bottomLineStyle: const LineStyle(
              color: Colors.amber,
              width: 2,
            ),
          ):
          status>5?TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.05,
            indicatorStyle: const IndicatorStyle(
              indicator: Icon(
                Icons.radio_button_checked,
                size: 14,
                color: Color.fromRGBO(0, 182, 188, 0.7),
              ),
              width: 14,
              color: Colors.red,
              padding: EdgeInsets.all(0.9),
            ),
            rightChild: const _RightChild(
              asset: '',
              title: 'Out for delivery',
              message: 'Garments are on your way',
            ),
            topLineStyle: const LineStyle(
              color: Color.fromRGBO(0, 182, 188, 0.7),
              width: 2,
            ),
            bottomLineStyle: const LineStyle(
              color:  Color.fromRGBO(0, 182, 188, 0.7),
              width: 2,
            ),
          ):TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.05,
            indicatorStyle: const IndicatorStyle(
              indicator: Icon(
                Icons.radio_button_unchecked,
                size: 14,
                color: Colors.amber,
              ),
              width: 14,
              color: Colors.red,
              padding: EdgeInsets.all(0.9),
            ),
            rightChild: const _RightChild(
              asset: '',
              title: 'Out for delivery',
              message: 'Garments are on your way',
            ),
            topLineStyle: const LineStyle(
              color: Colors.amber,
              width: 2,
            ),
            bottomLineStyle: const LineStyle(
              color: Colors.amber,
              width: 2,
            ),
          ),
         
         status==7? TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.05,
            isLast: true,
            indicatorStyle: const IndicatorStyle(
              indicator: Icon(
                Icons.radio_button_checked,
                size: 14,
                color:Color.fromRGBO(0, 182, 188, 0.7),
              ),
              width: 14,
              color: Colors.red,
              padding: EdgeInsets.all(0.9),
            ),
            rightChild: const _RightChild(
              disabled: true,
              asset: '',
              title: 'Delivered',
              message: 'Thank you for choosing our services.',
            ),
            topLineStyle: const LineStyle(
              color:Color.fromRGBO(0, 182, 188, 0.7),
              width: 2,
            ),
          ):TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.05,
            indicatorStyle: const IndicatorStyle(
              indicator: Icon(
                Icons.radio_button_unchecked,
                size: 14,
                color: Colors.amber,
              ),
              width: 14,
              color: Colors.red,
              padding: EdgeInsets.all(0.9),
            ),
            rightChild: const _RightChild(
              asset: '',
              title: 'Delivered',
              message: 'Thank you for choosing our services.',
            ),
            topLineStyle: const LineStyle(
              color: Colors.amber,
              width: 2,
            ),
           
          ),
        ],
      ),
    ),
    );
  }
}

class _RightChild extends StatelessWidget {
  const _RightChild({
    Key key,
    this.asset,
    this.title,
    // this.title2,
    this.message,
    // this.message2,
    this.disabled = false,
  }) : super(key: key);

  final String asset;
  final String title;
  // final String title2;
  final String message;
  // final String message2;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      margin: const EdgeInsets.only(top: 30, bottom: 0),
      child: Row(
        children: <Widget>[
          // Opacity(
          //   child: Image.asset(asset, height: 50),
          //   opacity: disabled ? 0.5 : 1,
          // ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: GoogleFonts.yantramanav(
                  color: disabled
                      ? const Color(0xFF252525)
                      : const Color(0xFF636564),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                style: GoogleFonts.yantramanav(
                  color: disabled
                      ? const Color(0xFFBABABA)
                      : const Color(0xFF636564),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
