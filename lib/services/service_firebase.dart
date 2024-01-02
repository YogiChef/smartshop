import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartshop/controllers/auth_controller.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
AuthController authController = AuthController();
SharedPreferences? sharedPreferences;
styles({
  double? letterSpacing,
  double? fontSize = 14,
  double? height,
  FontWeight? fontWeight = FontWeight.w400,
  Color? color = Colors.black87,
}) {
  return GoogleFonts.righteous(
    height: height,
    letterSpacing: letterSpacing,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}
