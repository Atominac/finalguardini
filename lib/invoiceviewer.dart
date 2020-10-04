// import 'package:flutter/material.dart';
// import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
// import 'package:url_launcher/url_launcher.dart';

// class InvoiceViewer extends StatefulWidget {
//   var url;
//   InvoiceViewer(this.url);
//   @override
//   _InvoiceViewerState createState() => _InvoiceViewerState();
// }

// class _InvoiceViewerState extends State<InvoiceViewer> {
//   @override
//   void initState() {
//     super.initState();
//     getpdf();
//   }

//   PDFDocument doc;
//   getpdf() async {
//     print("object");
//     doc = await PDFDocument.fromURL(widget.url);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Invoice"),
//           actions: [
//             GestureDetector(
//               onTap: () async {
//                 var url = widget.url;
//                 if (await canLaunch(url)) {
//                   await launch(url);
//                 } else {
//                   throw 'Could not launch $url';
//                 }
//               },
//               child: Container(
//                   margin: EdgeInsets.all(10), child: Icon(Icons.file_download)),
//             ),
//           ],
//           backgroundColor: Color.fromRGBO(38, 179, 163, 1),
//         ),
//         body: doc == null
//             ? Center(child: CircularProgressIndicator())
//             : PDFViewer(document: doc));
//   }
// }
