import 'package:admin/src/blocs/coupons/coupon_bloc.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin/src/ui/language/app_localizations.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class FilterCoupon extends StatefulWidget {
  final CouponsBloc couponsBloc;

  const FilterCoupon({Key? key, required this.couponsBloc}) : super(key: key);
  @override
  _FilterCouponState createState() => _FilterCouponState();
}

class _FilterCouponState extends State<FilterCoupon> {
  DateTime _fromDateTime = DateTime.now();
  DateTime _toDateTime = DateTime.now();
  bool _saveNeeded = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("filter")),
      ),
      body: Form(
        child: ListView(padding: const EdgeInsets.all(16.0), children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16.0),
                TextField(
                  controller: TextEditingController()..text = widget.couponsBloc.filter['search'] ?? '',
                  onChanged: (text) {
                    widget.couponsBloc.filter['search'] = text;
                  },
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: AppLocalizations.of(context).translate("search_coupon"),
                    hintText:  AppLocalizations.of(context).translate("type_coupon_code_to_search"),
                  ),
                  maxLines: 1,
                ),
              ]),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16.0),
              Text(AppLocalizations.of(context).translate("order").toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("ascending")),
                    selected: widget.couponsBloc.filter.containsKey('order') && widget.couponsBloc.filter['order'] == 'asc',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.couponsBloc.filter['order'] = 'asc';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("descending")),
                    selected: widget.couponsBloc.filter['order'] == 'desc',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.couponsBloc.filter['order'] = 'desc';
                      });
                    },
                  ),
                ],
              ),
              Divider(height: 24),
              Text(AppLocalizations.of(context).translate("order_by").toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("title")),
                    selected: widget.couponsBloc.filter.containsKey('orderby') && widget.couponsBloc.filter['orderby'] == 'title',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.couponsBloc.filter['orderby'] = 'title';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("date")),
                    selected: widget.couponsBloc.filter.containsKey('orderby') && widget.couponsBloc.filter['orderby'] == 'date',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.couponsBloc.filter['orderby'] = 'date';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("id")),
                    selected: widget.couponsBloc.filter.containsKey('orderby') && widget.couponsBloc.filter['orderby'] == 'id',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.couponsBloc.filter['orderby'] = 'id';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("include")),
                    selected: widget.couponsBloc.filter.containsKey('orderby') && widget.couponsBloc.filter['orderby'] == 'include',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.couponsBloc.filter['orderby'] = 'include';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("slug")),
                    selected: widget.couponsBloc.filter.containsKey('orderby') && widget.couponsBloc.filter['orderby'] == 'slug',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.couponsBloc.filter['orderby'] = 'slug';
                      });
                    },
                  ),
                ],
              ),
            ],
          ),


          //const SizedBox(height: 18.0),
          // Text('Date on sale from'),
          /*  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('After'),
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
              Text(
                'Before',
              ),
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
                TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: TextEditingController()..text = widget.couponsBloc.filter['code'] ?? '',
                  onChanged: (text) {
                    widget.couponsBloc.filter['code'] = text;
                  },
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: AppLocalizations.of(context).translate("coupon_code"),
                    hintText: AppLocalizations.of(context).translate("type_coupon_code_to_search"),
                  ),
                  maxLines: 1,
                ),
              ]),
        ]),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      widget.couponsBloc.filter.clear();
                      setState(() {});
                    },
                    child: Text('Clear All')),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.onSecondary),
                    onPressed: () async {
                      widget.couponsBloc.fetchItems();
                      Navigator.of(context).pop();
                    }, child: Text('Apply')),
              )
            ],
          ),
        ),
      ),
    );
  }

  void handleOrderValueChanged(String? value) {
    if(value != null) {
      setState(() {
        widget.couponsBloc.filter['order'] = value;
      });
    }
  }

  void handleOrderByValueChanged(String? value) {
    if(value != null) {
      setState(() {
        widget.couponsBloc.filter['orderby'] = value;
      });
    }
  }
}


class DateTimeItem extends StatelessWidget {
  DateTimeItem({Key? key, required DateTime dateTime, required this.onChanged})
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
