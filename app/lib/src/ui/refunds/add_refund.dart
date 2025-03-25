import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin/src/blocs/refunds/refund_bloc.dart';
import 'package:admin/src/models/refund/refund_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class AddRefund extends StatefulWidget{
  RefundsBloc refundsBloc = RefundsBloc();
  final String id;

  AddRefund({Key? key, required this.id}) : super(key: key);

  @override
  _AddRefundState createState() => _AddRefundState();

}

class _AddRefundState extends State<AddRefund>{
  final _formKey = GlobalKey<FormState>();
  final _refund = Refund.fromJson({});

  DateTime _onDateTime = DateTime.now();
  DateTime _DateTime = DateTime.now();
  bool _saveNeeded = false;

  @override
  void initState(){
    super.initState();
    widget.refundsBloc.id = widget.id;
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).translate("add_refund"),),),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   /* SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                      decoration: InputDecoration(labelText: 'Id'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Id';
                        }
                      },
                      onSaved: (val) =>
                          setState(() => _refund.id = int.parse(val)),
                    ),*/

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
                    ),*/

                /*    const SizedBox(height: 16.0),
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
                    ),*/

                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).translate("amount"),
                      ),
                      validator: (value)  {
                        if (value == null || value.isEmpty) {
                          return  AppLocalizations.of(context).translate("please_enter_amount");
                        }
                      },
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => _refund.amount = val);
                        }
                      },
                    ),

                   /* SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Refunded By',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please refunded by';
                        }
                      },
                      onSaved: (val) =>
                          setState(() => _refund.refundedBy),
                    ),*/

                    const SizedBox(height: 16.0),
                 /*   Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Refunded payment'),
                        Align(
                          //alignment: const Alignment(0.0, -0.2),
                          child: Row(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Switch(
                                value: bloc.refundedPayment,
                                onChanged: (bool value) {
                                  setState(() {
                                    bloc.refundedPayment = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),*/


                    const SizedBox(height: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(AppLocalizations.of(context).translate("api_refund")),
                        Align(
                          //alignment: const Alignment(0.0, -0.2),
                          child: Row(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Switch(
                                value: bloc.apiRefund,
                                onChanged: (bool value) {
                                  setState(() {
                                    bloc.apiRefund = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: AccentButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              bloc.addRefund(_refund);
                              Navigator.pop(context, DismissDialogAction.save);
                            }
                          },
                          text: AppLocalizations.of(context).translate("submit"),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
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