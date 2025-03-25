import 'package:flutter/material.dart';
import 'package:admin/src/blocs/refunds/refund_bloc.dart';
import 'package:admin/src/models/refund/refund_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:intl/intl.dart';


class RefundDetail extends StatefulWidget {
  RefundsBloc refundsBloc = RefundsBloc();
  final Refund refund;
  String id;

  RefundDetail({Key? key, required this.refund, required this.id}) : super(key: key);

  @override
  _RefundDetailState createState() =>
      _RefundDetailState();
}

class _RefundDetailState extends State<RefundDetail> {
  DateTime _DateTime = DateTime.now();
  bool _saveNeeded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            /*IconButton(icon: Icon(Icons.edit), onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditProduct(product: product)),
            );
            }),*/
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  widget.refundsBloc.deleteRefund(widget.refund, widget.id);
                }),
          ],
          title: Text(widget.refund.id.toString()),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: ListTile.divideTiles(
            //          <-- ListTile.divideTiles
            context: context,
            tiles: [
              ListTile(
                title: Text(AppLocalizations.of(context).translate("id"),),
                subtitle: Text(
                  widget.refund.id.toString(),
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).translate("amount"),),
                subtitle: Text(
                  widget.refund.amount,
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).translate("reason"),),
                subtitle: Text(
                  widget.refund.reason,
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).translate("refunded_by"),),
                subtitle: Text(
                  widget.refund.refundedBy.toString(),
                ),
              ),

             /* const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Refund Created On'),
                  DateTimeItem(
                    dateTime: _onDateTime,
                    onChanged: (DateTime value) {
                      setState(() {
                        _onDateTime = value;
                        _saveNeeded = true;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Refund Created On(GMT)'),
                  DateTimeItem(
                    dateTime: _DateTime,
                    onChanged: (DateTime value) {
                      setState(() {
                        _DateTime = value;
                        _saveNeeded = true;
                      });
                    },
                  ),
                ],
              )*/



            ],
          ).toList(),
        ));
  }
}

class DateTimeItem extends StatelessWidget {
  DateTimeItem({Key? key, required DateTime dateTime, required this.onChanged})
      : date = DateTime(dateTime.year, dateTime.month, dateTime.day),
        time = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        super(key: key);

  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DefaultTextStyle(
      style: theme.textTheme.titleMedium!,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                  border:
                  Border(bottom: BorderSide(color: theme.dividerColor))),
              child: InkWell(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: date.subtract(const Duration(days: 3000)),
                    lastDate: date,
                  ).then<void>((DateTime? value) {
                    if (value != null)
                      onChanged(DateTime(value.year, value.month, value.day,
                          time.hour, time.minute));
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(DateFormat('EEE, MMM d yyyy').format(date)),
                    const Icon(Icons.arrow_drop_down, color: Colors.black54),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8.0),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: theme.dividerColor))),
            child: InkWell(
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: time,
                ).then<void>((TimeOfDay? value) {
                  if (value != null)
                    onChanged(DateTime(date.year, date.month, date.day,
                        value.hour, value.minute));
                });
              },
              child: Row(
                children: <Widget>[
                  Text('${time.format(context)}'),
                  const Icon(Icons.arrow_drop_down, color: Colors.black54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}