import 'package:flutter/material.dart';
import 'package:html/parser.dart';

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
String parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}

showSnackBarError(BuildContext context, String message) {
  final snackBar = SnackBar(
      backgroundColor: Theme.of(context).colorScheme.error,
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.onError),
      ));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
//ScaffoldMessenger.of(context).showSnackBar(snackBar);