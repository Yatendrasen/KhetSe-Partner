import 'dart:convert';

class VendorProductsModel {
  final List<VendorProduct> products;

  VendorProductsModel({
    required this.products,
  });

  factory VendorProductsModel.fromJson(List<dynamic> parsedJson) {

    List<VendorProduct> products = [];
    products = parsedJson.map((i)=>VendorProduct.fromJson(i)).toList();

    return new VendorProductsModel(products : products);
  }

}
// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

List<VendorProduct> productFromJson(String str) => List<VendorProduct>.from(json.decode(str).map((x) => VendorProduct.fromJson(x)));

String productToJson(List<VendorProduct> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VendorProduct {
  int id;
  String name;
  String? slug;
  String? permalink;
  DateTime? dateCreated;
  DateTime? dateCreatedGmt;
  DateTime? dateModified;
  DateTime? dateModifiedGmt;
  String type;
  String status;
  bool featured;
  String catalogVisibility;
  String description;
  String shortDescription;
  dynamic sku;
  dynamic price;
  String? regularPrice;
  String? salePrice;
  dynamic dateOnSaleFrom;
  dynamic dateOnSaleFromGmt;
  dynamic dateOnSaleTo;
  dynamic dateOnSaleToGmt;
  String? priceHtml;
  bool onSale;
  bool purchasable;
  int totalSales;
  bool virtual;
  bool downloadable;
  List<dynamic> downloads;
  int? downloadLimit;
  int? downloadExpiry;
  String? externalUrl;
  String? buttonText;
  String? taxStatus;
  String? taxClass;
  bool manageStock;
  int stockQuantity;
  String stockStatus;
  String backOrders;
  bool backordersAllowed;
  bool backordered;
  bool soldIndividually;
  String? weight;
  Dimensions? dimensions;
  bool? shippingRequired;
  bool? shippingTaxable;
  String? shippingClass;
  int? shippingClassId;
  bool reviewsAllowed;
  String averageRating;
  int? ratingCount;
  List<int> relatedIds;
  List<int> upsellIds;
  List<int> crossSellIds;
  int? parentId;
  String? purchaseNote;
  List<ProductCategory> categories;
  List<dynamic> tags;
  List<ProductImage> images;
  List<Attribute> attributes;
  List<DefaultAttribute> defaultAttributes;
  List<dynamic> variations;
  List<dynamic> groupedProducts;
  int? menuOrder;
  List<dynamic>? metaData;
  int decimals;

  VendorProduct({
    required this.id,
    required this.name,
    this.slug,
    this.permalink,
    this.dateCreated,
    this.dateCreatedGmt,
    this.dateModified,
    this.dateModifiedGmt,
    required this.type,
    required this.status,
    required this.featured,
    required this.catalogVisibility,
    required this.description,
    required this.shortDescription,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.dateOnSaleFrom,
    this.dateOnSaleFromGmt,
    this.dateOnSaleTo,
    this.dateOnSaleToGmt,
    this.priceHtml,
    required this.onSale,
    required this.purchasable,
    required this.totalSales,
    required this.virtual,
    required this.downloadable,
    required this.downloads,
    this.downloadLimit,
    this.downloadExpiry,
    this.externalUrl,
    this.buttonText,
    this.taxStatus,
    this.taxClass,
    required this.manageStock,
    required this.stockQuantity,
    required this.stockStatus,
    required this.backOrders,
    required this.backordersAllowed,
    required this.backordered,
    required this.soldIndividually,
    this.weight,
    this.dimensions,
    this.shippingRequired,
    this.shippingTaxable,
    this.shippingClass,
    this.shippingClassId,
    required this.reviewsAllowed,
    required this.averageRating,
    this.ratingCount,
    required this.relatedIds,
    required this.upsellIds,
    required this.crossSellIds,
    this.parentId,
    this.purchaseNote,
    required this.categories,
    required this.tags,
    required this.images,
    required this.attributes,
    required this.defaultAttributes,
    required this.variations,
    required this.groupedProducts,
    required this.menuOrder,
    required this.metaData,
    required this.decimals,
  });

  factory VendorProduct.fromJson(Map<String, dynamic> json) => VendorProduct(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    slug: json["slug"] == null ? null : json["slug"],
    permalink: json["permalink"] == null ? null : json["permalink"],
    dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
    dateCreatedGmt: json["date_created_gmt"] == null ? null : DateTime.parse(json["date_created_gmt"]),
    dateModified: json["date_modified"] == null ? null : DateTime.parse(json["date_modified"]),
    dateModifiedGmt: json["date_modified_gmt"] == null ? null : DateTime.parse(json["date_modified_gmt"]),
    type: json["type"] == null ? 'simple' : json["type"],
    status: json["status"] == null ? 'draft' : json["status"],
    featured: json["featured"] == null ? false : json["featured"],
    catalogVisibility: json["catalog_visibility"] == null ? 'visible' : json["catalog_visibility"],
    description: json["description"] == null ? '' : json["description"],
    shortDescription: json["short_description"] == null ? '' : json["short_description"],
    sku: json["sku"] == null ? null : json["sku"],
    price: (json["sale_price"] != null && json["sale_price"] != '') ? json["sale_price"].toString() : json["price"] == null || json["price"] == '' ? '0' : json["price"].toString(),
    regularPrice: json["regular_price"] == null || json["regular_price"] == '' ? '0' : json["regular_price"].toString(),
    salePrice: json["sale_price"] == null || json["sale_price"] == '' ? null : json["sale_price"].toString(),
    dateOnSaleFrom: json["date_on_sale_from"] == null ? null : json["date_on_sale_from"],
    dateOnSaleFromGmt: json["date_on_sale_from_gmt"] == null || json["regular_price"] == '' ? null : json["date_on_sale_from_gmt"],
    dateOnSaleTo: json["date_on_sale_to"] == null ? null : json["date_on_sale_to"],
    dateOnSaleToGmt: json["date_on_sale_to_gmt"] == null || json["regular_price"] == '' ? null : json["date_on_sale_to_gmt"],
    priceHtml: json["price_html"] is String ? json["price_html"] : null,
    onSale: json["on_sale"] == null || json["on_sale"] == false ? false : json["on_sale"],
    purchasable: json["purchasable"] == null ? true : json["purchasable"],
    totalSales: json["total_sales"] == null ? 0 : int.parse(json["total_sales"].toString()),
    virtual: json["virtual"] == null ? false : json["virtual"],
    downloadable: json["downloadable"] == null ? false : json["downloadable"],
    downloads: json["downloads"] == null ? [] : List<dynamic>.from(json["downloads"].map((x) => x)),
    downloadLimit: json["download_limit"] == null ? null : json["download_limit"],
    downloadExpiry: json["download_expiry"] == null ? null : json["download_expiry"],
    externalUrl: json["external_url"] == null ? null : json["external_url"],
    buttonText: json["button_text"] == null ? null : json["button_text"],
    taxStatus: json["tax_status"] == null ? null : json["tax_status"],
    taxClass: json["tax_class"] == null ? null : json["tax_class"],
    manageStock: json["manage_stock"] == null ? false : json["manage_stock"],
    stockQuantity: json["stock_quantity"] == null ? 0 : json["stock_quantity"],
    stockStatus: json["stock_status"] == null ? 'instock' : json["stock_status"],
    backOrders: json["backorders"] == null ? 'no' : json["backorders"],
    backordersAllowed: json["backorders_allowed"] == null ? false : json["backorders_allowed"],
    backordered: json["backordered"] == null ? false : json["backordered"],
    soldIndividually: json["sold_individually"] == null ? false : json["sold_individually"],
    weight: json["weight"] == null ? null : json["weight"],
    dimensions: json["dimensions"] == null ? null : Dimensions.fromJson(json["dimensions"]),
    shippingRequired: json["shipping_required"] == null ? null : json["shipping_required"],
    shippingTaxable: json["shipping_taxable"] == null ? null : json["shipping_taxable"],
    shippingClass: json["shipping_class"] == null ? null : json["shipping_class"],
    shippingClassId: json["shipping_class_id"] == null ? null : json["shipping_class_id"],
    reviewsAllowed: json["reviews_allowed"] == null ? true : json["reviews_allowed"],
    averageRating: json["average_rating"] == null ? '0' : json["average_rating"],
    ratingCount: json["rating_count"] == null ? 0 : json["rating_count"],
    relatedIds: json["related_ids"] == null ? [] : List<int>.from(json["related_ids"].map((x) => x)),
    upsellIds: json["upsell_ids"] == null ? [] : List<int>.from(json["upsell_ids"].map((x) => x)),
    crossSellIds: json["cross_sell_ids"] == null ? [] : List<int>.from(json["cross_sell_ids"].map((x) => x)),
    parentId: json["parent_id"] == null ? null : json["parent_id"],
    purchaseNote: json["purchase_note"] == null ? null : json["purchase_note"],
    categories: json["categories"] == null ? [] : List<ProductCategory>.from(json["categories"].map((x) => ProductCategory.fromJson(x))),
    tags: json["tags"] == null ? [] : List<dynamic>.from(json["tags"].map((x) => x)),
    images: json["images"] == null ? [] : List<ProductImage>.from(json["images"].map((x) => ProductImage.fromJson(x))),
    attributes: json["attributes"] == null ? [] : List<Attribute>.from(json["attributes"].map((x) => Attribute.fromJson(x))),
    defaultAttributes: json["default_attributes"] == null ? [] : List<DefaultAttribute>.from(json["default_attributes"].map((x) => DefaultAttribute.fromJson(x))),
    variations: json["variations"] == null ? [] : List<dynamic>.from(json["variations"].map((x) => x)),
    groupedProducts: json["grouped_products"] == null ? [] : List<dynamic>.from(json["grouped_products"].map((x) => x)),
    menuOrder: json["menu_order"] == null ? 0 : json["menu_order"],
    metaData: json["meta_data"] == null ? null : List<dynamic>.from(json["meta_data"].map((x) => x)),
    decimals: json["decimals"] == null ? 2 : json["decimals"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "slug": slug == null ? null : slug,
    "type": type == null ? null : type,
    "status": status == null ? null : status,
    "featured": featured == null ? null : featured,
    "catalog_visibility": catalogVisibility == null ? null : catalogVisibility,
    "description": description == null ? null : description,
    "short_description": shortDescription == null ? null : shortDescription,
    "sku": sku == null ? null : sku,
    //"price": price == null ? null : price,
    "regular_price": regularPrice == null || regularPrice == '' ? '' : regularPrice,
    "sale_price": salePrice == null || salePrice == '' ? '' : salePrice,
    "date_on_sale_from": dateOnSaleFrom,
    "date_on_sale_from_gmt": dateOnSaleFromGmt,
    "date_on_sale_to": dateOnSaleTo,
    "date_on_sale_to_gmt": dateOnSaleToGmt,
    //"on_sale": onSale,
    "virtual": virtual == null ? null : virtual,
    "downloadable": downloadable == null ? null : downloadable,
    "downloads": downloads == null ? null : List<dynamic>.from(downloads.map((x) => x)),
    "download_limit": downloadLimit == null ? null : downloadLimit,
    "download_expiry": downloadExpiry == null ? null : downloadExpiry,
    "external_url": externalUrl == null ? null : externalUrl,
    "button_text": buttonText == null ? null : buttonText,
    "tax_status": taxStatus == null ? null : taxStatus,
    "tax_class": taxClass == null ? null : taxClass,
    "manage_stock": manageStock == null ? null : manageStock,
    "stock_quantity": manageStock == null ? 0 : stockQuantity,
    "stock_status": stockStatus == null ? null : stockStatus,
    "backorders": backOrders == null ? null : backOrders,
    "sold_individually": soldIndividually == null ? null : soldIndividually,
    "weight": weight == null ? null : weight,
    "dimensions": dimensions == null ? null : dimensions!.toJson(),
    "shipping_class": shippingClass == null ? null : shippingClass,
    "reviews_allowed": reviewsAllowed == null ? null : reviewsAllowed,
    "upsell_ids": upsellIds == null ? null : List<dynamic>.from(upsellIds.map((x) => x)),
    "cross_sell_ids": crossSellIds == null ? null : List<dynamic>.from(crossSellIds.map((x) => x)),
    "parent_id": parentId == null ? null : parentId,
    "purchase_note": purchaseNote == null ? null : purchaseNote,
    "categories": categories == null ? null : List<dynamic>.from(categories.map((x) => x.toJson())),
    "tags": tags == null ? null : List<dynamic>.from(tags.map((x) => x)),
    "images": images == null ? [] : List<dynamic>.from(images.map((x) => x.toJson())),
    "attributes": attributes == null ? null : List<dynamic>.from(attributes.map((x) => x.toJson())),
    "default_attributes": defaultAttributes == null ? null : List<dynamic>.from(defaultAttributes.map((x) => x.toJson())),
    "grouped_products": groupedProducts == null ? null : List<dynamic>.from(groupedProducts.map((x) => x)),
    "menu_order": menuOrder == null ? null : menuOrder,
    "meta_data": metaData == null ? null : List<dynamic>.from(metaData!.map((x) => x)),
  };
}

class Attribute {
  int id;
  String name;
  int position;
  bool visible;
  bool variation;
  List<String> options;

  Attribute({
    required this.id,
    required this.name,
    required this.position,
    required this.visible,
    required this.variation,
    required this.options,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    position: json["position"] == null ? 0 : json["position"],
    visible: json["visible"] == null ? null : json["visible"],
    variation: json["variation"] == null ? false : json["variation"],
    options: json["options"] == null ? [] : List<String>.from(json["options"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "position": position == null ? null : position,
    "visible": visible == null ? null : visible,
    "variation": variation == null ? null : variation,
    "options": options == null ? null : List<dynamic>.from(options.map((x) => x)),
  };
}

class ProductCategory {
  int id;
  String name;
  String? slug;

  ProductCategory({
    required this.id,
    required this.name,
    this.slug,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    slug: json["slug"] == null ? null : json["slug"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "slug": slug == null ? null : slug,
  };
}

class DefaultAttribute {
  int id;
  String name;
  String option;

  DefaultAttribute({
    required this.id,
    required this.name,
    required this.option,
  });

  factory DefaultAttribute.fromJson(Map<String, dynamic> json) => DefaultAttribute(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    option: json["option"] == null ? null : json["option"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "option": option == null ? null : option,
  };
}

class Dimensions {
  String length;
  String width;
  String height;

  Dimensions({
    required this.length,
    required this.width,
    required this.height,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
    length: json["length"] == null ? null : json["length"],
    width: json["width"] == null ? null : json["width"],
    height: json["height"] == null ? null : json["height"],
  );

  Map<String, dynamic> toJson() => {
    "length": length == null ? null : length,
    "width": width == null ? null : width,
    "height": height == null ? null : height,
  };
}

class ProductImage {
  int? id;
  String src;
  String? name;
  String? alt;

  ProductImage({
    this.id,
    required this.src,
    this.name,
    this.alt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
    id: json["id"] == null ? null : json["id"],
    src: json["src"] == null ? '' : json["src"],
    name: json["name"] == null ? null : json["name"],
    alt: json["alt"] == null ? null : json["alt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "src": src == null ? null : src,
    "name": name == null ? null : name,
    "alt": alt == null ? null : alt,
  };
}
