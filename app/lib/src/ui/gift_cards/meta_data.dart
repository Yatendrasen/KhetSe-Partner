import 'package:admin/src/models/gift_card/gift_card_model.dart';
import 'package:admin/src/models/refund/refund_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MetaDataPage extends StatelessWidget {
  final List<MetaDatum> metaDatum;
  MetaDataPage({Key? key, required this.metaDatum}) : super(key: key);

  DateFormat formatter1 = new DateFormat('dd-MM-yyyy  hh:mm a');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: metaDatum.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            title: Text(metaDatum[index].value.toUpperCase()),
            subtitle: Text(metaDatum[index].key),
          );
        }
      ),
    );
  }
}
