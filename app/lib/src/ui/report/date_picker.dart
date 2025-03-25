// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import '../../blocs/report/report_bloc.dart';
// This demo is based on
// https://material.io/design/components/dialogs.html#full-screen-dialog

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class DateTimeItem extends StatelessWidget {
  DateTimeItem({ Key? key, required DateTime dateTime, required this.onChanged })
      : assert(onChanged != null),
        date = DateTime(dateTime.year, dateTime.month, dateTime.day),
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
                  border: Border(bottom: BorderSide(color: theme.dividerColor))
              ),
              child: InkWell(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: date.subtract(const Duration(days: 3000)),
                    lastDate: date,
                  )
                      .then<void>((DateTime? value) {
                    if (value != null)
                      onChanged(DateTime(value.year, value.month, value.day, time.hour, time.minute));
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
        ],
      ),
    );
  }
}

class FilterReport extends StatefulWidget {

  final ReportBloc reportBloc;

  const FilterReport({Key? key, required this.reportBloc}) : super(key: key);

  @override
  FilterReportState createState() => FilterReportState();
}

class FilterReportState extends State<FilterReport> {
  DateTime _fromDateTime = DateTime.now();
  DateTime _toDateTime = DateTime.now();
  bool _saveNeeded = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("date"),),
        actions: <Widget> [
          TextButton(
            child: Text(AppLocalizations.of(context).translate("save"), style: theme.textTheme.bodyMedium!.copyWith(color: Colors.white)),
            onPressed: () {
              if(_saveNeeded){
                var formatter = new DateFormat('yyyy-MM-dd');
                String period = 'after=' + formatter.format(_fromDateTime);
                period += '&before=' + formatter.format(_toDateTime);
                widget.reportBloc.fetchSalesReportByDate(period);
              }
              Navigator.pop(context, DismissDialogAction.save);
            },
          ),
        ],
      ),
      body: Form(
        child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(AppLocalizations.of(context).translate("from"), style: theme.textTheme.titleSmall),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text(AppLocalizations.of(context).translate("to"), style: theme.textTheme.titleSmall),
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
              ),
            ]
          ),
      ),
    );
  }
}
