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
  void login_success(var data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data1 = data['user'];
         print(data);
    if (data['role'] != "admin") {
      var data2 = data['id_per'][0];
      var data3 = data['pid'];
      String? id_per = data2['id'].toString();
      String? user_name = data1['name'].toString();
      String? email = data1['email'];
      String? id_personnel = data3[0]['personnel_id'];
      String? phone = data['phone'][0]['phone'].toString();
      // print(
      //     "Phone $phone id_personnel: $id_personnel email $email ,user_name :$user_name ,id_per: $id_per ");
      await prefs.setString('id_per', id_per);
      await prefs.setString('user_name', user_name);
      await prefs.setString('email', email!);
      await prefs.setString('id_personnel', id_personnel!);
      await prefs.setString('phone', phone);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RootUser()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeAdmin()),
      );
    }
  }
}
