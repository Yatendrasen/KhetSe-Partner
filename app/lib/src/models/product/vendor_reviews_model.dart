// To parse this JSON data, do
//
//     final vendorReviews = vendorReviewsFromJson(jsonString);

import 'dart:convert';

List<VendorReviews> vendorReviewsFromJson(String str) => List<VendorReviews>.from(json.decode(str).map((x) => VendorReviews.fromJson(x)));

String vendorReviewsToJson(List<VendorReviews> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VendorReviews {
  String id;
  String vendorId;
  String authorId;
  String authorName;
  String authorEmail;
  String reviewTitle;
  String reviewDescription;
  String reviewRating;
  String approved;
  DateTime created;

  VendorReviews({
    required this.id,
    required this.vendorId,
    required this.authorId,
    required this.authorName,
    required this.authorEmail,
    required this.reviewTitle,
    required this.reviewDescription,
    required this.reviewRating,
    required this.approved,
    required this.created,
  });

  factory VendorReviews.fromJson(Map<String, dynamic> json) => VendorReviews(
    id: json["ID"] == null ? '0' : json["ID"],
    vendorId: json["vendor_id"] == null ? '0' : json["vendor_id"],
    authorId: json["author_id"] == null ? '0' : json["author_id"],
    authorName: json["author_name"] == null ? '' : json["author_name"],
    authorEmail: json["author_email"] == null ? '' : json["author_email"],
    reviewTitle: json["review_title"] == null ? '' : json["review_title"],
    reviewDescription: json["review_description"] == null ? '' : json["review_description"],
    reviewRating: json["review_rating"] == null ? '0' : json["review_rating"],
    approved: json["approved"] == null ? '0' : json["approved"],
    created: json["created"] == null ? DateTime.now() : DateTime.parse(json["created"]),
  );

  Map<String, dynamic> toJson() => {
    "ID": id == null ? null : id,
    "vendor_id": vendorId == null ? null : vendorId,
    "author_id": authorId == null ? null : authorId,
    "author_name": authorName == null ? null : authorName,
    "author_email": authorEmail == null ? null : authorEmail,
    "review_title": reviewTitle == null ? null : reviewTitle,
    "review_description": reviewDescription == null ? null : reviewDescription,
    "review_rating": reviewRating == null ? null : reviewRating,
    "approved": approved == null ? null : approved,
    "created": created == null ? null : created.toIso8601String(),
  };
}
