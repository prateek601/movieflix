// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

//hello testing
//again
//
///////
//test con....

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    required this.hasNext,
    required this.hasPrevious,
    required this.totalItems,
    required this.data,
  });

  bool hasNext;
  bool hasPrevious;
  int totalItems;
  List<Datum> data;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    hasNext: json["has_next"],
    hasPrevious: json["has_previous"],
    totalItems: json["total_items"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "has_next": hasNext,
    "has_previous": hasPrevious,
    "total_items": totalItems,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.title,
    required this.backdrop,
    required this.userReaction
  });

  int id;
  String title;
  String backdrop;
  int userReaction;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    backdrop: json["backdrop"],
    userReaction: 0
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "backdrop": backdrop,
  };
}
