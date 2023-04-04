// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshop/auth/register.dart';
import 'package:smartshop/services/service_firebase.dart';
import 'package:smartshop/views/buyers/main_page.dart';

import '../views/nav_page/widgets/input_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  bool _obscureText = true;
  bool _isLoading = false;

  login() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      await authController.loginUser(email, password);
      _formKey.currentState!.reset();

      await Future.delayed(const Duration(microseconds: 100)).whenComplete(() =>
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainPage())));

      Fluttertoast.showToast(msg: 'You are now login');
    } else {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Please feilds most not be empty');
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Login\nCustorer\'s Account',
                textAlign: TextAlign.left,
                style: styles(fontSize: 24,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InputTextfield(
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
                hintText: 'Enter Email',
                textInputType: TextInputType.emailAddress,
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.cyan.shade400,
                )),
            InputTextfield(
              hintText: 'Enter Password',
              textInputType: TextInputType.text,
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.red.shade600,
              ),
              obscureText: _obscureText,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Colors.yellow.shade900,
                      ))
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow.shade900,
                        ),
                        onPressed: () {
                          login();
                        },
                        child: Text(
                          'Login',
                          style: styles(fontSize: 20,
                            fontWeight: FontWeight.w500,)
                        )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Need an account',
                    style: GoogleFonts.righteous(fontSize: 14),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                      },
                      child: Text(
                        'SignUp',
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
}
