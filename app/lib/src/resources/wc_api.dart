library woocommerce_api;

import 'dart:async';
import "dart:collection";
import 'dart:convert';
import 'dart:io';
import "dart:math";
import "dart:core";
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/error/error_model.dart';
import 'package:admin/src/models/snackbar_activity.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'package:admin/src/resources/api_provider.dart';


class WooCommerceAPI {
  late String url;
  late String consumerKey;
  late String consumerSecret;
  late bool isHttps;
  AppStateModel appStateModel = AppStateModel();

  final apiProvider = ApiProvider();

  WooCommerceAPI(url, consumerKey, consumerSecret){
    this.url = url;
    this.consumerKey = consumerKey;
    this.consumerSecret = consumerSecret;

    if(this.url.startsWith("https")){
      this.isHttps = true;
    } else {
      this.isHttps = false;
    }

  }


  _getOAuthURL(String request_method, String endpoint) {
    var consumerKey = this.consumerKey;
    var consumerSecret = this.consumerSecret;

    var token = "";
    var token_secret = "";
    var url = this.url + "/wp-json/wc/v3/" + endpoint;
    // var url = this.url + "/wp-json/wc/v2/" + endpoint;
    var containsQueryParams = url.contains("?");

    // If website is HTTPS based, no need for OAuth, just return the URL with CS and CK as query params
    if(this.isHttps == true){
      return url + (containsQueryParams == true ? "&consumer_key=" + this.consumerKey + "&consumer_secret=" + this.consumerSecret : "?consumer_key=" + this.consumerKey + "&consumer_secret=" + this.consumerSecret);
    }

    var rand = new Random();
    var codeUnits = new List.generate(10, (index) {
      return rand.nextInt(26) + 97;
    });

    var nonce = new String.fromCharCodes(codeUnits);
    int timestamp = (new DateTime.now().millisecondsSinceEpoch / 1000).toInt();

    var method = request_method;
    var path = url.split("?")[0];
    var parameters = "oauth_consumer_key=" +
        consumerKey +
        "&oauth_nonce=" +
        nonce +
        "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" +
        timestamp.toString() +
        "&oauth_token=" +
        token +
        "&oauth_version=1.0&";

    if (containsQueryParams == true) {
      parameters = parameters + url.split("?")[1];
    } else {
      parameters = parameters.substring(0, parameters.length - 1);
    }

    Map<dynamic, dynamic> params = QueryString.parse(parameters);
    Map<dynamic, dynamic> treeMap = new SplayTreeMap<dynamic, dynamic>();
    treeMap.addAll(params);

    String parameterString = "";

    for (var key in treeMap.keys) {
      parameterString = parameterString +
          Uri.encodeQueryComponent(key) +
          "=" +
          treeMap[key] +
          "&";
    }

    parameterString = parameterString.substring(0, parameterString.length - 1);

    var baseString = method +
        "&" +
        Uri.encodeQueryComponent(
            containsQueryParams == true ? url.split("?")[0] : url) +
        "&" +
        Uri.encodeQueryComponent(parameterString);

    var signingKey = consumerSecret + "&" + token;
    var hmacSha1 =
    new crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1
    var signature = hmacSha1.convert(utf8.encode(baseString));

    var finalSignature = base64Encode(signature.bytes);


    var requestUrl = "";

    if (containsQueryParams == true) {
      requestUrl = url.split("?")[0] +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
    } else {
      requestUrl = url +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
    }

    return requestUrl;
  }

  Future<http.Response> getAsync(String endPoint) async {
    var url = this._getOAuthURL("GET", endPoint);
    final response = await http.get(Uri.parse(url));
    print(url);
    if (response.statusCode != 200) {
      Errors errors = Errors.fromJson(json.decode(response.body));
      AppStateModel().messageFetcher.add(SnackBarActivity(message: errors.message));
      //Get.snackbar(errors.code, errors.message, colorText: Colors.white);
    }
    return response;;
  }

  Map removeNullAndEmptyParams(Map<dynamic, dynamic> data) {
    final keys = data.keys.toList(growable: false);
    for (String key in keys) {
      final value = data[key];
      if (value == null) {
        data.remove(key);
      } /*else if (value is String) {
        if (value.isEmpty) {
          data.remove(key);
        }
      } */else if (value is Map) {
        data[key] = removeNullAndEmptyParams(value);
      } else if(value is List){
        value.forEach((item) {
          if(item is Map) {
            item = removeNullAndEmptyParams(item);
          } else if(item == null) {
            value.remove(item);
          }/* else if(item is String && item.isEmpty) {
            value.remove(item);
          }*/
        });
      }
    }
    return data;
  }

  Future<http.Response> postAsync(String endPoint, Map data, [String? s]) async {
    var url = this._getOAuthURL("POST", endPoint);
    data = removeNullAndEmptyParams(data);
    if(s != null) {
      appStateModel.messageFetcher.add(SnackBarActivity(message: s));
    }
    final response = await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
        },
        body: json.encode(data)
    );
    if(s != null) {
      appStateModel.messageFetcher.add(SnackBarActivity(message: s, show: false));
    }
    if (![200, 201].contains(response.statusCode)) {
      Errors errors = Errors.fromJson(json.decode(response.body));
      appStateModel.messageFetcher.add(SnackBarActivity(message: errors.message));
      //Get.snackbar(errors.code, errors.message, colorText: Colors.white);
    }
    return response;
  }

  Future<http.Response> putAsync(String endPoint, Map data, [String? s]) async {
    var url = this._getOAuthURL("PUT", endPoint);
    data = removeNullAndEmptyParams(data);
    if(s != null) {
      appStateModel.messageFetcher.add(SnackBarActivity(message: s));
    }
    final response = await http.put(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(data)
    );
    if(s != null) {
      appStateModel.messageFetcher.add(SnackBarActivity(message: s, show: false));
    }
    if (response.statusCode != 200) {
      Errors errors = Errors.fromJson(json.decode(response.body));
      appStateModel.messageFetcher.add(SnackBarActivity(message: errors.message));
      //Get.snackbar(errors.code, errors.message, colorText: Colors.white);
    }
    return response;
  }

  Future<http.Response> deleteAsync(String endPoint, [String? s]) async {
    var url = this._getOAuthURL("DELETE", endPoint);
    if(s != null) {
      appStateModel.messageFetcher.add(SnackBarActivity(message: s));
    }
    final response = await http.delete(Uri.parse(url));
    if(s != null) {
      appStateModel.messageFetcher.add(SnackBarActivity(message: s, show: false));
    }
    if (response.statusCode != 200) {
      Errors errors = Errors.fromJson(json.decode(response.body));
      appStateModel.messageFetcher.add(SnackBarActivity(message: errors.message));
      //Get.snackbar(errors.code, errors.message, colorText: Colors.white);
    }
    return response;
    //return json.decode(response.body);
  }
}

class QueryString {
  static Map parse(String query) {
    var search = new RegExp('([^&=]+)=?([^&]*)');
    var result = new Map();

    if (query.startsWith('?')) query = query.substring(1);

    decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));

    for (Match match in search.allMatches(query)) {
      result[decode(match.group(1)!)] = decode(match.group(2)!);
    }

    return result;
  }
}