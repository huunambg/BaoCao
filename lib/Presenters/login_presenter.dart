import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:personnel_5chaumedia/Views/login/login_Interface.dart';
import 'package:personnel_5chaumedia/Views/login/login.dart';
import 'package:personnel_5chaumedia/Widgets/dialog_login.dart';
import 'package:personnel_5chaumedia/Const/rourte_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login_Presenter {
  late Login_Interface _login_interface;

  Login_Presenter(Login_Interface login_interface) {
    this._login_interface = login_interface;
  }

  void login(BuildContext context, String email, String password,
      bool rememberMe) async {
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };
    String url = URL_LOGIN;

    try {
      Dilalog_Login().dialog_loading(context);
      var response = await http.post(
        Uri.parse("$url"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (rememberMe) {
          await prefs.setString('email', email);
          await prefs.setString('password', password);
          await prefs.setBool('rememberMe', true);
          await prefs.setBool("is_logout", false);
        } else {
          await prefs.remove('email');
          await prefs.remove('password');
          await prefs.remove('rememberMe');
        }
        var data = jsonDecode(response.body);

        var data1 = data['user'];
        if (data1['role'] != "admin") {
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

          _login_interface.login_success_personnel();
        } else {
          _login_interface.login_success_admin();
        }
      } else {
        Navigator.pop(context);
        var responseData = data;
        String errorMessage = responseData['message'];
        _login_interface.login_error(errorMessage);
      }
    } catch (error) {
      String errorMessage = "Đã xảy ra lỗi kết nối !";
      _login_interface.login_error(errorMessage);
    }
  }

  Future<void> load_login(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = await prefs.getString('email');
    String? savedPassword = await prefs.getString('password');
    bool? is_Logout = await prefs.getBool("is_logout");
    String url = URL_LOGIN;
    if (savedEmail != null && savedPassword != null && is_Logout == false) {
      Map<String, dynamic> data = {
        'email': savedEmail,
        'password': savedPassword,
      };
      try {
        var response = await http.post(
          Uri.parse("$url"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
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
            _login_interface.login_success_personnel();
          } else {
            _login_interface.login_success_admin();
          }
          _login_interface.login_success_personnel();
        } else {
          // Đăng nhập thất bại
          var responseData = jsonDecode(response.body);
          String errorMessage = responseData['message'];
          _login_interface.login_error(errorMessage);
        }
      } catch (error) {
        // Xảy ra lỗi kết nối
        String errorMessage = "Đã xảy ra lỗi kết nối !";
        _login_interface.login_error(errorMessage);
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }
}
