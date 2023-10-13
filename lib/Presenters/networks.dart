import 'dart:convert';
import 'package:http/http.dart' as http;
import '/constants.dart';

class NetworkWork_Presenters {


  // Future<String> rollcall_personnel(String? id, String? place) async {
  //   String message;
  //   print("dang diem danh");
  //   final response = await http.post(Uri.parse('${URL_ROLLCALL_PERSONNEL}$id'),
  //       body: {'place': "$place"});
  //   message = jsonDecode(response.body)['message'];
  //   print("Rollcall: $message");
  //   return message;
  // }


  // Future<dynamic> Detaill_Rollcall_By_Month(String? id) async {
  //   final response = await http.get(
  //     Uri.parse('${URL_STATISTICAL_BY_MONTH}$id'),
  //   );
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body)['data2'];
  //     //print("Length : $data");
  //     return data;
  //   } else
  //     return "Error";
  // }

  // Future<dynamic> Detail_Rollcall_By_Month_Year(
  //     String? id, int? month, int? year) async {
  //   final response = await http.post(
  //     Uri.parse('${URL_STATISTICAL_BY_MONTH_YEAR}$id'),
  //     body: {'date': '$year-$month'},
  //   );
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body)['data2'];
  //    // print("Length : $data");
  //     return data;
  //   } else
  //     return "Error";
  // }

  // Future<dynamic> Statistical_By_Month(String? id) async {
  //   final response = await http.get(
  //     Uri.parse('${URL_STATISTICAL_BY_MONTH}$id'),
  //   );
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body)['data'];
  //     //  print(data);
  //     return data;
  //   } else
  //     return "Error";
  // }

  // Future<dynamic> Statistical_By_Month_Year(
  //     String? id, int? month, int? year) async {
  //   final response = await http.post(
  //     Uri.parse('${URL_STATISTICAL_BY_MONTH_YEAR}$id'),
  //     body: {'date': '$year-$month'},
  //   );
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body)['data'];
  //     return data;
  //   } else
  //     return "Error";
  // }

  // Future getLocation() async {
  //   final response = await http.get(Uri.parse('$URL_GETLOCATION'));
  //    print("location: ${jsonDecode(response.body)['personnel'][0]}");
  //   return jsonDecode(response.body)['personnel'][0];
  // }




 

}
