import 'dart:convert';

List<TaxRatesModel> taxRatesModelFromJson(String str) => List<TaxRatesModel>.from(json.decode(str).map((x) => TaxRatesModel.fromJson(x)));

String taxRatesModelToJson(List<TaxRatesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaxRatesModel {
  TaxRatesModel({
    this.id,
    required this.country,
    required this.state,
    required this.postcode,
    required this.city,
    required this.postcodes,
    required this.cities,
    required this.rate,
    required this.name,
    required this.priority,
    required this.compound,
    required this.shipping,
    required this.order,
    required this.taxRatesModelClass,
    required this.links,
  });

  int? id;
  String country;
  String state;
  String postcode;
  String city;
  List<String> postcodes;
  List<String> cities;
  String rate;
  String name;
  int priority;
  bool compound;
  bool shipping;
  int order;
  String taxRatesModelClass;
  Links links;

  factory TaxRatesModel.fromJson(Map<String, dynamic> json) => TaxRatesModel(
    id: json["id"] == null ? null : json["id"],
    country: json["country"] == null ? '' : json["country"],
    state: json["state"] == null ? '' : json["state"],
    postcode: json["postcode"] == null ? '' : json["postcode"],
    city: json["city"] == null ? '' : json["city"],
    postcodes: json["postcodes"] == null ? [] : List<String>.from(json["postcodes"].map((x) => x)),
    cities: json["cities"] == null ? [] : List<String>.from(json["cities"].map((x) => x)),
    rate: json["rate"] == null ? '' : json["rate"],
    name: json["name"] == null ? '' : json["name"],
    priority: json["priority"] == null ? 0 : json["priority"],
    compound: json["compound"] == true ? true : false,
    shipping: json["shipping"] == false ? false : true,
    order: json["order"] == null ? 0 : json["order"],
    taxRatesModelClass: json["class"] == null ? '' : json["class"],
    links: json["_links"] == null ? Links.fromJson({}) : Links.fromJson(json["_links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "country": country == null ? null : country,
    "state": state == null ? null : state,
    "postcode": postcode == null ? null : postcode,
    "city": city == null ? null : city,
    "postcodes": postcodes == null ? null : List<dynamic>.from(postcodes.map((x) => x)),
    "cities": cities == null ? null : List<dynamic>.from(cities.map((x) => x)),
    "rate": rate,
    "name": name,
    "priority": priority == null ? null : priority,
    "compound": compound == null ? null : compound,
    "shipping": shipping == null ? null : shipping,
    "order": order == null ? null : order,
    "class": taxRatesModelClass == null ? null : taxRatesModelClass,
    //"_links": links == null ? null : links.toJson(),
  };
}

class Links {
  Links({
    required this.self,
    required this.collection,
  });

  List<Collection> self;
  List<Collection> collection;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    self: json["self"] == null ? [] : List<Collection>.from(json["self"].map((x) => Collection.fromJson(x))),
    collection: json["collection"] == null ? [] : List<Collection>.from(json["collection"].map((x) => Collection.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "self": self == null ? null : List<dynamic>.from(self.map((x) => x.toJson())),
    "collection": collection == null ? null : List<dynamic>.from(collection.map((x) => x.toJson())),
  };
}

class Collection {
  Collection({
    required this.href,
  });

  String href;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    href: json["href"] == null ? null : json["href"],
  );

  Map<String, dynamic> toJson() => {
    "href": href == null ? null : href,
  };
}
