import 'package:admin/src/blocs/shipping/shipping_methods_bloc.dart';
import 'package:admin/src/blocs/shipping/shipping_zone_bloc.dart';
import 'package:admin/src/models/shipping/shipping_methods_model.dart';
import 'package:admin/src/models/shipping/shipping_zone_model.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class ShippingMethodsPage extends StatefulWidget {
  ShippingMethodsBloc shippingMethodsBloc = ShippingMethodsBloc();
  final ShippingZones zone;
  ShippingMethodsPage({Key? key, required this.zone}) : super(key: key);
  @override
  _ShippingMethodsPageState createState() => _ShippingMethodsPageState();
}

class _ShippingMethodsPageState extends State<ShippingMethodsPage> {

  @override
  void initState() {
    widget.shippingMethodsBloc.fetchData(widget.zone);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Methods'),
      ),
      body: StreamBuilder(
          stream: widget.shippingMethodsBloc.allData,
          builder: (context, AsyncSnapshot<List<ShippingMethods>> snapshot) {
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

  List<Widget> buildList(AsyncSnapshot<List<ShippingMethods>> snapshot) {
    List<Widget> list = [];
    snapshot.data!.forEach((element) {
      list.add(ListTile(
        onTap: () {

        },
        contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 16),
        title: Text(_parseHtmlString(element.title)),
        subtitle: element.methodDescription == null || element.methodDescription.isEmpty ? null : Text(_parseHtmlString(element.methodDescription)),
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
