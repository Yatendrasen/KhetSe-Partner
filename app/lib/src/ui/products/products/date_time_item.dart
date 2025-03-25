import 'package:admin/src/ui/orders/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SaleDateTimeItem extends StatelessWidget {
  SaleDateTimeItem({Key? key, DateTime? dateTime, required this.onChanged, required String title})
      : date = dateTime == null ? null : DateTime(dateTime.year, dateTime.month, dateTime.day),
        time = dateTime == null ? null : TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        title = title,
        super(key: key);

  final DateTime? date;
  final TimeOfDay? time;
  final String title;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: ListTile(
        trailing: Icon(Icons.arrow_right_rounded),
        title: Text(title),
        subtitle: date != null ? Text(DateFormat('EEE, MMM d yyyy').format(date!)) : null,
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: date != null ? date! : DateTime.now(),
            firstDate: date != null ? date! : DateTime.now(),
            lastDate: date != null ? date!.add(const Duration(days: 3000)) : DateTime.now().add(const Duration(days: 3000)),
          ).then<void>((DateTime? value) {
            if (value != null) {
              onChanged(DateTime(value.year, value.month, value.day,
                  value.hour, value.minute));
            }
          });
        },
      ),
    );
  }
}