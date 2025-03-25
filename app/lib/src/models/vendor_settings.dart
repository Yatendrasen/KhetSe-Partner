// To parse this JSON data, do
//
//     final vendorSettingsModel = vendorSettingsModelFromJson(jsonString);
import 'dart:convert';
import 'package:admin/src/models/themes/hex_color.dart';
import 'package:flutter/material.dart';

VendorSettingsModel vendorSettingsModelFromJson(String str) => VendorSettingsModel.fromJson(json.decode(str));

class VendorSettingsModel {
  VendorSettingsModel({
    required this.changeOrderStatus,
    required this.editOrder,
    required this.createOrder,
    required this.editProducts,
    required this.assignDeliveryBoy,
    required this.account,
    required this.menu,
  });

  bool changeOrderStatus;
  bool editOrder;
  bool createOrder;
  bool editProducts;
  bool assignDeliveryBoy;
  MenuModel account;
  MenuModel menu;

  factory VendorSettingsModel.fromJson(Map<String, dynamic> json) => VendorSettingsModel(
    changeOrderStatus: json["changeOrderStatus"] == false ? false : true,
    editOrder: json["editOrder"] == false ? false : true,
    createOrder: json["createOrder"] == false ? false : true,
    editProducts: json["editProducts"] == false ? false : true,
    assignDeliveryBoy: json["assignDeliveryBoy"] == false ? false : true,
    account: _nullOrEmptyOrFalse(json["account"]) ? MenuModel.fromJson({}) : MenuModel.fromJson(json["account"]),
    menu: _nullOrEmptyOrFalse(json["account"]) ? MenuModel.fromJson({}) : MenuModel.fromJson(json["account"]),
  );
}

class MenuModel {
  MenuModel({
    required this.enable,
    required this.menuGroup,
  });

  bool enable;
  List<MenuGroup> menuGroup;

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
    enable: json["enable"] == false ? false : true,
    menuGroup: json["menuGroup"] == null ? [] : List<MenuGroup>.from(json["menuGroup"].map((x) => MenuGroup.fromJson(x))),
  );
}


List<MenuGroup> menuGroupFromJson(String str) => List<MenuGroup>.from(json.decode(str).map((x) => MenuGroup.fromJson(x)));

class MenuGroup {
  MenuGroup({
    this.type,
    this.showTitle = true,
    this.subTitle,
    this.title = '',
    required this.menuItems,
  });

  String? type;
  bool showTitle;
  String? subTitle;
  String title;
  List<Child> menuItems;

  factory MenuGroup.fromJson(Map<String, dynamic> json) => MenuGroup(
    type: json["type"] == null ? null : json["type"],
    showTitle: json["showTitle"] == null ? true : json["showTitle"],
    subTitle: json["subTitle"] == null ? null : json["subTitle"],
    title: json["title"] == null ? '' : json["title"],
    menuItems: json["menuItems"] == null ? [] : List<Child>.from(json["menuItems"].map((x) => Child.fromJson(x))),
  );
}

class Child {
  String title;
  String description;
  String linkId;
  String linkType;
  String image;
  //String? height;
  //String? width;
  String storeType;
  String leading;
  String trailing;
  IconStyle? iconStyle;
  TextStyle? textStyle;

  Child({
    this.title = 'New',
    this.description = '',
    this.linkType = '',
    this.linkId = '0',
    this.image = '',
    //required this.height,
    //required this.width,
    required this.storeType,
    this.leading = '',
    this.trailing = '',
    this.iconStyle,
    this.textStyle
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
    title: json["title"] == null ? '' : json["title"],
    description: json["description"] == null ? '' : json["description"],
    linkId: json["linkId"] == null ? '' : json["linkId"],
    linkType: json["linkType"] == null ? '' : json["linkType"],
    image: json["image"] == null ? null : json["image"],
    //height: json["height"] == null ? null : json["height"],
    //width: json["width"] == null ? null : json["width"],
    storeType: json["storeType"] == null ? '' : json["storeType"],
    leading: json["leading"] == null ? '' : json["leading"],
    trailing: json["trailing"] == null ? '' : json["trailing"],
    iconStyle: json["iconStyle"] == null ? null : IconStyle.fromJson(json["iconStyle"]),
    textStyle: _nullOrEmptyOrFalse(json['textStyle']) ? null : buildTileTextStyle(json['textStyle']),
  );
}

TextStyle buildTileTextStyle(Map<String, dynamic> json) {
  return TextStyle(
    color: _nullOrEmptyOrFalse(json['color']) ? Color(0xFF000000) : HexColor(json['color']),
    fontFamily: _nullOrEmptyOrFalse(json['fontFamily']) ? null : json['fontFamily'].toString(),
    fontSize:  _nullOrEmptyOrFalse(json['fontSize']) ? 16 : double.parse(json['fontSize'].toString()),
    fontWeight:  _nullOrEmptyOrFalse(json['fontWeight']) ? FontWeight.w400 : getFontWeight(json['fontWeight']),
    fontStyle:  json['fontStyle'] == 'FontStyle.italic' ? FontStyle.italic : FontStyle.normal,
    letterSpacing:  _nullOrEmptyOrFalse(json['letterSpacing']) ? 1 : double.parse(json['letterSpacing'].toString()),
    wordSpacing:  _nullOrEmptyOrFalse(json['wordSpacing']) ? 1 : double.parse(json['wordSpacing'].toString()),
    textBaseline:  json['textBaseline'] == 'TextBaseline.ideographic' ? TextBaseline.ideographic : TextBaseline.alphabetic,
  );
}

class IconStyle {
  IconStyle({
    required this.color,
    required this.backgroundColor,
    required this.borderRadius,
    required this.elevation,
    required this.style
  });

  Color color;
  Color backgroundColor;
  double borderRadius;
  double elevation;
  String style;

  factory IconStyle.fromJson(Map<String, dynamic> json) => IconStyle(
    color: json["color"] == null ? Colors.white : HexColor(json["color"]),
    backgroundColor: json["backgroundColor"] == null ? Colors.deepOrange : HexColor(json["backgroundColor"]),
    borderRadius: json["borderRadius"] == null ? 0.0 : double.parse(json["borderRadius"].toString()),
    elevation: json["elevation"] == null ? 0.0 : double.parse(json["elevation"].toString()),
    style: json["style"] == null ? '' : json["style"],
  );

  Map<String, dynamic> toJson() => {
    "color": toHexColor(color),
    "backgroundColor": toHexColor(backgroundColor),
    "borderRadius": borderRadius,
    "elevation": elevation,
    "style": style,
  };
}

FontWeight getFontWeight(String fontWeight) {
  switch (fontWeight) {
    case 'FontWeight.normal':
      return FontWeight.normal;
    case 'FontWeight.bold':
      return FontWeight.bold;
    case 'FontWeight.w100':
      return FontWeight.w100;
    case 'FontWeight.w200':
      return FontWeight.w200;
    case 'FontWeight.w300':
      return FontWeight.w300;
    case 'FontWeight.w400':
      return FontWeight.w400;
    case 'FontWeight.w500':
      return FontWeight.w500;
    case 'FontWeight.w600':
      return FontWeight.w600;
    case 'FontWeight.w700':
      return FontWeight.w700;
    case 'FontWeight.w800':
      return FontWeight.w800;
    case 'FontWeight.w900':
      return FontWeight.w900;
    default:
      return FontWeight.normal;
  }
}

_nullOrEmptyOrFalse(json) {
  if(json == null || json == '' || json == false) {
    return true;
  } else return false;
}