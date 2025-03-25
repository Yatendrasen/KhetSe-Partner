import 'package:flutter/material.dart';

class CustomBottomButton extends StatelessWidget {
  CustomBottomButton({Key? key, required this.child}) : super(key: key);

  final Widget child;
  final double margin = 0;
  final double elevation = 0.0;
  final double borderRadius = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      margin: EdgeInsets.fromLTRB(margin, margin, margin, margin),
      child: SafeArea(
        child: Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: child
        ),
      ),
    );
  }
}