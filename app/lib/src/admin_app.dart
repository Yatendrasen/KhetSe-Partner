import 'package:admin/src/blocs/booking/booking_bloc.dart';
import 'package:admin/src/blocs/customers/customer_bloc.dart';
import 'package:admin/src/blocs/orders/orders_bloc.dart';
import 'package:admin/src/blocs/report/report_bloc.dart';
import 'package:admin/src/functions.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:admin/src/ui/accounts/firebase_chat/rooms.dart';
import 'package:admin/src/ui/bookings/booking_list.dart';
import 'package:admin/src/ui/customers/newsletter.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/blocs/products/products_bloc_new.dart';
import 'package:admin/src/ui/notifiation_new.dart';
import 'package:admin/src/ui/orders/delivery_boys.dart';
import 'package:admin/src/ui/orders/print_order.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:admin/src/ui/category/category_list.dart';
import 'package:admin/src/ui/colors.dart';
import 'package:admin/src/ui/coupons/coupon_list.dart';
import 'package:admin/src/ui/customers/customer_list.dart';
import 'package:admin/src/ui/payment_gateways/payment_list.dart';
import 'package:admin/src/ui/report/report.dart';
import 'package:admin/src/ui/products/products/product_list.dart';
import 'models/app_state_model.dart';
import 'models/snackbar_activity.dart';
import 'ui/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/language/language.dart';
import 'ui/orders/order_list.dart';

class AdminApp extends StatefulWidget {
  final ReportBloc reportBloc;
  AppStateModel model = AppStateModel();
  final CustomerBloc customersBloc;
  final OrdersBloc ordersBloc;
  final ProductBloc productBloc;
  final BookingsBloc bookingBloc;
  AdminApp({Key? key, required this.reportBloc, required this.customersBloc, required this.ordersBloc, required this.productBloc, required this.bookingBloc}) : super(key: key);


  @override
  _AdminAppState createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {

  bool _requireConsent = true;
  bool _enableConsentButton = false;
  int _currentIndex = 0;
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      Report(
          onChangePageIndex: _onChangePageIndex,
          reportBloc: widget.reportBloc),
      VendorOrderList(
          onChangePageIndex: _onChangePageIndex,
          ordersBloc: widget.ordersBloc),
      // BookingsPage(onChangePageIndex: _onChangePageIndex,
      //     bookingBloc: widget.bookingBloc),
      ProductsList(productBloc: widget.productBloc, onChangePageIndex: _onChangePageIndex, ordersBloc: widget.ordersBloc),
      CustomerList(
          onChangePageIndex: _onChangePageIndex,
          customersBloc: widget.customersBloc),
      //TODO admin and Vendor app
      //RoomsPage(),
    ];

    widget.model.messageStream.listen((event) => _manageMessage(event));
    initAdminApp();
    configureFcm();
  }

  initAdminApp() async {
    final prefs = await SharedPreferences.getInstance();
    int swatchIndex = prefs.getInt('primarySwatchIndex') ?? 0;
    MaterialColor primarySwatch = allPalettes[swatchIndex].primary;

    await widget.reportBloc.fetchSalesReport('week');
    widget.model.getSettings();
    //widget.reportBloc.periodType.add('month');
    widget.ordersBloc.fetchItems();
    widget.productBloc.fetchProducts();
    widget.customersBloc.fetchItems();

  }


  void onChangeSwatch(Palette pallet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('primarySwatchIndex', allPalettes.indexOf(pallet));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppStateModel>(
      model: widget.model,
      child: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) => MaterialApp(
          scaffoldMessengerKey: _messangerKey,
          debugShowCheckedModeBanner: false,
          title: 'Admin App',
          themeMode: model.themeMode,
          // Made for FlexColorScheme version 7.0.1. Make sure you
// use same or higher package version, but still same major version.
// If you use a lower version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
          theme: FlexThemeData.light(
            scheme: FlexScheme.materialBaseline,
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 4,
            bottomAppBarElevation: 0.0,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 10,
              blendOnColors: false,
              useM2StyleDividerInM3: true,
              inputDecoratorIsFilled: false,
              appBarScrolledUnderElevation: 0.0,
              drawerRadius: 0.0,
              drawerElevation: 0.0,
              drawerWidth: 307.0,
            ),
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            swapLegacyOnMaterial3: true,
            // To use the playground font, add GoogleFonts package and uncomment
            // fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.materialBaseline,
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 13,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 20,
              useM2StyleDividerInM3: true,
              inputDecoratorIsFilled: false,
              drawerRadius: 0.0,
              drawerElevation: 0.0,
              drawerWidth: 307.0,
            ),
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            swapLegacyOnMaterial3: true,
            // To use the Playground font, add GoogleFonts package and uncomment
            // fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,

          //TODO Uncomment for admin only app
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
                      icon: Icon(Icons.insert_chart),
                      label: AppLocalizations.of(context).translate("report")
                      //  title: Text(AppLocalizations.of(context).translate("report"),)
                    ),
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
                        label: AppLocalizations.of(context).translate("customers")),

                    //TODO admin and vendor app
                    /*new BottomNavigationBarItem(
                        icon: Icon(Icons.chat_bubble),
                        // title:Text(AppLocalizations.of(context).translate("customers")),
                        label: "Chat")*/
                  ],
                );
              }
            ),
            //TODO Uncomment for admin only app
          ),
          routes: {
            '/Report': (context) => Report(
                reportBloc: widget.reportBloc, onChangePageIndex: _onChangePageIndex),
            '/OrderList': (context) => VendorOrderList(
                onChangePageIndex: _onChangePageIndex,
                ordersBloc: widget.ordersBloc
            ),

            '/Bookings': (context) => BookingsPage(onChangePageIndex: _onChangePageIndex,
                bookingBloc: widget.bookingBloc),

            '/ProductList': (context) => ProductsList(productBloc: widget.productBloc, onChangePageIndex: _onChangePageIndex, ordersBloc: widget.ordersBloc),

            '/Chat': (context) => RoomsPage(),
            '/NewProductList': (context) => ProductsList(productBloc: widget.productBloc, onChangePageIndex: _onChangePageIndex, ordersBloc: widget.ordersBloc,),
            '/NewOrderList': (context) => VendorOrderList(
                onChangePageIndex: _onChangePageIndex,
                ordersBloc: widget.ordersBloc
            ),//DeliveryBoys
            '/DeliveryBoys': (context) => DeliveryBoys(),
            '/CategoryList': (context) => CategoryList(),
            '/CustomerList': (context) => CustomerList(
                customersBloc: widget.customersBloc,
                onChangePageIndex: _onChangePageIndex),
            '/NewsLetter': (context) => NewsLetter(
                customersBloc: widget.customersBloc),
            '/PaymentGatewayList': (context) => PaymentGatewayList(),
            '/Coupons': (context) => CouponList(),
            '/PaletteTabView': (context) => ColorsDemo(
              onChangeSwatch: onChangeSwatch,
            ),
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
        ),
      ),
    );
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

  void _onChangePageIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  Future<void> configureFcm() async {

    await Future.delayed(Duration(seconds: 3));

    final sound = 'bell.wav';

    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      announcement: true, criticalAlert: true,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {_onMessage(message);});

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
            {'bao_admin_fcm_token': token});
      }
    });
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

  Future<void> _onMessage(RemoteMessage message) async {

  }
}
