import 'package:admin/src/blocs/booking/booking_bloc.dart';
import 'package:admin/src/ui/bookings/date_time_item.dart';
import 'package:flutter/material.dart';

import '../products/products/date_time_item.dart';

class FilterBooking extends StatefulWidget {
  final BookingsBloc bookingBloc;

  const FilterBooking({Key? key, required this.bookingBloc}) : super(key: key);
  @override
  _FilterBookingState createState() => _FilterBookingState();
}

class _FilterBookingState extends State<FilterBooking> {

  var date = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Booking'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Status".toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium,),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ChoiceChip(
                      //shape: RoundedRectangleBorder(),
                      label: Text("In Cart"),
                      selected: widget.bookingBloc.filter.containsKey('status[0]') &&
                          widget.bookingBloc.filter['status[0]'] == 'in-cart',
                      onSelected: (bool selected) {
                        if(widget.bookingBloc.filter.containsKey('status[0]')) {
                          setState(() {widget.bookingBloc.filter.remove('status[0]'); });
                        } else {
                          setState(() { widget.bookingBloc.filter['status[0]'] = 'in-cart'; });
                        }
                      },
                    ),
                    ChoiceChip(
                      //shape: RoundedRectangleBorder(),
                      label: Text("Complete"),
                      selected:
                      widget.bookingBloc.filter.containsKey('status[1]') &&
                          widget.bookingBloc.filter['status[1]'] == 'complete',
                      onSelected: (bool selected) {
                        if(widget.bookingBloc.filter.containsKey('status[1]')) {
                          setState(() {widget.bookingBloc.filter.remove('status[1]'); });
                        } else {
                          setState(() {
                            widget.bookingBloc.filter['status[1]'] = 'complete';
                          });
                        }
                      },
                    ),
                    ChoiceChip(
                      //shape: RoundedRectangleBorder(),
                      label: Text("Cancelled"),
                      selected:
                      widget.bookingBloc.filter.containsKey('status[2]') &&
                          widget.bookingBloc.filter['status[2]'] == 'cancelled',
                      onSelected: (bool selected) {
                        if(widget.bookingBloc.filter.containsKey('status[2]')) {
                          setState(() {widget.bookingBloc.filter.remove('status[2]'); });
                        } else {
                          setState(() { widget.bookingBloc.filter['status[2]'] = 'cancelled'; });
                        }
                      },
                    ),
                    ChoiceChip(
                      //shape: RoundedRectangleBorder(),
                      label: Text("Paid"),
                      selected:
                      widget.bookingBloc.filter.containsKey('status[3]') &&
                          widget.bookingBloc.filter['status[3]'] == 'paid',
                      onSelected: (bool selected) {
                        if(widget.bookingBloc.filter.containsKey('status[3]')) {
                          setState(() {widget.bookingBloc.filter.remove('status[3]'); });
                        } else {
                          setState(() { widget.bookingBloc.filter['status[3]'] = 'paid'; });
                        }
                      },
                    ),
                    ChoiceChip(
                      //shape: RoundedRectangleBorder(),
                      label: Text("Confirmed"),
                      selected:
                      widget.bookingBloc.filter.containsKey('status[4]') &&
                          widget.bookingBloc.filter['status[4]'] == 'confirmed',
                      onSelected: (bool selected) {
                        if(widget.bookingBloc.filter.containsKey('status[4]')) {
                          setState(() {widget.bookingBloc.filter.remove('status[4]'); });
                        } else {
                          setState(() { widget.bookingBloc.filter['status[4]'] = 'confirmed'; });
                        }
                      },
                    ),
                    ChoiceChip(
                      //shape: RoundedRectangleBorder(),
                      label: Text("Pending Confirmation"),
                      selected:
                      widget.bookingBloc.filter.containsKey('status[5]') &&
                          widget.bookingBloc.filter['status[5]'] == 'pending-confirmation',
                      onSelected: (bool selected) {
                        if(widget.bookingBloc.filter.containsKey('status[5]')) {
                          setState(() {widget.bookingBloc.filter.remove('status[5]'); });
                        } else {
                          setState(() { widget.bookingBloc.filter['status[5]'] = 'pending-confirmation'; });
                        }
                      },
                    ),
                    ChoiceChip(
                      //shape: RoundedRectangleBorder(),
                      label: Text("Unpaid"),
                      selected: widget.bookingBloc.filter.containsKey('status[6]') && widget.bookingBloc.filter['status[6]'] == 'unpaid',
                      onSelected: (bool selected) {
                        if(widget.bookingBloc.filter.containsKey('status[6]')) {
                          setState(() {widget.bookingBloc.filter.remove('status[6]'); });
                        } else {
                          setState(() { widget.bookingBloc.filter['status[6]'] = 'unpaid'; });
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Column(
                  children: [
                    FilterDateTimeItem(
                      title: 'From',
                      dateTime: widget.bookingBloc.filter.containsKey('date_from') ? DateTime.parse(widget.bookingBloc.filter['date_from']) : date,
                      onChanged: (DateTime value) {
                        setState(() {
                          widget.bookingBloc.filter['date_from'] = value.toIso8601String();
                        });
                      },
                    ),
                    FilterDateTimeItem(
                      title: 'To',
                      dateTime: widget.bookingBloc.filter.containsKey('date_to') ? DateTime.parse(widget.bookingBloc.filter['date_to']) : DateTime(date.year + 1, date.month, date.day),
                      onChanged: (DateTime value) {
                        setState(() {
                          widget.bookingBloc.filter['date_to'] = value.toIso8601String();
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      widget.bookingBloc.filter.clear();
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
                      widget.bookingBloc.fetchItems();
                      Navigator.of(context).pop();
                    }, child: Text('Apply')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
