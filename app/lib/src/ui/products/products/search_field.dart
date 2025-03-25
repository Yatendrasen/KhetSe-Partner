import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class SearchBarField extends StatefulWidget {
  final Function(String) onChanged;
  final bool autofocus;
  final TextEditingController searchTextController;
  final String hintText;
  const SearchBarField({Key? key, required this.onChanged, required this.searchTextController, required this.hintText, required this.autofocus}) : super(key: key);
  @override
  _SearchBarFieldState createState() => _SearchBarFieldState();
}

class _SearchBarFieldState extends State<SearchBarField> {

  Color? fillColor;

  @override
  Widget build(BuildContext context) {

    if(Theme.of(context).appBarTheme.backgroundColor != null) {
      fillColor = Theme.of(context).appBarTheme.backgroundColor.toString().substring(Theme.of(context).appBarTheme.backgroundColor.toString().length - 7) == 'ffffff)' ? Colors.grey[50] : Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
    } else fillColor = Theme.of(context).brightness == Brightness.light ? Colors.grey[50] : Colors.black12;

    return SizedBox(
      //height: 38,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: fillColor,
            ),
            child: CupertinoTextField(
              controller: widget.searchTextController,
              autofocus: widget.autofocus,
              placeholder: widget.hintText,
              keyboardType: TextInputType.text,
              onChanged: widget.onChanged,
              placeholderStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).textTheme.titleSmall!.color
              ),
              prefix: Padding(
                padding: const EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
                child: Icon(
                  Icons.search,
                  color: Theme.of(context).textTheme.titleSmall!.color!.withOpacity(0.6),
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          )
      ),
    );
  }
}