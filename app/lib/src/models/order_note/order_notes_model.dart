import 'dart:convert';

class OrderNotesModel {
  final List<OrderNote> ordernotes;

  OrderNotesModel({
    required this.ordernotes,
  });

  factory OrderNotesModel.fromJson(List<dynamic> parsedJson) {

    List<OrderNote> ordernotes = [];
    ordernotes = parsedJson.map((i)=>OrderNote.fromJson(i)).toList();

    return new OrderNotesModel(ordernotes : ordernotes);
  }

}
// To parse this JSON data, do
//
//     final orderNote = orderNoteFromJson(jsonString);



List<OrderNote> orderNoteFromJson(String str) => List<OrderNote>.from(json.decode(str).map((x) => OrderNote.fromJson(x)));

String orderNoteToJson(List<OrderNote> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderNote {
  int id;
  String? author;
  DateTime dateCreated;
  DateTime dateCreatedGmt;
  String note;
  bool customerNote;

  OrderNote({
    required this.id,
    this.author,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.note,
    required this.customerNote,
  });

  factory OrderNote.fromJson(Map<String, dynamic> json) => OrderNote(
    id: json["id"] == null ? 0 : json["id"],
    author: json["author"] == null ? '' : json["author"],
    dateCreated: json["date_created"] == null ? DateTime.now() : DateTime.parse(json["date_created"]),
    dateCreatedGmt: json["date_created_gmt"] == null ? DateTime.now() : DateTime.parse(json["date_created_gmt"]),
    note: json["note"] == null ? '' : json["note"],
    customerNote: json["customer_note"] == null ? false : json["customer_note"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "author": author == null ? null : author,
    "note": note == null ? null : note,
    "customer_note": customerNote == null ? null : customerNote,
  };
}