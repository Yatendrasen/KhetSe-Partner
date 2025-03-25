// To parse this JSON data, do
//
//     final site = siteFromJson(jsonString);

import 'dart:convert';

Site siteFromJson(String str) => Site.fromJson(json.decode(str));

String siteToJson(Site data) => json.encode(data.toJson());

class Site {
  Site({
    required this.name,
    required this.description,
    required this.url,
    required this.home,
    //required this.gmtOffset,
    //required this.timezoneString,
  });

  String name;
  String description;
  String url;
  String home;
  //String gmtOffset;
  //String timezoneString;

  factory Site.fromJson(Map<String, dynamic> json) => Site(
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    url: json["url"] == null ? null : json["url"],
    home: json["home"] == null ? null : json["home"],
    //gmtOffset: json["gmt_offset"] == null ? null : json["gmt_offset"],
    //timezoneString: json["timezone_string"] == null ? null : json["timezone_string"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "description": description == null ? null : description,
    "url": url == null ? null : url,
    "home": home == null ? null : home,
    //"gmt_offset": gmtOffset == null ? null : gmtOffset,
    //"timezone_string": timezoneString == null ? null : timezoneString,
  };
}
