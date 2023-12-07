import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:personnel_5chaumedia/Views/user/acount/acount_interface.dart';
import 'package:personnel_5chaumedia/Const/rourte_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class Account_Presenter {
  late Account_Interface _account_interface;
  Account_Presenter(Account_Interface account_interface) {
    this._account_interface = account_interface;
  }

  void update_Profile() {
    _account_interface.update_Profile();
  }

  void update_Password() {
    _account_interface.update_Password();
  }

  Future<void> show_Mac_Wifi() async {
    NetworkInfo networkInfo = NetworkInfo();
    String? Mac = await networkInfo.getWifiBSSID();
    String? Wifi = await networkInfo.getWifiName();
    _account_interface.show_Mac_Wifi(Wifi, Mac);
  }

  void setting() {
    String message = "Bạn đã chuyển đổi màu nên hình nền";
    _account_interface.settings(message);
  }

  Future<void> logout(BuildContext context) async {
        final respone = await http.get(Uri.parse(URL_LOGOUT));
    if (respone.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      await prefs.setBool("is_logout", true);
      String? id_company = await prefs.getString('company_id');
      await _firebaseMessaging.unsubscribeFromTopic("$id_company");
      prefs.remove('company_id');
      Navigator.pop(context);
             _account_interface.logout(true);
    }
 
  }
}
