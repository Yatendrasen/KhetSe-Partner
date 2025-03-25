import 'package:admin/src/blocs/orders/orders_bloc.dart';
import 'package:admin/src/functions.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:admin/src/ui/driver_app/orders/order_detail.dart';
import 'package:admin/src/ui/orders/custom_card.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scoped_model/scoped_model.dart';

class NewOrdersPage extends StatefulWidget {
  final OrdersBloc ordersBloc = OrdersBloc();
  @override
  _NewOrdersPageState createState() => _NewOrdersPageState();
}

class _NewOrdersPageState extends State<NewOrdersPage> {
  ScrollController _scrollController = new ScrollController();
  DateFormat formatter1 = new DateFormat('dd-MM-yyyy  hh:mm a');
  AppStateModel appStateModel = AppStateModel();
  final player = AudioPlayer();

  @override
  void initState() {
    widget.ordersBloc.filter['new'] = true;
    widget.ordersBloc.filter['status'] =
        appStateModel.options.newOrderStatus[0].key;
    getCurrentLocation();

    configureFcm();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          widget.ordersBloc.moreItems) {
        widget.ordersBloc.loadMore();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: InkWell(
          onTap: () => getCurrentLocation(),
          child: Row(
            children: [
              Icon(Icons.location_on),
              SizedBox(
                width: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 130,
                child: ScopedModelDescendant<AppStateModel>(
                    builder: (context, child, model) {
                  if (model.customerLocation['address'] != null)
                    return Text(
                      model.customerLocation['address'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14),
                    );
                  else
                    return Text('Select Location',
                        style: TextStyle(fontSize: 14));
                }),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                getCurrentLocation();
              },
              icon: Icon(CupertinoIcons.refresh))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await widget.ordersBloc.fetchItems();
          return;
        },
        child: StreamBuilder<List<Order>>(
            stream: widget.ordersBloc.results,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.length > 0) {
                  return CustomScrollView(
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                        return buildOrder(context, snapshot.data![index]);
                      }, childCount: snapshot.data!.length)),
                      widget.ordersBloc.moreItems
                          ? SliverToBoxAdapter(
                              child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Center(child: CircularProgressIndicator()),
                            ))
                          : SliverToBoxAdapter()
                    ],
                  );
                } else {
                  return Center(child: Text('No Orders'));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Widget buildOrder(BuildContext context, Order order) {
    final NumberFormat currencyFormatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString(),
        name: order.currency);

    return CustomCard(
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(16),
            onTap: () => openDetailPage(order),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: getColor(order.status!, context),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {},
                      child: Text(
                        '${order.number.toString()}  ${order.status!.toUpperCase()}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                        order.billing.firstName + ' ' + order.billing.lastName),
                  ],
                ),
                TextButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).textTheme.titleMedium!.color,
                      /*shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      ),*/
                    ),
                    onPressed: () {},
                    child: Text(
                      currencyFormatter.format(order.total),
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(formatter1.format(order.dateCreated)),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.ordersBloc.driverAcceptOrder(order);
                  },
                  child: Text('ACCEPT'),
                ),
              ],
            ),
          ),
          Divider(height: 0)
        ],
      ),
    );
  }

  openDetailPage(Order order) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderDetail(order: order, ordersBloc: widget.ordersBloc);
    }));
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

  getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      //TODO Reuest to enable Service
      //Fluttertoast.showToast(msg: 'please keep your location on');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      //TODO Request Permission again
      //Fluttertoast.showToast(msg: 'Location permission is denied');
    }

    if (permission == LocationPermission.deniedForever) {
      //TODO Request Permission again
      //Fluttertoast.showToast(msg: 'Location permission is denied Forever');
    }

    var position = await Geolocator.getCurrentPosition();

    try {
      var location = new Map<String, dynamic>();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      location['latitude'] = position.latitude.toString();
      location['longitude'] = position.longitude.toString();
      location['address'] =
          "${place.name} , ${place.locality} , ${place.subLocality}, ${place.postalCode}";

      //print(location);

      appStateModel.setPickedLocation(location);
      widget.ordersBloc.fetchItems();
    } catch (e) {
      //print(e);
    }
  }

  Future<void> configureFcm() async {
    await Future.delayed(Duration(seconds: 10));

    try {
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(announcement: true, criticalAlert: true);
    } catch(e) {}

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _onMessage(message);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      widget.ordersBloc.fetchItems();
      var duration = await player.setAsset('assets/sound/happy-bell.wav');
      //await player.setLoopMode(LoopMode.one);
      player.play();
      String title = message.notification?.title != null ? message.notification!.title! : 'New Order';
      final snackBar = SnackBar(
          duration: Duration(minutes: 10),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  parseHtmlString(title),
                  maxLines: 6,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () {
                    player.stop();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  child: Text(
                    'DISMISS',
                    maxLines: 6,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      /*widget.vendorBloc.getOrders();
      var duration = await player.setAsset('assets/sound/happy-bell.wav');
      await player.setLoopMode(LoopMode.one);
      player.play();
      AppStateModel().messageFetcher.add(SnackBarActivity(duration: Duration(milliseconds: 4000), success: true, message: message.notification.title));*/
      _onMessage(message);
    });

    FirebaseMessaging.instance.getToken().then((String? token) {
      assert(token != null);
      appStateModel.fcmToken = token!;
      ApiProvider().postWithCookiesEncoded("/wp-admin/admin-ajax.php?action=build-app-online-admin_update_user_meta", {'bao_delivery_fcm_token': token});
    });
  }

  void _onMessage(RemoteMessage message) {
    //print('done');
  }

  Future<void> _showNotification(RemoteNotification notification) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: notification.title != null
              ? Text(notification.title.toString())
              : Container(),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (notification.title != null)
                  Text(notification.title.toString()),
                if (notification.body != null)
                  Text(notification.body.toString()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
