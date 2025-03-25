// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import 'dart:convert';
import 'package:admin/src/models/category/category_model.dart';
import 'package:admin/src/models/customer/customer_model.dart';
import 'package:admin/src/models/delivery_boy_options.dart';
import 'package:admin/src/models/error/wordpress_error.dart';
import 'package:admin/src/models/site.dart';
import 'package:admin/src/models/snackbar_activity.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admin/src/models/settings/settings_option_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'account/account_model.dart';
import 'orders/orders_model.dart';
import 'package:bluetooth_print/bluetooth_print.dart';

class AppStateModel extends Model {

  static final AppStateModel _appStateModel = new AppStateModel._internal();

  factory AppStateModel() {
    return _appStateModel;
  }

  AppStateModel._internal();

  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  //bool adminApp = true;

  Map<String, dynamic> customerLocation = {};
  late String fcmToken;

  var selectedCurrency = 'USD';
  bool loading = false;
  final apiProvider = ApiProvider();
  List<String> vendorRoles = ['vendor', 'shop_manager', 'wcfm_vendor', 'seller'];

  SnackBarActivity? message;
  final messageFetcher = BehaviorSubject<SnackBarActivity>();
  ValueStream<SnackBarActivity> get messageStream => messageFetcher.stream;

  Locale _appLocale = Locale('en', '');
  List<SettingsOptionModel>? settings;
  List<Category> categories = [];
  int numberOfDecimals = 2;
  String currency = 'USD';
  final _apiProvider = ApiProvider();
  Order order = Order.fromJson({});
  ThemeMode themeMode = ThemeMode.system;
  int categoryPage = 0;

  Customer? user;

  Account activeAccount = new Account(name: '', url: '', consumerKey: '', consumerSecret: '', id: 0, selected: 0);

  DeliveryBoyOptions options = DeliveryBoyOptions(newOrderStatus: [OrderStatus(key: 'processing', value: 'Processing')], deliveryBoyRole: 'delivery_boy', distance: '10', vendorType: 'wcfm', blockTheme: null, orderStatuses: []);

