import 'package:admin/src/blocs/shipping/shipping_zone_bloc.dart';
import 'package:admin/src/models/shipping/shipping_zone_model.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'shipping_methods.dart';

class ShippingZonePage extends StatefulWidget {
  ShippingZoneBloc shippingZoneBloc = ShippingZoneBloc();
  @override
  _ShippingZonePageState createState() => _ShippingZonePageState();
}

class _ShippingZonePageState extends State<ShippingZonePage> {

  @override
  void initState() {
    widget.shippingZoneBloc.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping'),
      ),
      body: StreamBuilder(
          stream: widget.shippingZoneBloc.allData,
          builder: (context, AsyncSnapshot<List<ShippingZones>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView(
                children: buildList(snapshot),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  List<Widget> buildList(AsyncSnapshot<List<ShippingZones>> snapshot) {
    List<Widget> list = [];
    snapshot.data!.forEach((element) {
      list.add(ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShippingMethodsPage(zone: element)),
          );
        },
        contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 16),
        title: Text(_parseHtmlString(element.name)),
      ));
    });
    return list;
  }
}

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}
