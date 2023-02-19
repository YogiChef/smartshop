import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputTextfield extends StatelessWidget {
  const InputTextfield({
    Key? key,
    required this.textInputType,
    required this.prefixIcon,
    this.suffixIcon,
    required this.hintText,
    required this.validator,
   this.onChanged,
    this.controller,
    this.obscureText = false,
  }) : super(key: key);

  final TextInputType textInputType;
  final TextEditingController? controller;
  final Widget prefixIcon;
  final String hintText;
  final Widget? suffixIcon;
  final String? Function(String?) validator;
  final Function(String)? onChanged;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        keyboardType: textInputType,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          hintText: hintText,
          suffixIcon: suffixIcon,
          hintStyle: GoogleFonts.righteous(),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow.shade900, width: 2)),
          errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2)),
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^([a-zA-Z0-9]+)([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.][a-zA-Z0-9]{2,3})$')
        .hasMatch(this);
  }
}
