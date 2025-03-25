import 'dart:io';
import 'package:admin/src/app.dart';
import 'package:admin/src/blocs/booking/booking_bloc.dart';
import 'package:admin/src/blocs/customers/customer_bloc.dart';
import 'package:admin/src/blocs/orders/orders_bloc.dart';
import 'package:admin/src/blocs/products/products_bloc_new.dart';
import 'package:admin/src/blocs/report/report_bloc.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'src/admin_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //TODO UnCommet When Submit(After Integrating FireBase)
  await Firebase.initializeApp();
  AppStateModel model = AppStateModel();
  var apiProvider = new ApiProvider();
  await apiProvider.initializationDone();


  await model.fetchLocale();
  model.getOptions();
  ReportBloc reportBloc = ReportBloc();
  CustomerBloc customersBloc = CustomerBloc();
  OrdersBloc ordersBloc = OrdersBloc();
  ProductBloc productBloc = ProductBloc();
  BookingsBloc bookingBloc = BookingsBloc();

  //HttpOverrides.global = new MyHttpOverrides();
  runApp(App(bookingBloc: bookingBloc, reportBloc: reportBloc, customersBloc: customersBloc, ordersBloc: ordersBloc, productBloc: productBloc,  model: model));
}

/*
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}*/
