import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({Key? key, required this.onPressed, required this.child})
      : super(key: key);
  final Function() onPressed;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      hoverColor: Colors.amberAccent,
      onPressed: onPressed,
      child: child,
    );
  }
}
