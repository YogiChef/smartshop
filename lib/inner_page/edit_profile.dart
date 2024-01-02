// ignore_for_file: unused_field

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartshop/services/service_firebase.dart';
import 'package:uuid/uuid.dart';
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
  late String zipcode;
  String countryValue = 'Country';
  String stateValue = 'State';
  String cityValue = 'City';

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
    var chooseAddress = countryValue != 'Choose Country' &&
        stateValue != 'Choose State' &&
        cityValue != 'Choose City';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: styles(
            fontSize: 20,
          ),
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: ListView(
          children: [
            Center(
              child: Text(
                'Create Custorer\'s\n Account',
                textAlign: TextAlign.center,
                style: styles(fontSize: 20),
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
              textInputType: TextInputType.text,
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SelectState(onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                    });
                  }, onStateChanged: (value) {
                    stateValue = value;
                  }, onCityChanged: (value) {
                    cityValue = value;
                  }),
                  SizedBox(
                    width: double.infinity,
                    child: InputTextfield(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your zip code';
                        } else {
                          return null;
                        }
                      },
                      hintText: 'zipcode',
                      prefixIcon: const Icon(Icons.push_pin),
                      textInputType: TextInputType.number,
                      onChanged: (value) {
                        zipcode = value;
                      },
                    ),
                  ),
                ],
              ),
            ),

            Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () async {
                            EasyLoading.show(status: 'Updating..');
                            if (chooseAddress) {
                              CollectionReference addresRf = firestore
                                  .collection('buyers')
                                  .doc(auth.currentUser!.uid)
                                  .collection('address');
                              var addresId = const Uuid().v4();
                              await addresRf.doc(addresId).set({
                                'addressId': addresId,
                                'fullName': fullName.text,
                                'email': email.text,
                                'phone': phone.text,
                                'address': address,
                                'country': countryValue,
                                'state': stateValue,
                                'city': cityValue,
                                'zipcode': zipcode,
                                'default': true,
                              }).whenComplete(() {
                                EasyLoading.dismiss();
                                Navigator.pop(context);
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Please set your location');
                            }
                          },
                          child: Text(
                            'Update',
                            style: styles(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          )),
                )),
          ],
        ),
      ),
    );
  }
}
