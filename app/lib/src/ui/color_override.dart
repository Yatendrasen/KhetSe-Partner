import 'package:flutter/material.dart';

class PrimaryColorOverride extends StatelessWidget {
  const PrimaryColorOverride({Key? key, required this.child}) : super(key: key);

  //final color = Theme.of(context).colorScheme.secondary;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black;//Theme.of(context).colorScheme.secondary;
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(primaryColor: color),
    );
  }
}