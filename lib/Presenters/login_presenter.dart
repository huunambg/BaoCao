import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:personnel_5chaumedia/Views/admin/homeadmin.dart';
import 'package:personnel_5chaumedia/Views/login.dart';
import 'package:personnel_5chaumedia/Views/root.dart';
import 'package:personnel_5chaumedia/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login_Presenter{

void login(BuildContext context,String email,String password,bool rememberMe) async {
    String url = '$URL_LOGIN';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };
    try {
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
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Đăng nhập thành công
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

        var data = jsonDecode(response.body)['user'];

        //     print(jsonDecode(response.body));
        if (data['role'] != "admin") {
          var data2 = jsonDecode(response.body)['id_per'][0];
          var data3 = jsonDecode(response.body)['pid'];
          String? id_per = data2['id'].toString();
          String? user_name = data['name'].toString();
          String? email = data['email'];
          String? id_personnel = data3[0]['personnel_id'];
          String? phone =
              jsonDecode(response.body)['phone'][0]['phone'].toString();
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
      } else {
        Navigator.pop(context);
        // Đăng nhập thất bại
        var responseData = jsonDecode(response.body);
        String errorMessage = responseData['message'];

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Đăng nhập thất bại!'),
            content: Text(errorMessage),
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
    } catch (error) {
      // Xảy ra lỗi kết nối
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Lỗi'),
          content: Text('Đã xảy ra lỗi kết nối.'),
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
  }


 Future<void> load_login(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = await prefs.getString('email');
    String? savedPassword = await prefs.getString('password');
    bool? is_Logout = await prefs.getBool("is_logout");

    if (savedEmail != null && savedPassword != null && is_Logout == false) {
      String url = '$URL_LOGIN';

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> data = {
        'email': savedEmail,
        'password': savedPassword,
      };

      try {
        var response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(data),
        );
        if (response.statusCode == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
           print(jsonDecode(response.body));
           
        var data = jsonDecode(response.body)['user'];

        //     print(jsonDecode(response.body));
        if (data['role'] != "admin") {
          var data2 = jsonDecode(response.body)['id_per'][0];
          var data3 = jsonDecode(response.body)['pid'];
          String? id_per = data2['id'].toString();
          String? user_name = data['name'].toString();
          String? email = data['email'];
          String? id_personnel = data3[0]['personnel_id'];
          String? phone =
              jsonDecode(response.body)['phone'][0]['phone'].toString();
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

        } else {
          // Đăng nhập thất bại
          var responseData = jsonDecode(response.body);
          String errorMessage = responseData['message'];

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Đăng nhập thất bại !'),
              content: Text(errorMessage),
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
      } catch (error) {
        // Xảy ra lỗi kết nối
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
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

}