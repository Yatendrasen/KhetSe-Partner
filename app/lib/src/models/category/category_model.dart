import 'dart:convert';

//TODO Delete
class CategoriesModel {
  final List<Category> categories;

  CategoriesModel({
    required this.categories,
  });

  factory CategoriesModel.fromJson(List<dynamic> parsedJson) {

    List<Category> categories = [];
    categories = parsedJson.map((i)=>Category.fromJson(i)).toList();

    return new CategoriesModel(categories : categories);
  }

}

List<Category> categoryFromJson(String str) => List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  int id;
  String name;
  String slug;
  int parent;
  String description;
  String display;
  Image image;
  int menuOrder;
  int count;
  
  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.parent,
    required this.description,
    required this.display,
    required this.image,
    required this.menuOrder,
    required this.count,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    slug: json["slug"] == null ? '' : json["slug"],
    parent: json["parent"] == null ? 0 : json["parent"],
    description: json["description"] == null ? '' : json["description"],
    display: json["display"] == null ? '' : json["display"],
    image: json["image"] == null ? Image.fromJson({}) : Image.fromJson(json["image"]),
    menuOrder: json["menu_order"] == null ? 0 : json["menu_order"],
    count: json["count"] == null ? 0 : json["count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "slug": slug == null ? null : slug,
    "parent": parent == null ? null : parent,
    "description": description == null ? null : description,
    "display": display == null ? null : display,
    "image": image.toJson(),
    "menu_order": menuOrder == null ? null : menuOrder,
    "count": count == null ? null : count,
  };
}

class Image {
  Image({
    required this.src,
  });

  String src;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    src: json["src"] is String ? json["src"] : '',
  );

  Map<String, dynamic> toJson() => {
    "src": src == null ? null : src,
  };
}
