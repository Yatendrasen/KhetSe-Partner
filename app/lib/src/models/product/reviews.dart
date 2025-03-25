// To parse this JSON data, do
//
//     final reviews = reviewsFromJson(jsonString);

import 'dart:convert';

List<Reviews> reviewsFromJson(String str) => List<Reviews>.from(json.decode(str).map((x) => Reviews.fromJson(x)));

String reviewsToJson(List<Reviews> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reviews {
  Reviews({
    required this.id,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.productId,
    required this.status,
    required this.reviewer,
    required this.reviewerEmail,
    required this.review,
    required this.rating,
    required this.verified,
    required this.reviewerAvatarUrls,
  });

  int id;
  DateTime dateCreated;
  DateTime dateCreatedGmt;
  int productId;
  String status;
  String reviewer;
  String reviewerEmail;
  String review;
  double rating;
  bool verified;
  Map<String, String> reviewerAvatarUrls;

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
    id: json["id"] == null ? null : json["id"],
    dateCreated: json["date_created"] == null ? DateTime.now() : DateTime.parse(json["date_created"]),
    dateCreatedGmt: json["date_created_gmt"] == null ? DateTime.now() : DateTime.parse(json["date_created_gmt"]),
    productId: json["product_id"] == null ? null : json["product_id"],
    status: json["status"] == null ? null : json["status"],
    reviewer: json["reviewer"] == null ? null : json["reviewer"],
    reviewerEmail: json["reviewer_email"] == null ? null : json["reviewer_email"],
    review: json["review"] == null ? null : json["review"],
    rating: json["rating"] == null ? 0 : double.parse(json["rating"].toString()),
    verified: json["verified"] == null ? null : json["verified"],
    reviewerAvatarUrls: json["reviewer_avatar_urls"] == null ? {} : Map.from(json["reviewer_avatar_urls"]).map((k, v) => MapEntry<String, String>(k, v)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "date_created": dateCreated == null ? null : dateCreated.toIso8601String(),
    "date_created_gmt": dateCreatedGmt == null ? null : dateCreatedGmt.toIso8601String(),
    "product_id": productId == null ? null : productId,
    "status": status == null ? null : status,
    "reviewer": reviewer == null ? null : reviewer,
    "reviewer_email": reviewerEmail == null ? null : reviewerEmail,
    "review": review == null ? null : review,
    "rating": rating == null ? null : rating,
    "verified": verified == null ? null : verified,
    "reviewer_avatar_urls": reviewerAvatarUrls == null ? null : Map.from(reviewerAvatarUrls).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}

class Reviewer {
  Reviewer({
    required this.embeddable,
    required this.href,
  });

  bool embeddable;
  String href;

  factory Reviewer.fromJson(Map<String, dynamic> json) => Reviewer(
    embeddable: json["embeddable"] == null ? null : json["embeddable"],
    href: json["href"] == null ? null : json["href"],
  );

  Map<String, dynamic> toJson() => {
    "embeddable": embeddable == null ? null : embeddable,
    "href": href == null ? null : href,
  };
}
