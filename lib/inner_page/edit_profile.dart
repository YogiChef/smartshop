// ignore_for_file: unused_field

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshop/services/service_firebase.dart';
import '../views/nav_page/widgets/input_textfield.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.userData});
  final dynamic userData;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final fullName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final bool _isLoading = false;

  String? address;

  Uint8List? _image, _coverImage;

  @override
  void initState() {
    setState(() {
      fullName.text = widget.userData['fullName'];
      email.text = widget.userData['email'];
      phone.text = widget.userData['phone'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.righteous(fontSize: 24, color: Colors.black54),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black54,
            )),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
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

          // Center(
          //   child: Stack(
          //     children: [
          //       Container(
          //         height: 170,
          //         width: double.infinity,
          //         decoration: BoxDecoration(
          //             color: Colors.grey.shade300,
          //             borderRadius: BorderRadius.circular(0),
          //             image: _coverImage != null
          //                 ? DecorationImage(
          //                     image: MemoryImage(_coverImage!),
          //                     fit: BoxFit.cover)
          //                 : null),
          //         child: Padding(
          //           padding: const EdgeInsets.only(left: 30),
          //           child: Row(
          //             children: [
          //               Stack(
          //                 children: [
          //                   CircleAvatar(
          //                     radius: 50,
          //                     backgroundColor: Colors.yellow.shade900,
          //                     backgroundImage: _image != null
          //                         ? MemoryImage(_image!)
          //                         : null,
          //                   ),
          //                   Positioned(
          //                     right: 0,
          //                     bottom: 0,
          //                     child: CircleAvatar(
          //                       backgroundColor: Colors.cyan.shade400,
          //                       radius: 18,
          //                       child: IconButton(
          //                           onPressed: () {
          //                             // chooseOption(context);
          //                           },
          //                           icon: _image != null
          //                               ? const Icon(
          //                                   Icons.edit,
          //                                   color: Colors.white,
          //                                   size: 18,
          //                                 )
          //                               : const Icon(
          //                                   CupertinoIcons.photo,
          //                                   color: Colors.white,
          //                                   size: 18,
          //                                 )),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       Positioned(
          //         right: 0,
          //         bottom: 0,
          //         child: CircleAvatar(
          //           backgroundColor: Colors.red.shade400,
          //           radius: 18,
          //           child: IconButton(
          //               onPressed: () {
          //                 // chooseOptionCoverImage(context);
          //               },
          //               icon: _image != null
          //                   ? const Icon(
          //                       Icons.edit,
          //                       color: Colors.white,
          //                       size: 18,
          //                     )
          //                   : const Icon(
          //                       CupertinoIcons.photo,
          //                       color: Colors.white,
          //                       size: 18,
          //                     )),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          InputTextfield(
            hintText: 'Enter Full Name',
            textInputType: TextInputType.text,
            prefixIcon: Icon(
              Icons.person,
              color: Colors.yellow.shade900,
            ),
            controller: fullName,
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
            controller: email,
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
            hintText: 'Enter Phone Number',
            textInputType: TextInputType.phone,
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.green.shade300,
            ),
            controller: phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Plaese Enter your Phone';
              } else {
                return null;
              }
            },
          ),
          InputTextfield(
            hintText: 'Enter Your Address',
            textInputType: TextInputType.phone,
            prefixIcon: const Icon(
              Icons.pin_drop_outlined,
              color: Colors.red,
            ),
            onChanged: (value) {
              address = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Plaese Enter your address';
              } else {
                return null;
              }
            },
          ),

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
                      onPressed: () async {
                        EasyLoading.show(status: 'Updating..');
                        await firestore
                            .collection('buyers')
                            .doc(auth.currentUser!.uid)
                            .update({
                          'fullName': fullName.text,
                          'email': email.text,
                          'phone': phone.text,
                          'address': address,
                        }).whenComplete(() {
                          EasyLoading.dismiss();
                          Navigator.pop(context);
                        });
                      },
                      child: Text(
                        'Update',
                        style: GoogleFonts.righteous(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
            ),
          ),
        ],
      ),
    );
  }
}
