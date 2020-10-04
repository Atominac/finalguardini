import 'package:flutter/material.dart';




class Terms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms & conditions"),
      ),
      body: Container(
        child: ListView(
  children: <Widget>[
    ListTile(
      title: Text("• We at Guardini ensure to use cleaning methods as per care instructions tagged on the garment/article, yet in case of no instructions the most appropriate cleaning methods are used. However, such article/garments with decorative items - beads, crystals, sequins, buttons, buckles etc., put on then, made out of delicate fabrics, are cleaned at owner's risk, as Guardini will not take any responsibility for loss or damage to it, under any circumstances."),
    ),
    ListTile(
      title: Text("• In case the garments/articles' delivery not taken within 15days from the date of booking, safekeeping charges would be applied extra."),
    ),
    ListTile(
      title: Text("• We exercise utmost care in processing Garments/articles. It is not possible to examine each Garments/article at the time of booking, all articles are thoroughly examined at our plant, any report from the plant about the condition of the arcticle received shall be accepted. "),
    ),
    ListTile(
      title: Text("• In case of any garment/article being cleaned, you should be aware that even when using the most delicate Drycleaning techniques, there is a remote possibility of slight change in size, texture or may colour bleed."),
    ),
    ListTile(
      title: Text("• Any Damage must be brought to notice within 24 hours of receipt of garments."),
    ),
    ListTile(
      title: Text("• Check all your garments for valuables-money, jewellery or precious items before giving for processing. The company would not be responsible for any loss or damage of belongings or cash left."),
    ),
    ListTile(
      title: Text("• In case of any clarifications, suggestions or comments kindly email us customercare@guardini.in for your valuable feedback. Kindly visit www.guardini.in"),
    ),
    ListTile(
      title: Text("• All disputes will be subject to Delhi jurisdiction only."),
    ),
  ],
),
      ),
    );
  }
}