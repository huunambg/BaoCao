import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:personnel_5chaumedia/constants.dart';

class Profile_Presenter{
   Future<dynamic> edit_img(String? id, String? img) async {
    final response = await http.put(Uri.parse('${URL_EDIT_EDITIMG}$id/editimg'),
        body: {"img": "$img"});
    print("Status IMG ${response.statusCode}");
    if (jsonDecode(response.body)['status'] == 200) {
      return "Success";
    } else {
      return "Error";
    }
  }

  Future<String> get_base64_img(String? id) async {
    final response = await http.get(Uri.parse('${URL_GET_BASE64_IMG}$id'));
    print("Get IMG :${response.statusCode}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['image'];
    } else {
      return "Error";
    }
  }

  Future<String> edit_ProfileS(String? id,String? name,String? email,String? phone,String? pass) async {
    final response = await http.put(Uri.parse('${URL_EDIT_PROFILE}$id/edit'),body: {
      "name":"$name",
      "email":"$email",
      "phone":"$phone",
      "password":"$pass"
    });
    print("Edit Profile :${response.statusCode}");
    if (response.statusCode == 200) {
      return "Success";
    } else {
      return "Error";
    }
  }
}