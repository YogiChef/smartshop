// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartshop/auth/login_page.dart';
import 'package:smartshop/services/service_firebase.dart';
import 'package:smartshop/views/buyers/main_page.dart';

import '../views/nav_page/widgets/input_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String fullName;
  late String email;
  late String password;
  late String phone;
  bool _isLoading = false;
  bool _obscureText = true;

  Uint8List? _image, _coverImage;

  _signUp() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      await authController
          .signUpUsers(fullName, email, password, phone, _image!, _coverImage)
          .whenComplete(() {
        setState(() {
          _formKey.currentState!.reset();
          _isLoading = false;
        });
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MainPage()));
      Fluttertoast.showToast(
          msg: 'Congratulations an Account has been Created for you');
    } else {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Please Fields must not eb empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                'Create Custorer\'s\n Account',
                textAlign: TextAlign.center,
                style: GoogleFonts.righteous(
                    fontSize: 24,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600),
              ),
            ),

            Center(
              child: Stack(
                children: [
                  Container(
                    height: 170,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(0),
                        image: _coverImage != null
                            ? DecorationImage(
                                image: MemoryImage(_coverImage!),
                                fit: BoxFit.cover)
                            : null),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.yellow.shade900,
                                backgroundImage: _image != null
                                    ? MemoryImage(_image!)
                                    : null,
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.cyan.shade400,
                                  radius: 18,
                                  child: IconButton(
                                      onPressed: () {
                                        chooseOption(context);
                                      },
                                      icon: _image != null
                                          ? const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 18,
                                            )
                                          : const Icon(
                                              CupertinoIcons.photo,
                                              color: Colors.white,
                                              size: 18,
                                            )),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.red.shade400,
                      radius: 18,
                      child: IconButton(
                          onPressed: () {
                            chooseOptionCoverImage(context);
                          },
                          icon: _image != null
                              ? const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : const Icon(
                                  CupertinoIcons.photo,
                                  color: Colors.white,
                                  size: 18,
                                )),
                    ),
                  ),
                ],
              ),
            ),
            InputTextfield(
              hintText: 'Enter Full Name',
              textInputType: TextInputType.text,
              prefixIcon: Icon(
                Icons.person,
                color: Colors.yellow.shade900,
              ),
              onChanged: (value) {
                setState(() {
                  fullName = value;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Plaese Enter your name';
                } else {
                  return null;
                }
              },
            ),
            InputTextfield(
              hintText: 'Enter Email',
              textInputType: TextInputType.emailAddress,
              prefixIcon: Icon(
                Icons.email,
                color: Colors.cyan.shade400,
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email addres';
                } else if (value.isValidEmail() == false) {
                  return 'invalid email';
                } else if (value.isValidEmail() == true) {
                  return null;
                } else {
                  return null;
                }
              },
            ),
            InputTextfield(
              hintText: 'Enter Password',
              textInputType: TextInputType.text,
              obscureText: _obscureText,
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.red.shade600,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText == true
                      ? Icons.visibility
                      : Icons.visibility_off,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length < 8) {
                  return 'Passwords longer than eight characters';
                } else {
                  return null;
                }
              },
            ),
            InputTextfield(
              hintText: 'Enter Full Phone',
              textInputType: TextInputType.phone,
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.green.shade300,
              ),
              onChanged: (value) {
                setState(() {
                  phone = value;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Plaese Enter your Phone';
                } else {
                  return null;
                }
              },
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: IntlPhoneField(
            //     validator: (value) {
            //       if (value == null) {
            //         return 'Please enter your phone';
            //       } else {
            //         return null;
            //       }
            //     },
            //     onChanged: (value) {
            //       setState(() {
            //         phone = value;
            //       });
            //     },
            //     invalidNumberMessage: 'invalid Mobile number',
            //     disableLengthCheck: true,
            //     decoration: InputDecoration(
            //       hintText: 'Phone',
            //       hintStyle: GoogleFonts.righteous(),
            //       focusedBorder: UnderlineInputBorder(
            //           borderSide:
            //               BorderSide(color: Colors.yellow.shade900, width: 2)),
            //       errorBorder: const UnderlineInputBorder(
            //           borderSide: BorderSide(color: Colors.red, width: 2)),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.yellow.shade900,
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow.shade900,
                        ),
                        onPressed: () {
                          _signUp();
                        },
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.righteous(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Already have an account',
                    style: GoogleFonts.righteous(fontSize: 14),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: Text(
                        'Login',
                        style: GoogleFonts.righteous(
                            color: Colors.cyan.shade400,
                            letterSpacing: 1,
                            fontSize: 16),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> chooseOption(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Choose option',
              style: GoogleFonts.righteous(
                fontWeight: FontWeight.w500,
                color: Colors.yellow.shade900,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  InkWell(
                    onTap: () {
                      selectCameca();
                      Navigator.pop(context);
                    },
                    splashColor: Colors.yellow.shade900,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.yellow.shade900,
                          ),
                        ),
                        Text(
                          'Camera',
                          style: GoogleFonts.righteous(
                            fontWeight: FontWeight.w500,
                            color: Colors.cyan.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      selectGallery();
                      Navigator.pop(context);
                    },
                    splashColor: Colors.yellow.shade900,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.image_outlined,
                            color: Colors.green.shade900,
                          ),
                        ),
                        Text(
                          'Gallery',
                          style: GoogleFonts.righteous(
                              fontWeight: FontWeight.w500,
                              color: Colors.cyan.shade400),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      remove();
                    },
                    splashColor: Colors.yellow.shade900,
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          'Remove',
                          style: GoogleFonts.righteous(
                              fontWeight: FontWeight.w500, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  selectCameca() async {
    Uint8List img = await authController.pickProfileImage(ImageSource.camera);
    setState(() {
      _image = img;
    });
  }

  selectGallery() async {
    final img = await authController.pickProfileImage(ImageSource.gallery);

    setState(() {
      _image = img;
    });
  }

  remove() {
    Navigator.pop(context);
  }

  Future<dynamic> chooseOptionCoverImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Choose option',
              style: GoogleFonts.righteous(
                fontWeight: FontWeight.w500,
                color: Colors.yellow.shade900,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  InkWell(
                    onTap: () {
                      selectCamecaCoverImg();
                      Navigator.pop(context);
                    },
                    splashColor: Colors.yellow.shade900,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.yellow.shade900,
                          ),
                        ),
                        Text(
                          'Camera',
                          style: GoogleFonts.righteous(
                            fontWeight: FontWeight.w500,
                            color: Colors.cyan.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      selectGalleryCoverImg();
                      Navigator.pop(context);
                    },
                    splashColor: Colors.yellow.shade900,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.image_outlined,
                            color: Colors.green.shade900,
                          ),
                        ),
                        Text(
                          'Gallery',
                          style: GoogleFonts.righteous(
                              fontWeight: FontWeight.w500,
                              color: Colors.cyan.shade400),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      removeCoverImg();
                    },
                    splashColor: Colors.yellow.shade900,
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          'Remove',
                          style: GoogleFonts.righteous(
                              fontWeight: FontWeight.w500, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  selectCamecaCoverImg() async {
    Uint8List img = await authController.pickProfileImage(ImageSource.camera);
    setState(() {
      _coverImage = img;
    });
  }

  selectGalleryCoverImg() async {
    final img = await authController.pickProfileImage(ImageSource.gallery);

    setState(() {
      _coverImage = img;
    });
  }

  removeCoverImg() {
    Navigator.pop(context);
  }
}
