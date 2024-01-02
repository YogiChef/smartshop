import 'package:flutter/material.dart';
import 'package:smartshop/services/service_firebase.dart';

class ConfirmButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function() press;
  final Color? color;

  const ConfirmButton({
    super.key,
    required this.label,
    required this.icon,
    required this.press, this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.yellow.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      label: Text(
        label,
        style: styles(fontSize: 16),
      ),
      onPressed: press,
      icon: Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
    );
  }
}
