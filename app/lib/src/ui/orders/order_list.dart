import 'package:admin/src/blocs/orders/orders_bloc.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/ui/drawer.dart';
import 'package:admin/src/ui/orders/custom_card.dart';
import 'package:admin/src/ui/orders/delivery_boys.dart';
import 'package:admin/src/ui/products/products/search_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:intl/intl.dart';
import 'filter_order.dart';
import 'order_detail.dart';
import 'package:admin/src/functions.dart';

class VendorOrderList extends StatefulWidget {
  final ValueChanged<int> onChangePageIndex;
  final OrdersBloc ordersBloc;
  VendorOrderList(
      {Key? key,
      required this.ordersBloc,
        required this.onChangePageIndex})
      : super(key: key);

  @override
  _VendorOrderListState createState() => _VendorOrderListState();
}

class _VendorOrderListState extends State<VendorOrderList> {
  ScrollController _scrollController = new ScrollController();
  bool _hideSearch = true;
  Widget appBarTitle = demo();
  Icon actionIcon = new Icon(Icons.search);
 // bool hasMoreOrder = true;
  final appStateModel = AppStateModel();
  TextEditingController searchTextController = TextEditingController();
  DateFormat formatter1 = new DateFormat('dd-MM-yyyy  hh:mm a');

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          widget.ordersBloc.hasMoreItems.value) {
        await widget.ordersBloc.loadMore();
        /*if (!hasMoreOrder) {
          setState(() {});
        }*/
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryIconThemeColor = Theme.of(context).primaryIconTheme.color!;
    return Scaffold(
      drawer: MyDrawer(onChangePageIndex: widget.onChangePageIndex),
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsetsDirectional.only(start: 16),
          child: SearchBarField(
            hintText: AppLocalizations.of(context)
                .translate("search_orders"),
            searchTextController: searchTextController,
            autofocus: false,
            onChanged: (text) {
              widget.ordersBloc.filter['search'] = text;
              widget.ordersBloc.fetchItems();
            },
          ),
        ),
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
                        FilterOrder(ordersBloc: widget.ordersBloc),
                    fullscreenDialog: true,
                  ));
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          widget.ordersBloc.fetchItems();
          await new Future.delayed(const Duration(seconds: 2));
        },
        child: StreamBuilder(
            stream: widget.ordersBloc.results,
            builder: (context, AsyncSnapshot<List<Order>> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data!.length == 0) {
                  return Center(child: Text(AppLocalizations.of(context)
                      .translate("no_orders"),));
                } else {
                  return CustomScrollView(
                    controller: _scrollController,
                    slivers: <Widget>[
                      buildList(snapshot),
                    ],
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/ProductList');
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }

  buildList(AsyncSnapshot<List<Order>> snapshot) {
    return SliverPadding(
      padding: EdgeInsets.all(0.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return buildOrder1(snapshot.data![index], context);
          },
          childCount: snapshot.data!.length,
        ),
      ),
    );
  }

  Widget buildOrder1(Order order, BuildContext context) {
    final NumberFormat currencyFormatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString(),
        name: order.currency);

    return CustomCard(
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        onTap: () => openDetailPage(order),
        /*title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(order.number.toString(), style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 8,),
              ],
            ),
            Text(currencyFormatter.format(order.total), style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),*/
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(order.number.toString(), style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600
                    )),
                    SizedBox(height: 8,),
                  ],
                ),
                Text(currencyFormatter.format(order.total), style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                   // fontWeight: FontWeight.w600
                )),
              ],
            ),
            Text(order.billing.firstName + ' ' + order.billing.lastName),
            Text(formatter1.format(order.dateCreated)),
            order.paymentMethodTitle.isNotEmpty ? Text(order.paymentMethodTitle) : Container(),
            SizedBox(height: 4),
            Wrap(
                runSpacing: 10,
                spacing: 10,
                children: order.shippingLines.map((e) => Container(child: Text(parseHtmlString(order.shippingLines[0].methodTitle)))).toList()),
            order.metaData.any((element) => element.key == 'dokan_delivery_time_date')? Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                if(order.metaData.any((element) => element.key == 'dokan_delivery_time_date'))
                  Text("DELIVERY TIME: ", style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600)),
                if(order.metaData.any((element) => element.key == 'dokan_delivery_time_slot'))
                  Text(order.metaData.firstWhere((element) => element.key == 'dokan_delivery_time_slot').value, style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600)),
                if(order.metaData.any((element) => element.key == 'dokan_delivery_time_date'))
                  Text(order.metaData.firstWhere((element) => element.key == 'dokan_delivery_time_date').value, style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600)),
              ],
            ) : order.metaData.any((element) => element.key == 'jckwds_date') ? Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                if(order.metaData.any((element) => element.key == 'jckwds_date'))
                  Text("DELIVERY TIME: ", style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600)),
                if(order.metaData.any((element) => element.key == 'jckwds_date'))
                  Text(order.metaData.firstWhere((element) => element.key == 'jckwds_date').value, style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600)),
                if(order.metaData.any((element) => element.key == 'jckwds_timeslot'))
                  Text(order.metaData.firstWhere((element) => element.key == 'jckwds_timeslot').value, style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600)),
              ],
            ) : Container(),
            SizedBox(height: 8),
            Row(
              children: [
                TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getColor(order.status!, context),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    ),
                  ),
                  onPressed: () {
                    _showMyDialog(order, (value) {
                      setState(() {
                        order.status = value;
                      });
                      widget.ordersBloc.updateItem(order);
                    });
                  },
                  child: Text(order.status!.toUpperCase()),
                ),
                Spacer(),

              ],
            )
          ],
        ),
      ),
    );
  }

  openDetailPage(Order order) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderDetail(order: order, ordersBloc: widget.ordersBloc);
    }));
  }

  buildLoadMore() {
    return StreamBuilder<bool>(
      stream: widget.ordersBloc.hasMoreItems,
      builder: (context, snapshot) {
        return SliverPadding(
            padding: EdgeInsets.all(0.0),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              Container(
                  height: 60,
                  child: snapshot.data == true
                      ? Center(child: CircularProgressIndicator())
                      : Container()),
            ])));
      }
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
        return Colors.red;
      case 'on-hold':
        return Colors.deepOrangeAccent;
      case 'pending':
        return Colors.orange;
      case 'refunded':
        return Colors.red;
      case 'cancel-request':
        return Colors.deepOrangeAccent;
      default:
        return Colors.green;
    }
  }

  static Widget demo() {
    return Builder(builder: (context) {
      return new Text(AppLocalizations.of(context).translate("orders"));
    });
  }


  Future<void> _showMyDialog(Order order, Function onChange) async {

    List<Widget> list = [];

    if(appStateModel.options.orderStatuses.length > 0) {
      appStateModel.options.orderStatuses.forEach((element) {
        list.add(CustomCard(
          child: RadioListTile<String>(
              value: element.key,
              groupValue: order.status,
              title: Text(element.value!),
              onChanged: (value) {
                if(value != null) {
                  setState(() {
                    order.status = value;
                  });
                }
                Navigator.of(context).pop();
                onChange(order.status);
              }),
        ));
      });

      return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: ListBody(children: list),
              ),
            );
          });
        },
      );
    } else {
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
                          value: AppLocalizations.of(context)
                              .translate("pending"),
                          groupValue: order.status,
                          title: Text(AppLocalizations.of(context)
                              .translate("pending"),),
                          onChanged: (value) {
                            if(value != null) {
                              setState(() {
                                order.status = value;
                              });
                            }
                            Navigator.of(context).pop();
                            onChange(order.status);
                          }),
                    ),
                    CustomCard(
                      child: RadioListTile<String>(
                          value: 'processing',
                          groupValue: order.status,
                          title: Text(AppLocalizations.of(context)
                              .translate("processing"),),
                          onChanged: (value) {
                            if(value != null) {
                              setState(() {
                                order.status = value;
                              });
                            }
                            Navigator.of(context).pop();
                            onChange(order.status);
                          }),
                    ),
                    CustomCard(
                      child: RadioListTile<String>(
                          value: 'on-hold',
                          groupValue: order.status,
                          title: Text(AppLocalizations.of(context)
                              .translate("on_hold"),),
                          onChanged: (value) {
                            if(value != null) {
                              setState(() {
                                order.status = value;
                              });
                            }
                            Navigator.of(context).pop();
                            onChange(order.status);
                          }),
                    ),
                    CustomCard(
                      child: RadioListTile<String>(
                          value: 'completed',
                          groupValue: order.status,
                          title: Text(AppLocalizations.of(context)
                              .translate("completed"),),
                          onChanged: (value) {
                            if(value != null) {
                              setState(() {
                                order.status = value;
                              });
                            }
                            Navigator.of(context).pop();
                            onChange(order.status);
                          }),
                    ),
                    CustomCard(
                      child: RadioListTile<String>(
                          value: 'cancelled',
                          groupValue: order.status,
                          title: Text(AppLocalizations.of(context)
                              .translate("cancelled"),),
                          onChanged: (value) {
                            if(value != null) {
                              setState(() {
                                order.status = value;
                              });
                            }
                            Navigator.of(context).pop();
                            onChange(order.status);
                          }),
                    ),
                    CustomCard(
                      child: RadioListTile<String>(
                          value: 'refunded',
                          groupValue: order.status,
                          title: Text(AppLocalizations.of(context)
                              .translate("refunded"),),
                          onChanged: (value) {
                            if(value != null) {
                              setState(() {
                                order.status = value;
                              });
                            }
                            Navigator.of(context).pop();
                            onChange(order.status);
                          }),
                    ),
                    CustomCard(
                      child: RadioListTile<String>(
                          value: 'failed',
                          groupValue: order.status,
                          title: Text(AppLocalizations.of(context)
                              .translate("failed"),),
                          onChanged: (value) {
                            if(value != null) {
                              setState(() {
                                order.status = value;
                              });
                            }
                            Navigator.of(context).pop();
                            onChange(order.status);
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

  }

  Widget assign(BuildContext context, Order order) {

    bool driver = false;

    driver = order.metaData.any((element) => element.key == 'delivery_boy');

    return  Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        backgroundColor: driver ? Theme.of(context).colorScheme.secondary : Theme.of(context).focusColor,
        child: InkWell(
            onTap: () {},
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return DeliveryBoys(order: order);
                      }));
                },
                icon: Icon(
                    Icons.directions_bike,
                    color: driver ? Theme.of(context).colorScheme.onSecondary : null
                ))),
      ),
    );
  }
}
