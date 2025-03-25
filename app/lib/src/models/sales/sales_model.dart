
import 'dart:convert';

class SalesModel {
  final List<Sales> sales;

  SalesModel({
    required this.sales,
  });

  factory SalesModel.fromJson(List<dynamic> parsedJson) {

    List<Sales> sales = [];
    sales = parsedJson.map((i)=>Sales.fromJson(i)).toList();

    return new SalesModel(sales : sales);
  }
}

// To parse this JSON data, do
//
//     final sales = salesFromJson(jsonString);

Sales salesFromJson(String str) => Sales.fromJson(json.decode(str));

String salesToJson(Sales data) => json.encode(data.toJson());

class Sales {
  String totalSales;
  String netSales;
  String averageSales;
  int totalOrders;
  int totalItems;
  String totalTax;
  String totalShipping;
  double totalRefunds;
  String totalDiscount;
  String totalsGroupedBy;
  Map<String, Total> totals;
  int totalCustomers;

  Sales({
    required this.totalSales,
    required this.netSales,
    required this.averageSales,
    required this.totalOrders,
    required this.totalItems,
    required this.totalTax,
    required this.totalShipping,
    required this.totalRefunds,
    required this.totalDiscount,
    required this.totalsGroupedBy,
    required this.totals,
    required this.totalCustomers,
  });

  factory Sales.fromJson(Map<String, dynamic> json) => Sales(
    totalSales: json["total_sales"] == null ? null : json["total_sales"],
    netSales: json["net_sales"] == null ? null : json["net_sales"],
    averageSales: json["average_sales"] == null ? null : json["average_sales"],
    totalOrders: json["total_orders"] == null ? null : json["total_orders"],
    totalItems: json["total_items"] == null ? null : json["total_items"],
    totalTax: json["total_tax"] == null ? null : json["total_tax"],
    totalShipping: json["total_shipping"] == null ? null : json["total_shipping"],
    totalRefunds: json["total_refunds"] == null ? 0 : double.parse(json["total_refunds"].toString()),
    totalDiscount: json["total_discount"] == null ? null : json["total_discount"],
    totalsGroupedBy: json["totals_grouped_by"] == null ? null : json["totals_grouped_by"],
    totals: json["totals"] == null ? Map.from({}) : Map.from(json["totals"]).map((k, v) => new MapEntry<String, Total>(k, Total.fromJson(v, k))),
    totalCustomers: json["total_customers"] == null ? null : json["total_customers"],
  );

  Map<String, dynamic> toJson() => {
    "total_sales": totalSales == null ? null : totalSales,
    "net_sales": netSales == null ? null : netSales,
    "average_sales": averageSales == null ? null : averageSales,
    "total_orders": totalOrders == null ? null : totalOrders,
    "total_items": totalItems == null ? null : totalItems,
    "total_tax": totalTax == null ? null : totalTax,
    "total_shipping": totalShipping == null ? null : totalShipping,
    "total_refunds": totalRefunds == null ? null : totalRefunds,
    "total_discount": totalDiscount == null ? null : totalDiscount,
    "totals_grouped_by": totalsGroupedBy == null ? null : totalsGroupedBy,
    "totals": totals == null ? null : Map.from(totals).map((k, v) => new MapEntry<String, dynamic>(k, v.toJson())),
    "total_customers": totalCustomers == null ? null : totalCustomers,
  };
}

class About {
  String href;

  About({
    required this.href,
  });

  factory About.fromJson(Map<String, dynamic> json) => About(
    href: json["href"] == null ? null : json["href"],
  );

  Map<String, dynamic> toJson() => {
    "href": href == null ? null : href,
  };
}

class Total {
  String sales;
  int orders;
  int items;
  String tax;
  String shipping;
  String discount;
  int customers;
  String key;

  Total({
    required this.sales,
    required this.orders,
    required this.items,
    required this.tax,
    required this.shipping,
    required this.discount,
    required this.customers,
    required this.key,
  });

  factory Total.fromJson(Map<String, dynamic> json, String k) => Total(
    sales: json["sales"] == null ? null : json["sales"],
    orders: json["orders"] == null ? null : json["orders"],
    items: json["items"] == null ? null : json["items"],
    tax: json["tax"] == null ? null : json["tax"],
    shipping: json["shipping"] == null ? null : json["shipping"],
    discount: json["discount"] == null ? null : json["discount"],
    customers: json["customers"] == null ? null : json["customers"],
    key: k,
  );

  Map<String, dynamic> toJson() => {
    "sales": sales == null ? null : sales,
    "orders": orders == null ? null : orders,
    "items": items == null ? null : items,
    "tax": tax == null ? null : tax,
    "shipping": shipping == null ? null : shipping,
    "discount": discount == null ? null : discount,
    "customers": customers == null ? null : customers,
  };
}