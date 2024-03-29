import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../services/service_firebase.dart';

class MyAlertDialog {
  static void showMyDialog({
    required BuildContext context,
    required ImageProvider<Object> img,
    required String title,
    required String contant,
    required Function() tabNo,
    required Function() tabYes,
  }) {
    showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Column(children: [
                Image(
                  image: img,
                  width: 120,
                  height: 100,
                ),
                Text(title),
              ]),
              content: Text(contant),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  onPressed: tabNo,
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                CupertinoDialogAction(
                    onPressed: tabYes,
                    child:
                        const Text('Yes', style: TextStyle(color: Colors.red)))
              ],
            ));
  }
}

class LoginDialog {
  static void showLoginDialog(BuildContext context) {
    showCupertinoDialog<void>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text('please log in'),
              content: const Text('you should be logged in to take an action'),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: Text(
                    'Log in',
                    style: styles(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'customer_login');
                  },
                )
              ],
            ));
  }
}
