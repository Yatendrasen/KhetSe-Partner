import 'package:admin/src/models/gift_card/gift_card_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Activities extends StatelessWidget {
  final List<Activity> activities;
  Activities({Key? key, required this.activities}) : super(key: key);

  DateFormat formatter1 = new DateFormat('dd-MM-yyyy  hh:mm a');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(activities[index].type.toUpperCase()),
                  Text(activities[index].amount.toString()),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activities[index].userEmail),
                  if(activities[index].note != null && activities[index].note!.isNotEmpty)
                    Text(activities[index].note!),
                  Text(activities[index].gcCode),
                  if(activities[index].date != null)
                    Text(formatter1.format(activities[index].date!)),
                ],
              ),
            );
          }
      ),
    );
  }
}