  Locale get appLocal => _appLocale;
  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = Locale('en','');
    } else {
      _appLocale = Locale(prefs.getString('language_code')!);
    }
    if (prefs.getString('themeMode') != null) {
      final themeModeString = prefs.getString('themeMode');
      themeMode = themeModeString == 'ThemeMode.light' ? ThemeMode.light : themeModeString == 'ThemeMode.dark' ? ThemeMode.dark : ThemeMode.system;
    }
    return Null;
  }

  void changeLanguage(String code) async {
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale.languageCode == code) {
      return;
    }
    else {
      _appLocale = Locale(code);
      await prefs.setString('language_code', code);
      await prefs.setString('countryCode', '');
    } /*else {
      _appLocale = Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'CA');
    }*/
    notifyListeners();
  }

  Future<void> getSettings() async {
    await _apiProvider.initializationDone();
    final response = await _apiProvider.get("settings/general");
    settings = settingsFromJson(response);
    numberOfDecimals = int.parse(settings!.firstWhere((setting) => setting.id == 'woocommerce_price_num_decimals').settingDefault);
    currency = settings!.firstWhere((setting) => setting.id == 'woocommerce_currency').value;
    getCategories();
    notifyListeners();
  }

  Future<void> getCategories() async {
    categoryPage = categoryPage + 1;
    final response = await _apiProvider.get("products/categories?per_page=100&page="+categoryPage.toString());
    List<Category> newCategories = categoryFromJson(response);
    categories.addAll(newCategories);
    if(newCategories.length == 100) {
      getCategories();
    }
    notifyListeners();
  }

  void notifyModelListeners() {
    notifyListeners();
  }

  void addOrderLineItem(LineItem lineItem) {
    order.lineItems.add(lineItem);
    notifyListeners();
  }

  Future<bool> getSite(String url) async {

    final response = await _apiProvider.getWPJSON(url + "/wp-json");
    if(response.statusCode == 200) {
      Site site = siteFromJson(response.body);
      activeAccount.name = site.name;
      activeAccount.description = site.description;
      //notifyListeners();
      return true;
    } else {
      return false;
    }

    //This is for Rubex Only
    /*String checkUrl = 'https://rubex.ca/wp-admin/admin-ajax.php?action=bao_sites_details&url=' + url;
    final site = await _apiProvider.getFromUrl(checkUrl);
    if(site.statusCode == 200) {
      final response = await _apiProvider.getWPJSON(url + "/wp-json");
      if(response.statusCode == 200) {
        Site site = siteFromJson(response.body);
        activeAccount.name = site.name;
        //notifyListeners();
        return true;
      } else {
        return false;
      }
    } else if(site.statusCode == 400) {
      return false;
    }
    return false;*/
  }

  void setActiveAccount(String url, String consumerKey, String consumerSecret) {
    activeAccount.url = url;
    activeAccount.consumerKey = consumerKey;
    activeAccount.consumerSecret = consumerSecret;
    activeAccount.selected = 1;
    notifyListeners();
  }

  dispose() {
    messageFetcher.close();
  }

  Future<void> updateTheme(ThemeMode value) async {
    themeMode = value;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', value.toString());
  }

  Future<Order> createOrder() async {
    final response = await _apiProvider.post("orders", order.toJson());
    return Order.fromJson(json.decode(response));
  }

  void updateOrder(Order order) {
    notifyListeners();
  }

  //For Vendor APP

  Future<void> login(Map<String, dynamic> data) async {

    data['rememberme'] = 'forever';
    messageFetcher.add(SnackBarActivity(success: true, loading: true, message: 'Please wait..'));
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=build-app-online-admin_login', data);
    if (response.statusCode == 200) {
      messageFetcher.add(SnackBarActivity(success: true, show: false, message: 'Please wait..'));
      user = Customer.fromJson(json.decode(response.body));
      apiProvider.filter.clear();
      if(user!.role == 'administrator') {
        apiProvider.filter['admin_app'] = '1';
      } else if(user != null && vendorRoles.contains(user!.role)) {
        apiProvider.filter['user_id'] = user!.id.toString();
        apiProvider.filter['vendor'] = user!.id.toString();
        apiProvider.filter['vendor_app'] = '1';
      }  else if(user!.role == options.deliveryBoyRole) {
        apiProvider.filter['user_id'] = user!.id.toString();
        apiProvider.filter['wcfm_delivery_boy'] = user!.id.toString();
        apiProvider.filter['distance'] = options.distance;
      } else {
        messageFetcher.add(SnackBarActivity(message: 'Login as failed'));
      }
      notifyListeners();
    } else if (response.statusCode == 400) {
      if (response.statusCode != 200) {
        WpErrors errors = WpErrors.fromJson(json.decode(response.body));
        if(errors.data[0].message != null) {
          messageFetcher.add(SnackBarActivity(message: errors.data[0].message!));
        }
      }
    }
  }

  Future<void> logout() async {
    final apiProvider = ApiProvider();
    user!.id = 0;
    user!.role = '';
    notifyListeners();
    final response = await apiProvider.postWithCookies('/wp-admin/admin-ajax.php?action=build-app-online-admin_logout', Map());
  }

  void setIsOnline(bool value) {

    var action = value ? 'wcfm_vendor_store_online' : 'wcfm_vendor_store_offline';
    var data = { 'memberid': user!.id.toString(), 'action': action };
    final apiProvider = ApiProvider();
    user!.isOnline = value;
    apiProvider.postAjax(action, data);

    user!.isOnline = value;
    apiProvider.postWithCookiesEncoded("/wp-admin/admin-ajax.php?action=build-app-online-admin_update_user_meta",
        {"_bao_delivery_online": value});
    notifyListeners();
  }

  void enableNotifications(bool value) {
    final apiProvider = ApiProvider();
    user!.notification = value;
    apiProvider.postWithCookiesEncoded("/wp-admin/admin-ajax.php?action=build-app-online-admin_update_user_meta",
        {"_bao_delivery_notification": value});
    notifyListeners();
  }

  Future<void> getOptions() async {
    final apiProvider = ApiProvider();
    await apiProvider.init();
    final response = await apiProvider.postWithCookies('/wp-admin/admin-ajax.php?action=build-app-online-admin_options', {});
    if (response.statusCode == 200) {
      print('OPTION_RESPONSE: -------> ${response}');
      options = DeliveryBoyOptions.fromJson(json.decode(response.body));

      user = options.user;
      print('USER -------> ${user}');
      apiProvider.filter.clear();
      if(user!.role == 'administrator') {
        print('administrator');
        apiProvider.filter['admin_app'] = '1';
      } else if(user != null && vendorRoles.contains(user!.role)) {
        print('vendorRoles');
        apiProvider.filter['user_id'] = user!.id.toString();
        apiProvider.filter['vendor'] = user!.id.toString();
        apiProvider.filter['vendor_app'] = '1';

        //TODO Onlyy add distance for delivery boy filter, do not uncomment this
        //apiProvider.filter['distance'] = options.distance;
      } else if(user!.role == options.deliveryBoyRole) {
        print('delivery_boy');
        apiProvider.filter['user_id'] = user!.id.toString();
        apiProvider.filter['wcfm_delivery_boy'] = user!.id.toString();
        apiProvider.filter['distance'] = options.distance;
      }
      loading = false;
      notifyListeners();
    } else if (response.statusCode == 400) {
      print('OPTION_ERROR_RESPONSE: -------> ${response}');
      if (response.statusCode != 200) {
        WpErrors errors = WpErrors.fromJson(json.decode(response.body));
        messageFetcher.add(SnackBarActivity(message: errors.data[0].message!));
      }
    }
  }

  void updateNotifier(Customer u) {
    apiProvider.filter.clear();
    user = u;
    if(user != null) {
      if(user!.role == 'administrator') {
        apiProvider.filter['admin_app'] = '1';
      } else if(vendorRoles.contains(user!.role)) {
        apiProvider.filter['user_id'] = user!.id.toString();
        apiProvider.filter['vendor'] = user!.id.toString();
        apiProvider.filter['vendor_app'] = '1';
      } else if(user!.role == options.deliveryBoyRole) {
        apiProvider.filter['user_id'] = user!.id.toString();
        apiProvider.filter['wcfm_delivery_boy'] = user!.id.toString();
        apiProvider.filter['distance'] = options.distance;
      } else {
        messageFetcher.add(SnackBarActivity(message: 'Login failed'));
      }
      notifyListeners();
    }
  }

  Future<void> setPickedLocation(Map<String, dynamic> result) async {
    final apiProvider = ApiProvider();
    customerLocation = result;
    customerLocation['address'] = customerLocation['address'] != null ? customerLocation['address'] : '';
    apiProvider.filter.addAll(customerLocation);
    notifyListeners();
    apiProvider.postWithCookiesEncoded("/wp-admin/admin-ajax.php?action=build-app-online-admin_update_user_meta",
        {"bao_delivery_latitude": customerLocation['latitude'], "bao_delivery_longitude": customerLocation['longitude'], "bao_delivery_address": customerLocation['address']});
  }

}
