import 'package:flutter/material.dart';
import 'package:personnel_5chaumedia/Views/login/login_Interface.dart';
import 'package:personnel_5chaumedia/Presenters/login_presenter.dart';
import 'package:personnel_5chaumedia/Views/admin/homeadmin.dart';
import 'package:personnel_5chaumedia/Views/user/root.dart';
import 'package:personnel_5chaumedia/Widgets/dialog_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> implements Login_Interface {
  late Login_Presenter login_presenter;

_LoadingState(){
 login_presenter = new Login_Presenter(this);
}
  @override
  void initState() {
    super.initState();
    login_presenter.load_login(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void login_error(var message) {
  Dilalog_Login().dialog_login_error(context, message);
  }

  
  @override
  void login_success_admin() {
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeAdmin()),
      );
  }
  
  @override
  void login_success_personnel() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RootUser()),
      );
  }
}
