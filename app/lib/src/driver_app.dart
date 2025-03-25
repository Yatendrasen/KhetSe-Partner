import 'package:admin/src/blocs/orders/orders_bloc.dart';
import 'package:admin/src/config.dart';
import 'package:admin/src/functions.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/snackbar_activity.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:admin/src/ui/accounts/firebase_chat/rooms.dart';
import 'package:admin/src/ui/driver_app/account/account.dart';
import 'package:admin/src/ui/driver_app/orders/accepted_orders.dart';
import 'package:admin/src/ui/driver_app/orders/completed_orders.dart';
import 'package:admin/src/ui/driver_app/orders/new_orders.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/language/language.dart';
import 'package:admin/src/ui/notifiation_new.dart';
import 'package:admin/src/ui/orders/delivery_boys.dart';
import 'package:admin/src/ui/orders/order_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scoped_model/scoped_model.dart';

class DriverApp extends StatefulWidget {
  final OrdersBloc ordersBloc;

  final model = AppStateModel();

  DriverApp({Key? key, required this.ordersBloc}) : super(key: key);
  @override
  State<DriverApp> createState() => _DriverAppState();
}

class _DriverAppState extends State<DriverApp> {

  int _currentIndex = 0;
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  List<Widget> _widgetOptions = [];
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _widgetOptions = <Widget>[
      NewOrdersPage(),
      AcceptedOrdersPage(),
      CompletedOrdersPage(),
      // RoomsPage(),
      AccountPage(),
    ];

    widget.model.messageStream.listen((event) => _manageMessage(event));

    widget.model.getSettings();
    widget.ordersBloc.fetchItems();

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
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.bag),
                      activeIcon: Icon(CupertinoIcons.bag_fill),
                      label: AppLocalizations.of(context).translate("new"),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.bag),
                      activeIcon: Icon(CupertinoIcons.bag_fill),
                      label: AppLocalizations.of(context).translate("accepted"),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.bag),
                      activeIcon: Icon(CupertinoIcons.bag_fill),
                      label: AppLocalizations.of(context).translate("completed"),
                    ),
                    // new BottomNavigationBarItem(
                    //     icon: Icon(Icons.chat_bubble),
                    //     label: AppLocalizations.of(context).translate("chat")),
                    new BottomNavigationBarItem(
                        icon: Icon(Icons.people),
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
            '/NewOrderList': (context) => VendorOrderList(
                onChangePageIndex: _onChangePageIndex,
                ordersBloc: widget.ordersBloc
            ),//DeliveryBoys
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
      widget.ordersBloc.fetchItems();
      player.play();
      final snackBar = SnackBar(
          duration: Duration(minutes: 10),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  parseHtmlString(message.notification!.title!),
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
                    AppLocalizations.of(context).translate("dismiss"),
                    maxLines: 6,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _onMessage(message);
    });

    FirebaseMessaging.instance.getToken().then((String? token) {
      if(token != null) {
        ApiProvider().postWithCookiesEncoded(
            "/wp-admin/admin-ajax.php?action=build-app-online-admin_update_user_meta",
            {'bao_delivery_fcm_token': token});
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
}
