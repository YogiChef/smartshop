// ignore_for_file: unnecessary_null_comparison

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../services/service_firebase.dart';

class AuthController {
  FirebaseAuth auth = FirebaseAuth.instance;
  imageToStorage(Uint8List image) async {
    Reference ref =
        storage.ref().child('profilePick').child(auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  coverImageToStorage(Uint8List coverimage) async {
    Reference ref =
        storage.ref().child('coverPick').child(auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(coverimage);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  pickProfileImage(ImageSource source) async {
    final imgPicker = ImagePicker();
    XFile? file = await imgPicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      Fluttertoast.showToast(msg: 'No Image Selected');
    }
  }

  Future<String> signUpUsers(String fullName, String email, String password,
      String phone, Uint8List image, coverImg) async {
    String res = 'Some error occured';
    try {
      if (fullName.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          phone.isNotEmpty &&
          image != null &&
          coverImg != null) {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String profileImagUrl = await imageToStorage(image);
        String coverImage = await coverImageToStorage(coverImg);
        await firestore.collection('buyers').doc(cred.user!.uid).set({
          'buyerId': cred.user!.uid,
          'fullName': fullName,
          'email': email,
          'phone': phone,
          'profileImage': profileImagUrl,
          'coverImage': coverImage,
          'address': '',
        });
        res = 'success';
      } else {
        res = 'Please fields must not be empty';
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return res;
  }

  loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);

        Fluttertoast.showToast(msg: 'success');
      } else {
        Fluttertoast.showToast(msg: 'Please Fields must not be empty');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
