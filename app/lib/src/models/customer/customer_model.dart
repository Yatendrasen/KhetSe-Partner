import 'dart:convert';

List<Customer> customerFromJson(String str) => List<Customer>.from(json.decode(str).map((x) => Customer.fromJson(x)));

String customerToJson(List<Customer> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Customer {
  int id;
  DateTime dateCreated;
  DateTime dateCreatedGmt;
  String email;
  String firstName;
  String lastName;
  String role;
  String username;
  Address billing;
  Address shipping;
  bool isPayingCustomer;
  String avatarUrl;
  List<MetaDatum> metaData;
  bool isOnline;
  bool notification;

  Customer({
    required this.id,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.username,
    required this.billing,
    required this.shipping,
    required this.isPayingCustomer,
    required this.avatarUrl,
    required this.metaData,
    required this.isOnline,
    required this.notification
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"] == null ? 0 : json["id"],
    dateCreated: json["date_created"] == null ? DateTime.now() : DateTime.parse(json["date_created"]),
    dateCreatedGmt: json["date_created_gmt"] == null ? DateTime.now() : DateTime.parse(json["date_created_gmt"]),
    email: json["email"] == null ? '' : json["email"],
    firstName: json["first_name"] == null ? '' : json["first_name"],
    lastName: json["last_name"] == null ? '' : json["last_name"],
    role: json["role"] == null ? '' : json["role"],
    username: json["username"] == null ? '' : json["username"],
    billing: json["billing"] == null ? Address.fromJson({}) : Address.fromJson(json["billing"]),
    shipping: json["shipping"] == null ? Address.fromJson({}) : Address.fromJson(json["shipping"]),
    isPayingCustomer: json["is_paying_customer"] == null ? false : json["is_paying_customer"],
    avatarUrl: json["avatar_url"] == null ? '' : json["avatar_url"],
    metaData: json["meta_data"] == null ? [] : List<MetaDatum>.from(json["meta_data"].map((x) => MetaDatum.fromJson(x))),
    isOnline: json["is_online"] is bool ? json["is_online"] : false,
    notification: json["notification"] is bool ? json["notification"] : false,
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "date_created": dateCreated == null ? null : dateCreated.toIso8601String(),
    "date_created_gmt": dateCreatedGmt == null ? null : dateCreatedGmt.toIso8601String(),
    "email": email == null ? null : email,
    "first_name": firstName == null ? null : firstName,
    "last_name": lastName == null ? null : lastName,
    "role": role == null ? null : role,
    "username": username == null ? null : username,
    "billing": billing == null ? null : billing.toJson(),
    "shipping": shipping == null ? null : shipping.toJson(),
    "is_paying_customer": isPayingCustomer == null ? null : isPayingCustomer,
    "avatar_url": avatarUrl == null ? null : avatarUrl,
    "meta_data": metaData == null ? null : List<dynamic>.from(metaData.map((x) => x)),
  };
}

class MetaDatum {
  MetaDatum({
    this.id,
    required this.key,
    this.value,
    this.displayKey,
    this.displayValue,
  });

  int? id;
  String key;
  dynamic value;
  String? displayKey;
  dynamic displayValue;

  factory MetaDatum.fromJson(Map<String, dynamic> json) => MetaDatum(
    id: json["id"] == null ? null : json["id"],
    key: json["key"] == null ? null : json["key"],
    value: json["value"] == null ? null : json["value"],
    displayKey: json["display_key"] == null ? null : json["display_key"],
    displayValue: json["display_value"] == null ? null : json["display_value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "key": key == null ? null : key,
    "value": value == null ? null : value,
    "display_key": displayKey == null ? null : displayKey,
    "display_value": displayValue == null ? null : displayValue,
  };
}

class Address {
  String firstName;
  String lastName;
  String company;
  String address1;
  String address2;
  String city;
  String? state;
  String postcode;
  String? country;
  String email;
  String phone;

  Address({
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.address1,
    required this.address2,
    required this.city,
    required this.state,
    required this.postcode,
    required this.country,
    required this.email,
    required this.phone,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    firstName: json["first_name"] == null ? '' : json["first_name"],
    lastName: json["last_name"] == null ? '' : json["last_name"],
    company: json["company"] == null ? '' : json["company"],
    address1: json["address_1"] == null ? '' : json["address_1"],
    address2: json["address_2"] == null ? '' : json["address_2"],
    city: json["city"] == null ? '' : json["city"],
    state: json["state"] == null ? null : json["state"],
    postcode: json["postcode"] == null ? '' : json["postcode"],
    country: json["country"] == null ? null : json["country"],
    email: json["email"] == null ? '' : json["email"],
    phone: json["phone"] == null ? '' : json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName == null ? null : firstName,
    "last_name": lastName == null ? null : lastName,
    "company": company == null ? null : company,
    "address_1": address1 == null ? null : address1,
    "address_2": address2 == null ? null : address2,
    "city": city == null ? null : city,
    "state": state == null ? null : state,
    "postcode": postcode == null ? null : postcode,
    "country": country == null ? null : country,
    "email": email == null || email.isEmpty ? null : email,
    "phone": phone == null ? null : phone,
  };
}