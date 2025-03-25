import 'package:admin/src/blocs/booking/booking_bloc.dart';
import 'package:admin/src/models/account/booking_model.dart';
import 'package:admin/src/ui/bookings/filter_booking.dart';
import 'package:admin/src/ui/drawer.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/orders/custom_card.dart';
import 'package:flutter/material.dart';

class BookingsPage extends StatefulWidget {
  final ValueChanged<int> onChangePageIndex;
  final BookingsBloc bookingBloc;
  BookingsPage({Key? key, required this.onChangePageIndex, required this.bookingBloc}) : super(key: key);
  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    print("anil....");
    widget.bookingBloc.fetchItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          widget.bookingBloc.moreItems) {
        widget.bookingBloc.loadMoreOrders();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(onChangePageIndex: widget.onChangePageIndex),
      appBar: AppBar(
        //elevation: 0.5,
        title: Text(AppLocalizations.of(context)
            .translate("bookings"),),
        actions: [
          IconButton(
            icon: Icon(
              Icons.tune,
              semanticLabel: 'filter',
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        FilterBooking(bookingBloc: widget.bookingBloc),
                    fullscreenDialog: true,
                  ));
            },
          )
        ],
      ),
      body: StreamBuilder<List<BookingModel>>(
          stream: widget.bookingBloc.allOrders,
          builder: (context, AsyncSnapshot<List<BookingModel>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.length == 0) {
                return Center(
                    child:
                        Text(AppLocalizations.of(context)
                            .translate("you_dont_have_any_table_bookings"),));
              } else {
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    buildList(snapshot.data!),
                    buildLoadMore(),
                  ],
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  buildList(List<BookingModel> data) {
    return SliverPadding(
      padding: EdgeInsets.all(0.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Column(
              children: [
                ListTile(
                    tileColor: Theme.of(context).cardColor,
                    contentPadding: EdgeInsets.all(16),
                    title: Text(data[index].productTitle),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Text('ID: ' + data[index].id.toString()),
                        SizedBox(
                          height: 5,
                        ),
                        Text('START DATE: ' + data[index].startDate),
                        SizedBox(
                          height: 5,
                        ),
                        Text('END DATE: ' + data[index].endDate),
                        if(data[index].hasPersons)
                        Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text('PERSONS: ' + data[index].persons.toString()),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: getColor(data[index].status, context),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(2.0)),
                              ),
                            ),
                            onPressed: () {
                              _showMyDialog(data[index], (value) {
                                setState(() {
                                  data[index].status = value;
                                });
                                widget.bookingBloc.updateItem(data[index]);
                              });
                            },
                            child: Text(data[index].status.toUpperCase())),
                      ],
                    )),
                Divider(height: 0)
              ],
            );
          },
          childCount: data.length,
        ),
      ),
    );
  }

  buildLoadMore() {
    return SliverPadding(
        padding: EdgeInsets.all(0.0),
        sliver: SliverList(
            delegate: SliverChildListDelegate([
          Container(
              height: 60,
              child: StreamBuilder(
                  stream: widget.bookingBloc.hasMoreOrderItems,
                  builder: (context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData && snapshot.data == true) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Container();
                    }
                  }
                  ))
        ])));
  }

  Future<void> _showMyDialog(BookingModel booking, Function onChange) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return SafeArea(
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  CustomCard(
                    child: RadioListTile<String>(
                        value: 'confirmed',
                        groupValue: booking.status.toLowerCase(),
                        title: Text(AppLocalizations.of(context)
                            .translate("confirmed"),),
                        onChanged: (value) {
                          if(value != null) {
                            setState(() {
                              booking.status = value;
                            });
                          }
                          Navigator.of(context).pop();
                          onChange(booking.status);
                        }),
                  ),
                  CustomCard(
                    child: RadioListTile<String>(
                        value: 'complete',
                        groupValue: booking.status.toLowerCase(),
                        title: Text(AppLocalizations.of(context)
                            .translate("complete"),),
                        onChanged: (value) {
                          if(value != null) {
                            setState(() {
                              booking.status = value;
                            });
                          }
                          Navigator.of(context).pop();
                          onChange(booking.status);
                        }),
                  ),
                  CustomCard(
                    child: RadioListTile<String>(
                        value: 'paid',
                        groupValue: booking.status.toLowerCase(),
                        title: Text(AppLocalizations.of(context)
                            .translate("paid"),),
                        onChanged: (value) {
                          if(value != null) {
                            setState(() {
                              booking.status = value;
                            });
                          }
                          Navigator.of(context).pop();
                          onChange(booking.status);
                        }),
                  ),
                  CustomCard(
                    child: RadioListTile<String>(
                        value: 'unpaid',
                        groupValue: booking.status.toLowerCase(),
                        title: Text(AppLocalizations.of(context)
                            .translate("unpaid"),),
                        onChanged: (value) {
                          if(value != null) {
                            setState(() {
                              booking.status = value;
                            });
                          }
                          Navigator.of(context).pop();
                          onChange(booking.status);
                        }),
                  ),
                  CustomCard(
                    child: RadioListTile<String>(
                        value: 'pending-confirmation',
                        groupValue: booking.status.toLowerCase(),
                        title: Text(AppLocalizations.of(context)
                            .translate("pending"),),
                        onChanged: (value) {
                          if(value != null) {
                            setState(() {
                              booking.status = value;
                            });
                          }
                          Navigator.of(context).pop();
                          onChange(booking.status);
                        }),
                  ),
                  CustomCard(
                    child: RadioListTile<String>(
                        value: 'cancelled',
                        groupValue: booking.status.toLowerCase(),
                        title: Text(AppLocalizations.of(context)
                            .translate("cancelled"),),
                        onChanged: (value) {
                          if(value != null) {
                            setState(() {
                              booking.status = value;
                            });
                          }
                          Navigator.of(context).pop();
                          onChange(booking.status);
                        }),
                  ),
                  CustomCard(
                    child: RadioListTile<String>(
                        value: 'in-cart',
                        groupValue: booking.status.toLowerCase(),
                        title: Text(AppLocalizations.of(context)
                            .translate("in_cart"),),
                        onChanged: (value) {
                          if(value != null) {
                            setState(() {
                              booking.status = value;
                            });
                          }
                          Navigator.of(context).pop();
                          onChange(booking.status);
                        }),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  getColor(String status, BuildContext context) {
    switch (status) {
      case 'processing':
        return Colors.lightGreen;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'failed':
        return Colors.redAccent.withOpacity(0.8);
      case 'on-hold':
        return Colors.deepOrangeAccent;
      case 'pending':
        return Colors.orange;
      case 'refunded':
        return Colors.red;
      default:
        return Colors.green;
    }
  }
}