import 'package:admin/src/admin_app.dart';
import 'package:admin/src/blocs/booking/booking_bloc.dart';
import 'package:admin/src/blocs/customers/customer_bloc.dart';
import 'package:admin/src/blocs/orders/orders_bloc.dart';
import 'package:admin/src/blocs/products/products_bloc_new.dart';
import 'package:admin/src/blocs/report/report_bloc.dart';
import 'package:admin/src/config.dart';
import 'package:admin/src/driver_app.dart';
import 'package:admin/src/functions.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/snackbar_activity.dart';
import 'package:admin/src/ui/accounts/login/login.dart';
import 'package:admin/src/vendor_app.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';

class App extends StatefulWidget {
  final BookingsBloc bookingBloc;
  final ReportBloc reportBloc;
  final AppStateModel model;

  final CustomerBloc customersBloc;
  final OrdersBloc ordersBloc;
  final ProductBloc productBloc;
  const App(
      {Key? key,
      required this.reportBloc,
      required this.model,
      required this.customersBloc,
      required this.ordersBloc,
      required this.productBloc, required this.bookingBloc})
      : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    widget.model.getSettings();
    widget.model.messageStream.listen((event) => _manageMessage(event));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppStateModel>(
      model: widget.model,
      child: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            if (model.options.info != null && model.user != null) {
              if (model.user!.role == 'administrator') {
                return AdminApp(
                  reportBloc: widget.reportBloc,
                  ordersBloc: widget.ordersBloc,
                  customersBloc: widget.customersBloc,
                  productBloc: widget.productBloc,
                  bookingBloc: widget.bookingBloc,
                );
              } else if (model.vendorRoles.contains(model.user!.role)) {
                return VendorApp(
                  ordersBloc: widget.ordersBloc,
                  productBloc: widget.productBloc,
                  bookingBloc: widget.bookingBloc,

                );
              } else if (model.user!.role == model.options.deliveryBoyRole) {
                return DriverApp(
                  ordersBloc: widget.ordersBloc,
                );
              } else {
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
                  home: LoginPage(),
                );
              }
            } else {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    primaryColor: Colors.white,
                    appBarTheme: AppBarTheme(elevation: 0)),
                darkTheme: ThemeData(
                    primaryColor: Colors.white,
                    appBarTheme: AppBarTheme(elevation: 0)),
                home: Material(child: Builder(builder: (context) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    themeMode: model.themeMode,
                    theme: FlexThemeData.light(
                      useMaterial3: true,
                      scheme: FlexScheme.blue,
                      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
                      blendLevel: 20,
                      appBarOpacity: 0.95,
                      lightIsWhite: true,
                      colorScheme: ColorScheme(
                        brightness: Brightness.light,
                        primary: Color(0xff1565c0),
                        onPrimary: Color(0xffffffff),
                        primaryContainer: Color(0xff90caf9),
                        onPrimaryContainer: Color(0xff192228),
                        secondary: Color(0xff039be5),
                        onSecondary: Color(0xffffffff),
                        secondaryContainer: Color(0xffcbe6ff),
                        onSecondaryContainer: Color(0xff222728),
                        tertiary: Color(0xff0277bd),
                        onTertiary: Color(0xffffffff),
                        tertiaryContainer: Color(0xffbedcff),
                        onTertiaryContainer: Color(0xff202528),
                        error: Color(0xffb00020),
                        onError: Color(0xffffffff),
                        errorContainer: Color(0xfffcd8df),
                        onErrorContainer: Color(0xff282526),
                        outline: Color(0xff5c5c62),
                        background: Color(0xffffffff),
                        onBackground: Color(0xff121213),
                        surface: Color(0xffffffff),
                        onSurface: Color(0xff090909),
                        surfaceVariant: Color(0xffffffff),
                        onSurfaceVariant: Color(0xff121213),
                        inverseSurface: Color(0xff060708),
                        onInverseSurface: Color(0xfff5f5f5),
                        inversePrimary: Color(0xffaedfff),
                        shadow: Color(0xff000000),
                      ),
                      subThemesData: const FlexSubThemesData(
                        blendOnLevel: 20,
                        blendOnColors: false,
                        inputDecoratorIsFilled: false,
                        inputDecoratorBorderType: FlexInputBorderType.underline,
                        fabRadius: 80.0,
                      ),
                      visualDensity: FlexColorScheme.comfortablePlatformDensity,
                      // To use the playground font, add GoogleFonts package and uncomment
                      fontFamily: GoogleFonts.lato().fontFamily,

                    ),
                    darkTheme: FlexThemeData.dark(
                      useMaterial3: true,
                      scheme: FlexScheme.blue,
                      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
                      blendLevel: 15,
                      appBarStyle: FlexAppBarStyle.background,
                      appBarOpacity: 0.90,
                      colorScheme: ColorScheme(
                        brightness: Brightness.dark,
                        primary: Color(0xff90caf9),
                        onPrimary: Color(0xff161d1e),
                        primaryContainer: Color(0xff0d47a1),
                        onPrimaryContainer: Color(0xffd3e0f6),
                        secondary: Color(0xff81d4fa),
                        onSecondary: Color(0xff151e1e),
                        secondaryContainer: Color(0xff004b73),
                        onSecondaryContainer: Color(0xffd0e1eb),
                        tertiary: Color(0xffe1f5fe),
                        onTertiary: Color(0xff1e1e1e),
                        tertiaryContainer: Color(0xff1a567d),
                        onTertiaryContainer: Color(0xffd6e4ed),
                        error: Color(0xffcf6679),
                        onError: Color(0xff1e1214),
                        errorContainer: Color(0xffb1384e),
                        onErrorContainer: Color(0xfff9dde2),
                        outline: Color(0xff959999),
                        background: Color(0xff181b1e),
                        onBackground: Color(0xffe3e4e4),
                        surface: Color(0xff141617),
                        onSurface: Color(0xfff1f1f1),
                        surfaceVariant: Color(0xff171b1d),
                        onSurfaceVariant: Color(0xffe3e4e4),
                        inverseSurface: Color(0xfffbfdfe),
                        onInverseSurface: Color(0xff0e0e0e),
                        inversePrimary: Color(0xff4a6373),
                        shadow: Color(0xff000000),
                      ),
                      subThemesData: const FlexSubThemesData(
                        blendOnLevel: 30,
                        inputDecoratorIsFilled: false,
                        inputDecoratorBorderType: FlexInputBorderType.underline,
                        fabRadius: 40.0,
                      ),
                      visualDensity: FlexColorScheme.comfortablePlatformDensity,
                      // To use the playground font, add GoogleFonts package and uncomment
                      fontFamily: GoogleFonts.lato().fontFamily,
                    ),
                    home: Material(child: Builder(builder: (context) {
                      return Scaffold(
                        backgroundColor: Colors.white,
                        body: AnnotatedRegion<SystemUiOverlayStyle>(
                          value: SystemUiOverlayStyle.light,
                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Container(
                                    child: Image.asset('assets/images/splash.png',
                                        fit: BoxFit.fitWidth)),
                              )),
                        ),
                      );
                    })),
                  );
                })),
              );
            }
      }),
    );
  }

  _manageMessage(SnackBarActivity event) {
    if (event.show) {
      final snackBar = SnackBar(
          duration: event.duration,
          backgroundColor: event.success ? null : Colors.red,
          content: Wrap(
            children: [
              Container(
                child: Text(
                  parseHtmlString(event.message),
                  maxLines: 6,
                  style: TextStyle(color: event.success ? null : Colors.white),
                ),
              ),
              event.loading
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Center(
                              child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: event.success
                                ? AlwaysStoppedAnimation<Color>(
                                    Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color!)
                                : AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.onError),
                          ))),
                    )
                  : Container(),
            ],
          ));
      if (_messangerKey.currentState != null)
        _messangerKey.currentState!.showSnackBar(snackBar);
    } else {
      if (_messangerKey.currentState != null)
        _messangerKey.currentState!.hideCurrentSnackBar();
    }
  }
}
