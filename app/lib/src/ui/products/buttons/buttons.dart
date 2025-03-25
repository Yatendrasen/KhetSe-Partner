import 'package:flutter/material.dart';


class AccentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool showProgress;

  AccentButton({
    required this.onPressed,
    required this.text,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: showProgress
                ? new Container(
              width: 20.0,
              height: 20.0,
              child: new CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ): Text(text.toUpperCase(),
        )
    );
  }
}
