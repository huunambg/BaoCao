import 'dart:convert';

import 'package:personnel_5chaumedia/constants.dart';
import 'package:http/http.dart' as http;
class Rollcall_Presenter{
   Future<String> rollcall_personnel(String? id, String? place) async {
    String message;
    print("dang diem danh");
    final response = await http.post(Uri.parse('${URL_ROLLCALL_PERSONNEL}$id'),
        body: {'place': "$place"});
    message = jsonDecode(response.body)['message'];
    print("Rollcall: $message");
    return message;
  }


  Future<dynamic> Detaill_Rollcall_By_Month(String? id) async {
    final response = await http.get(
      Uri.parse('${URL_STATISTICAL_BY_MONTH}$id'),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data2'];
      //print("Length : $data");
      return data;
    } else
      return "Error";
  }

  Future<dynamic> Detail_Rollcall_By_Month_Year(
      String? id, int? month, int? year) async {
    final response = await http.post(
      Uri.parse('${URL_STATISTICAL_BY_MONTH_YEAR}$id'),
      body: {'date': '$year-$month'},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data2'];
     // print("Length : $data");
      return data;
    } else
      return "Error";
  }

  Future<dynamic> Statistical_By_Month(String? id) async {
    final response = await http.get(
      Uri.parse('${URL_STATISTICAL_BY_MONTH}$id'),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      //  print(data);
      return data;
    } else
      return "Error";
  }

  Future<dynamic> Statistical_By_Month_Year(
      String? id, int? month, int? year) async {
    final response = await http.post(
      Uri.parse('${URL_STATISTICAL_BY_MONTH_YEAR}$id'),
      body: {'date': '$year-$month'},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      return data;
    } else
      return "Error";
  }
  Future getLocation() async {
    final response = await http.get(Uri.parse('$URL_GETLOCATION'));
     print("location: ${jsonDecode(response.body)['personnel'][0]}");
    return jsonDecode(response.body)['personnel'][0];
  }

    Future<String> get_Text_QR_Rollcall() async {
    final response = await http.get(Uri.parse('$URL_GET_TEXT_QR_ROLLCALL'));
    if (response.statusCode == 200) {
      // print("SUCCESS");
      //  print(jsonDecode(response.body));
      return jsonDecode(response.body)['data']['content'];
    } else {
      // print("ERROR");
      return "ERROR";
    }
  }
  Future<dynamic> getdataRollcall_detail_day_one_day(
      String? month_year, String? id_per, String? day) async {
    final response = await http.get(Uri.parse(
        "${URL_GET_ROLLCALL_DETAIL_DAY_ONE_DAY}$month_year/$id_per/$day"));
    if (response.statusCode == 200) {
      //  print(jsonDecode(response.body)["data"]);
      return jsonDecode(response.body)["data"];
    } else
      return null;
  }


  Future<int> get_break_time() async {
    final response = await http.get(Uri.parse('${URL_GET_BREAK_TIME}'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'][0]['time'];
    } else {
      return 10000;
    }
  }

  Future<String> get_last_rollcall(String? id_personnel) async {
    final response =
        await http.get(Uri.parse('${URL_GET_LAST_ROLLCALL}$id_personnel'));

    if (response.statusCode == 200) {
      print(jsonDecode(response.body)['data']);
      return jsonDecode(response.body)['data'].toString();
    } else {
      return "Error";
    }
  }
}