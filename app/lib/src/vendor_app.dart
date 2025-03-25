import 'package:admin/src/blocs/booking/booking_bloc.dart';
import 'package:admin/src/blocs/orders/orders_bloc.dart';
import 'package:admin/src/blocs/products/products_bloc_new.dart';
import 'package:admin/src/config.dart';
import 'package:admin/src/functions.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/models/snackbar_activity.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:admin/src/ui/accounts/firebase_chat/rooms.dart';
import 'package:admin/src/ui/bookings/booking_list.dart';
import 'package:admin/src/ui/category/category_list.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/language/language.dart';
import 'package:admin/src/ui/notifiation_new.dart';
import 'package:admin/src/ui/orders/delivery_boys.dart';
import 'package:admin/src/ui/orders/order_list.dart';
import 'package:admin/src/ui/orders/print_order.dart';
import 'package:admin/src/ui/products/products/product_list.dart';
import 'package:admin/src/ui/report/report.dart';
import 'package:admin/vendor/account/account.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scoped_model/scoped_model.dart';

class VendorApp extends StatefulWidget {
  final OrdersBloc ordersBloc;
  final ProductBloc productBloc;
  final BookingsBloc bookingBloc;
  AppStateModel model = AppStateModel();

  VendorApp({Key? key, required this.ordersBloc, required this.productBloc, required this.bookingBloc}) : super(key: key);
  @override
  State<VendorApp> createState() => _VendorAppState();
}

class _VendorAppState extends State<VendorApp> {

  int _currentIndex = 0;
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  List<Widget> _widgetOptions = [];
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _widgetOptions = <Widget>[
      VendorOrderList(
          onChangePageIndex: _onChangePageIndex,
          ordersBloc: widget.ordersBloc),
      // BookingsPage(onChangePageIndex: _onChangePageIndex,
      //     bookingBloc: widget.bookingBloc),
      ProductsList(productBloc: widget.productBloc, onChangePageIndex: _onChangePageIndex, ordersBloc: widget.ordersBloc),
      AccountPage(),
    ];

    widget.model.messageStream.listen((event) => _manageMessage(event));

    widget.model.getSettings();
    widget.ordersBloc.fetchItems();
    widget.productBloc.fetchProducts();

    configureFcm();
  }

  void _onChangePageIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
        return MaterialApp(
          title: Config().appName,
          scaffoldMessengerKey: _messangerKey,
          debugShowCheckedModeBanner: false,
          theme: model.options.blockTheme?.light != null
              ? model.options.blockTheme!.light
              : ThemeData.light(),
          darkTheme: model.options.blockTheme?.dark != null
              ? model.options.blockTheme!.dark
              : ThemeData.dark(),
          themeMode: model.themeMode,
          home: Scaffold(
            body: _widgetOptions.elementAt(_currentIndex),
            bottomNavigationBar: Builder(
              builder: (context) {
                return BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  onTap: _onChangePageIndex, // new
                  currentIndex: _currentIndex, // new
                  items: [
                    new BottomNavigationBarItem(
                        icon: Icon(Icons.shopping_basket),
                        // title:Text(AppLocalizations.of(context).translate("orders")),
                        label: AppLocalizations.of(context).translate("orders")),
                    // new BottomNavigationBarItem(
                    //     icon: Icon(CupertinoIcons.calendar),
                    //     // title:Text(AppLocalizations.of(context).translate("customers")),
                    //     label: AppLocalizations.of(context).translate("bookings")),
                    new BottomNavigationBarItem(
                        icon: Icon(Icons.grid_on),
                        // title: Text(AppLocalizations.of(context).translate("products")),
                        label: AppLocalizations.of(context).translate("products")),
                    new BottomNavigationBarItem(
                        icon: Icon(Icons.people),
                        // title:Text(AppLocalizations.of(context).translate("customers")),
                        label: AppLocalizations.of(context).translate("account"))
                  ],
                );
              }
            ),
          ),
          routes: {
            '/OrderList': (context) => VendorOrderList(
                onChangePageIndex: _onChangePageIndex,
                ordersBloc: widget.ordersBloc
            ),
            '/ProductList': (context) => ProductsList(productBloc: widget.productBloc, onChangePageIndex: _onChangePageIndex, ordersBloc: widget.ordersBloc),
            '/NewProductList': (context) => ProductsList(productBloc: widget.productBloc, onChangePageIndex: _onChangePageIndex, ordersBloc: widget.ordersBloc,),
            '/NewOrderList': (context) => VendorOrderList(
                onChangePageIndex: _onChangePageIndex,
                ordersBloc: widget.ordersBloc
            ),//DeliveryBoys
            '/CategoryList': (context) => CategoryList(),
            // '/Bookings': (context) => BookingsPage(bookingBloc: widget.bookingBloc, onChangePageIndex: _onChangePageIndex),
            '/Chat': (context) => RoomsPage(),
            '/DeliveryBoys': (context) => DeliveryBoys(),
            '/LanguagePage': (context) => LanguagePage(),
            '/NotificationPage': (context) => NotificationNewPage(),
          },
          locale: widget.model.appLocal,
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ar', ''),
            Locale('pt', ''),
            Locale('es', ''),
            Locale('fr', ''),
            Locale('id', ''),
            Locale('hi', ''),
            Locale('pt', ''),
            Locale('ru', ''),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
        );
      }
    );
  }

  Future<void> configureFcm() async {

    await Future.delayed(Duration(seconds: 5));

    try {
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(announcement: true, criticalAlert: true);
    } catch(e) {}

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _onMessage(message);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final player = AudioPlayer();
      var duration = await player.setAsset('assets/sound/happy-bell.wav');
      player.play();
      if(message.notification?.title != null)
        widget.model.messageFetcher.add(SnackBarActivity(duration: Duration(milliseconds: 4000), success: true, message: message.notification!.title!));
      Order? order = await widget.ordersBloc.fetchNewOrderOnNotification();
      if(order != null) {
        _printOrder(order);
      }
    });

    FirebaseMessaging.instance.getToken().then((String? token) {
      if(token != null) {
        ApiProvider().postWithCookiesEncoded(
            "/wp-admin/admin-ajax.php?action=build-app-online-admin_update_user_meta",
            {'bao_vendor_fcm_token': token});
      }
    });
  }

  void _onMessage(RemoteMessage message) {
    //print('done');
  }

  _manageMessage(SnackBarActivity event) {
    if(event.show && _messangerKey.currentState != null) {
      final snackBar = SnackBar(
          duration: event.duration,
          backgroundColor: event.success ? null :  Colors.red,
          content: Wrap(
            children: [
              Container(
                child: Text(
                  parseHtmlString(event.message),
                  maxLines: 6,
                  style: TextStyle(color: event.success ? null :  Colors.white),
                ),
              ),
              event.loading ? Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                child: Container(
                    height: 20,
                    width: 20,
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2))
                ),
              ) : Container(),
            ],
          ));
      _messangerKey.currentState!.showSnackBar(snackBar);
    } else {
      //_messangerKey.currentState!.hideCurrentSnackBar();
    }
  }

  Future<void> _printOrder(Order order) async {
    Map<String, dynamic> config = Map();

    final NumberFormat currencyFormatter = NumberFormat.simpleCurrency(locale: 'en_US', name: order.currency);
    final list = await PrintOrder().printBluetooth(order, currencyFormatter);

    bool isPrinterConnected = await AppStateModel().bluetoothPrint.isConnected ?? false;

    if(isPrinterConnected == true) {
      AppStateModel().bluetoothPrint.printReceipt(config, list);
    }
  }
}
