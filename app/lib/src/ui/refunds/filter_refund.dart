// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import '../../blocs/refunds/refund_bloc.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

//const double _kPickerSheetHeight = 216.0;
//const double _kPickerItemHeight = 32.0;

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

class FilterRefund extends StatefulWidget {

  //final String id;
 // const FilterRefund(this.id);

  @override
  FilterRefundState createState() => FilterRefundState();
}

class FilterRefundState extends State<FilterRefund> {
  DateTime _fromDateTime = DateTime.now();
  DateTime _toDateTime = DateTime.now();
  bool _saveNeeded = false;

 // final String id;
 // FilterRefundState(this.id,);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    void handleOrderValueChanged(String? value) {
      if(value != null) {
        setState(() {
          bloc.order = value;
        });
      }
    }

    void handleOrderByValueChanged(String? value) {
      if(value != null) {
        setState(() {
          bloc.orderBy = value;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("filter"),),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context).translate("reset"),
              style: Theme.of(context).primaryTextTheme.titleMedium,
            ),
            onPressed: () {
              bloc.reset();
              Navigator.pop(context, DismissDialogAction.save);
            },
          ),
        ],
      ),
      body: Form(
        child: ListView(padding: const EdgeInsets.all(16.0), children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16.0),
                TextField(
                  controller: TextEditingController()..text = bloc.search,
                  onChanged: (text) {
                    bloc.search = text;
                  },
                  decoration:  InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: AppLocalizations.of(context).translate("search"),
                    hintText: AppLocalizations.of(context).translate("type_product_name_to_search"),
                  ),
                  maxLines: 1,
                ),
              ]),
          const SizedBox(height: 16.0),
         /* Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('After', style: theme.textTheme.titleSmall),
              DateTimeItem(
                dateTime: _fromDateTime,
                onChanged: (DateTime value) {
                  setState(() {
                    _fromDateTime = value;
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
              Text('Before', style: theme.textTheme.titleSmall),
              DateTimeItem(
                dateTime: _toDateTime,
                onChanged: (DateTime value) {
                  setState(() {
                    _toDateTime = value;
                    _saveNeeded = true;
                  });
                },
              ),
            ],
          ),*/
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16.0),
              Text(AppLocalizations.of(context).translate("order"), style: theme.textTheme.titleSmall),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Radio<String>(
                    value: 'desc',
                    groupValue: bloc.order,
                    onChanged: handleOrderValueChanged,
                  ),
                  new Text(
                    AppLocalizations.of(context).translate("descending"),
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  Radio<String>(
                    value: 'asc',
                    groupValue: bloc.order,
                    onChanged: handleOrderValueChanged,
                  ),
                  new Text(
                    AppLocalizations.of(context).translate("ascending"),
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  Text(AppLocalizations.of(context).translate("order_by"), style: theme.textTheme.titleSmall),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio<String>(
                        value: 'date',
                        groupValue: bloc.orderBy,
                        onChanged: handleOrderByValueChanged,
                      ),
                      new Text(
                        AppLocalizations.of(context).translate("date"),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Radio<String>(
                        value: 'id',
                        groupValue: bloc.orderBy,
                        onChanged: handleOrderByValueChanged,
                      ),
                      new Text(
                        AppLocalizations.of(context).translate("id"),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Radio<String>(
                        value: 'include',
                        groupValue: bloc.orderBy,
                        onChanged: handleOrderByValueChanged,
                      ),
                      new Text(
                        AppLocalizations.of(context).translate("include"),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Radio<String>(
                    value: 'title',
                    groupValue: bloc.orderBy,
                    onChanged: handleOrderByValueChanged,
                  ),
                  new Text(
                    AppLocalizations.of(context).translate("title"),
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  Radio<String>(
                    value: 'slug',
                    groupValue: bloc.orderBy,
                    onChanged: handleOrderByValueChanged,
                  ),
                  new Text(
                    AppLocalizations.of(context).translate("slug"),
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ],
              )
            ],
          ),
         /* Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16.0),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: TextEditingController()
                    ..text = bloc.dp.toString(),
                  onChanged: (text) {
                    bloc.dp.toString();
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Dp',
                    hintText: 'Type Dp',
                  ),
                  maxLines: 1,
                ),
              ]),*/
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AccentButton(
                text:  AppLocalizations.of(context).translate("search"),
                onPressed: () {
                  var filter = '';
                  if (_saveNeeded) {
                    var formatter = new DateFormat('yyyy-MM-ddTHH:mm:ss');
                    filter =
                        filter + '&after=' + formatter.format(_fromDateTime);
                    filter =
                        filter + '&before=' + formatter.format(_toDateTime);
                  }
                  bloc.fetchRefunds();
                  Navigator.pop(context, DismissDialogAction.save);
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
