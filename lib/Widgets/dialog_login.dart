import 'package:flutter/material.dart';
import 'package:personnel_5chaumedia/Views/login/login.dart';

class Dilalog_Login {
  void dialog_loading(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  void dialog_login_error(BuildContext context, String titile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Đăng nhập thất bại !'),
        content: Text(titile),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void dialog_loading_error(BuildContext context, String titile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Đăng nhập thất bại !'),
        content: Text(titile),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        ],
      ),
    );
  }

  void dialog_login_error_conection(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lỗi'),
        content: Text('Đã xảy ra lỗi kết nối.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        ],
      ),
    );
  }
}
