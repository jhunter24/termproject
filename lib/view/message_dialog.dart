

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageDialog {
  static void errorMessage(
      {BuildContext context, String title, String content}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  


  
}
