import 'dart:convert';

Quotes quotesFromJson(String str) => Quotes.fromJson(json.decode(str));

String quotesToJson(Quotes data) => json.encode(data.toJson());

class Quotes {
  Quotes({
    this.id,
    this.tags,
    this.content = '',
    this.author = '',
    this.authorSlug,
    this.length,
    this.dateAdded,
    this.dateModified,
  });

  String? id;
  List<String>? tags;
  String content;
  String author;
  String? authorSlug;
  int? length;
  DateTime? dateAdded;
  DateTime? dateModified;

  factory Quotes.fromJson(Map<String, dynamic> json) => Quotes(
        id: json["_id"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        content: json["content"],
        author: json["author"],
        authorSlug: json["authorSlug"],
        length: json["length"],
        dateAdded: DateTime.parse(json["dateAdded"]),
        dateModified: DateTime.parse(json["dateModified"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "tags": List<dynamic>.from(tags!.map((x) => x)),
        "content": content,
        "author": author,
        "authorSlug": authorSlug,
        "length": length,
        "dateAdded":
            "${dateAdded!.year.toString().padLeft(4, '0')}-${dateAdded!.month.toString().padLeft(2, '0')}-${dateAdded!.day.toString().padLeft(2, '0')}",
        "dateModified":
            "${dateModified!.year.toString().padLeft(4, '0')}-${dateModified!.month.toString().padLeft(2, '0')}-${dateModified!.day.toString().padLeft(2, '0')}",
      };
}
