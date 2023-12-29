import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:smartshop/auth/login_page.dart';
import 'package:smartshop/inner_page/edit_profile.dart';
import 'package:smartshop/inner_page/orders_page.dart';
import 'package:smartshop/services/service_firebase.dart';
import 'package:smartshop/views/nav_page/cart_page.dart';
import 'package:smartshop/views/nav_page/widgets/dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = firestore.collection('buyers');
    return auth.currentUser == null
        ? Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.33,
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(50, 50, 20, 50),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/profile.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 50,
                              child: Icon(
                                Icons.person,
                                size: 90,
                                color: Colors.yellow.shade900,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    textAlign: TextAlign.center,
                                    style: styles(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  Text(
                                    '',
                                    textAlign: TextAlign.center,
                                    style: styles(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.yellow.shade900,
                                        ),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginPage()));
                                        },
                                        child: Text(
                                          'Login Account',
                                          style: styles(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 60,
                        child: Text(
                          'Profile',
                          style: styles(
                              fontSize: 20, color: Colors.yellow.shade900),
                        ),
                      ),
                      Positioned(
                          top: 40,
                          right: 20,
                          child: Icon(CupertinoIcons.moon,
                              color: Colors.yellow.shade900))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  firstBlock(
                      onPress: () {}, icon: Icons.settings, text: 'Settings'),
                  firstBlock(
                    onPress: () {},
                    icon: Icons.phone,
                    text: 'Phone',
                  ),
                  firstBlock(
                      onPress: () {}, icon: Icons.shopping_cart, text: 'Cart'),
                  firstBlock(
                      onPress: () {}, icon: Icons.description, text: 'Orders'),
                  firstBlock(
                      onPress: () {
                        MyAlertDialog.showMyDialog(
                            contant: 'Are you sure to log out ',
                            context: context,
                            img: const AssetImage('images/signout.png'),
                            tabNo: () {
                              Navigator.pop(context);
                            },
                            tabYes: () async {
                              await auth.signOut().whenComplete(() =>
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage())));

                              await Future.delayed(
                                  const Duration(microseconds: 100));
                            },
                            title: 'Log Out');
                      },
                      icon: Icons.logout,
                      text: 'Logout'),
                ],
              ),
            ),
          )
        : FutureBuilder<DocumentSnapshot>(
            future: users.doc(auth.currentUser!.uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return const Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.33,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.fromLTRB(50, 50, 20, 50),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(data['coverImage']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        NetworkImage(data['profileImage']),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['fullName'],
                                          textAlign: TextAlign.center,
                                          style: styles(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          data['email'],
                                          textAlign: TextAlign.center,
                                          style: styles(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 35,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.yellow.shade900,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5))),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditProfile(
                                                              userData: data,
                                                            )));
                                              },
                                              child: Text(
                                                'Edit Profile',
                                                style: styles(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 40,
                              left: 60,
                              child: Text(
                                'Profile',
                                style: styles(
                                    fontSize: 20,
                                    color: Colors.yellow.shade900),
                              ),
                            ),
                            Positioned(
                                top: 40,
                                right: 20,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white24,
                                  child: IconButton(
                                    icon: Icon(IconlyBold.user2,
                                        color: Colors.yellow.shade900),
                                    onPressed: () {
                                      Navigator.pushNamed(context, ('users'));
                                    },
                                  ),
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        firstBlock(
                            onPress: () {},
                            icon: Icons.settings,
                            text: 'Settings'),
                        firstBlock(
                            onPress: () {},
                            icon: Icons.phone,
                            text: 'Phone',
                            subtitle: data['phone']),
                        firstBlock(
                            onPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CartPage()));
                            },
                            icon: Icons.shopping_cart,
                            text: 'Cart'),
                        firstBlock(
                            onPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const OrderPage()));
                            },
                            icon: Icons.description,
                            text: 'Orders'),
                        firstBlock(
                            onPress: () {
                              MyAlertDialog.showMyDialog(
                                  contant: 'Are you sure to log out ',
                                  context: context,
                                  img: const AssetImage('images/signout.png'),
                                  tabNo: () {
                                    Navigator.pop(context);
                                  },
                                  tabYes: () async {
                                    await auth.signOut().whenComplete(() =>
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage())));

                                    await Future.delayed(
                                        const Duration(microseconds: 100));
                                  },
                                  title: 'Log Out');
                            },
                            icon: Icons.logout,
                            text: 'Logout'),
                      ],
                    ),
                  ),
                );
              }

              return Center(
                child: CircularProgressIndicator(
                  color: Colors.yellow.shade900,
                ),
              );
            },
          );
  }

  firstBlock(
      {required IconData icon,
      required String text,
      String subtitle = '',
      required VoidCallback onPress}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListTile(
        onTap: onPress,
        leading: Icon(
          icon,
        ),
        title: Text(
          text,
          style: styles(fontSize: 18, color: Colors.black54),
        ),
        subtitle:
            Text(subtitle, style: styles(fontSize: 15, color: Colors.black54)),
      ),
    );
  }
}
