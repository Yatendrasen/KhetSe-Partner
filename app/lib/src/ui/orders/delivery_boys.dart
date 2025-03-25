import 'package:admin/src/blocs/orders/select_delivery_boy_bloc.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/customer/customer_model.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:admin/src/ui/driver_orders/driver_orders.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


class DeliveryBoys extends StatefulWidget {
  final DeliveryBoyBloc deliveryBoyBloc = new DeliveryBoyBloc();
  final AppStateModel stateModel = new AppStateModel();
  final apiProvider = ApiProvider();
  final Order? order;
  DeliveryBoys({Key? key, this.order}) : super(key: key);
  @override
  _DeliveryBoysState createState() => _DeliveryBoysState();
}

class _DeliveryBoysState extends State<DeliveryBoys> {
  dynamic distance;
  int _value = 0;

  DateFormat formatter1 = new DateFormat('dd-MM-yyyy  hh:mm a');

  ScrollController _scrollController = new ScrollController();
  bool hasMoreItems = true;
  Icon actionIcon = new Icon(Icons.search);
  @override
  void initState() {
    super.initState();
    print('Distance filter........: ${widget.stateModel.options.distance}');
    widget.deliveryBoyBloc.filter['distance'] = widget.stateModel.options.distance;
    widget.deliveryBoyBloc.filter['role'] = widget.stateModel.options.deliveryBoyRole;
    widget.deliveryBoyBloc.fetchAllCustomers();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.deliveryBoyBloc.loadMore();
      }
    });
  }

  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)
              .translate("delivery_boy"),),
        ),
        body: StreamBuilder(
            stream: widget.deliveryBoyBloc.allCustomers,
            builder: (context, AsyncSnapshot<List<Customer>> snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                  onRefresh: () async {
                    widget.deliveryBoyBloc.fetchAllCustomers();
                    await new Future.delayed(const Duration(seconds: 2));
                  },
                  child: CustomScrollView(
                      controller: _scrollController,
                      slivers: buildList(snapshot)),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  Widget buildListTile(BuildContext context, Customer customer) {
    return MergeSemantics(
      child: ListTile(
        onTap: () => selectDriver(customer),
        leading: customer.firstName.isNotEmpty
            ? ExcludeSemantics(
                child: CircleAvatar(child: Text(customer.firstName[0])))
            : ExcludeSemantics(child: CircleAvatar(child: Text('C'))),
        title: Text(customer.email),
        subtitle: Text(customer.lastName),
      ),
    );
  }

  List<Widget> buildList(AsyncSnapshot<List<Customer>> snapshot) {
    Iterable<Widget> listTiles = snapshot.data!.map<Widget>((Customer item) => buildListTile(context, item));
    listTiles = ListTile.divideTiles(context: context, tiles: listTiles);


    List<Widget> list = <Widget>[];
    if (snapshot.data != null) {
      list.add(SliverToBoxAdapter(
          child: StatefulBuilder(
        builder: (context, state) => Padding(
            padding: EdgeInsets.all(0.0),
            child: Column(
              children: [
                ListTile(
                  leading: Text('${_value.toDouble()}'),
                  trailing: Text('${widget.deliveryBoyBloc.filter['distance'] = widget.stateModel.options.distance} km'),
                  //  Text('${widget.deliveryBoyBloc.filter['distance'] = widget.stateModel.options.distance}km'),
                ),
                Slider(
                  value: _value.toDouble(),
                  min: 0.0,
                  max: widget.stateModel.options.distance != null
                      ? double.parse(widget.stateModel.options.distance)
                      : 10000.0,
                  onChangeEnd: (double newValue) {
                    print('Filter set to distance: $_value km');
                    widget.deliveryBoyBloc.filter['distance'] = _value.toString();
                    widget.deliveryBoyBloc.fetchAllCustomers();
                  },
                  onChanged: (double newValue) {
                    setState(() {
                      _value = newValue.round();
                      print('Distance slider updated: $_value km');
                      widget.deliveryBoyBloc.filter['distance'] = _value.toString();
                    });
                  },
                )
              ],
            )),
      )));
      list.add(SliverPadding(
        padding: EdgeInsets.all(0.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {

              bool online = false;
              if(snapshot.data![index].metaData.any((element) => element.key == '_bao_delivery_online')) {
                online = snapshot.data![index].metaData.firstWhere((element) => element.key == '_bao_delivery_online').value == '1';
              }

              String? address;
              if(snapshot.data![index].metaData.any((element) => element.key == 'bao_delivery_address')) {
                address = snapshot.data![index].metaData.firstWhere((element) => element.key == 'bao_delivery_address').value;
              }

              String? lastActive;
              if(snapshot.data![index].metaData.any((element) => element.key == 'wc_last_active')) {
                lastActive = snapshot.data![index].metaData.firstWhere((element) => element.key == 'wc_last_active').value;
              }


              return ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: snapshot.data![index].firstName.isNotEmpty
                    ? ExcludeSemantics(
                        child: CircleAvatar(
                            child: Text(
                                snapshot.data![index].firstName[0])))
                    : ExcludeSemantics(child: CircleAvatar(child: Text('C'))),
                title: Text(snapshot.data![index].lastName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(address != null)
                        Text(address),
                        if(lastActive != null)
                          Row(
                            children: [
                              if(online)
                                Icon(CupertinoIcons.dot_square_fill, color: Colors.green),
                              if(!online)
                                Icon(CupertinoIcons.dot_square_fill, color: Theme.of(context).colorScheme.error),
                              Text(formatter1.format(DateTime.fromMillisecondsSinceEpoch(int.parse(lastActive) * 1000))),
                            ],
                          ),
                        Wrap(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if(widget.order != null)
                            TextButton.icon(onPressed: () {
                              selectDriver(snapshot.data![index]);
                            }, icon: Icon(Icons.directions_bike), label: Text(AppLocalizations.of(context)
                  .translate("assign"),),),
                            TextButton.icon(onPressed: () {
                              final Uri emailLaunchUri = Uri(
                                scheme: 'tel',
                                path: snapshot.data![index].billing.phone,
                              );
                              launchUrl(emailLaunchUri);
                            }, icon: Icon(CupertinoIcons.phone_fill), label: Text(AppLocalizations.of(context)
                  .translate("call"),)),
                            TextButton.icon(onPressed: () async {

                              String? latitude;
                              if(snapshot.data![index].metaData.any((element) => element.key == 'bao_delivery_latitude')) {
                                latitude = snapshot.data![index].metaData.firstWhere((element) => element.key == 'bao_delivery_latitude').value;
                              }

                              String? longitude;
                              if(snapshot.data![index].metaData.any((element) => element.key == 'bao_delivery_longitude')) {
                                longitude = snapshot.data![index].metaData.firstWhere((element) => element.key == 'bao_delivery_longitude').value;
                              }

                              if(latitude != null && longitude != null) {
                                var url = "https://www.google.com/maps?saddr=My+Location&daddr=${latitude},${longitude}";
                                await launch(url);
                              } else if(address != null) {
                                var url = "https://www.google.com/maps?saddr=My+Location&daddr=${address}";
                                await launchUrl(Uri.parse(url));
                              }

                            }, icon: Icon(CupertinoIcons.map), label: Text(AppLocalizations.of(context)
                  .translate("track"),)),
                            TextButton.icon(onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DriverOrders(driverId: snapshot.data![index].id.toString())));
                            }, icon: Icon(Icons.list_alt), label: Text(AppLocalizations.of(context)
                  .translate("orders"),),),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
            childCount: snapshot.data!.length,
          ),
        ),
      ));
    }
    return list;
  }

  selectDriver(Customer customer) {
    widget.deliveryBoyBloc.assignDeliveryBoy(customer, widget.order!);
    //Navigator.of(context).pop(customer);
  }

  buildLoadMore() {
    return SliverPadding(
        padding: EdgeInsets.all(0.0),
        sliver: SliverList(
            delegate: SliverChildListDelegate([
          Container(
              height: 60,
              child: hasMoreItems
                  ? Center(child: CircularProgressIndicator())
                  : Container()),
        ])));
  }
}
