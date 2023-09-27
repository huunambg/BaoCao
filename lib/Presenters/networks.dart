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

  Future getLocation_Admin(String? id) async {
    final response = await http.get(Uri.parse('$URL_GETLOCATION'));
    print(jsonDecode(response.body));
   return jsonDecode(response.body)['personnel'][0];
  }
  Future update_Location_Admin(String? name,String ? lat,String? long ,String? meter) async {
    final response = await http.put(Uri.parse('$URL_UPDATE_LOCATION_ADMIN'),body: {
      "name" :name,
      "latitude":lat,
      "longitude":long,
      "meter":meter
    });
    print(jsonDecode(response.body)['status']);
    return jsonDecode(response.body)['status'];
  }


  Future<dynamic> get_Mac_admin() async {
    final response = await http.get(Uri.parse('$URL_GET_MAC_ADMIN'));
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      print(jsonDecode(response.body)['mac']);
      return jsonDecode(response.body)['mac'];
    } else {
      return [];
    }
  }




  Future<dynamic> get_MAC_WIFI() async {
    final response = await http.get(Uri.parse('${URL_GET_WIFI_MAC_ADDRESS}'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['mac'];
    } else {
      return "Error";
    }
  }
  Future<dynamic> add_MAC_WIFI(String ?wifi,String ? mac) async {
    final response = await http.post(Uri.parse('${URL_ADD_MAC_ADMIN}'),body: {
        "name":wifi,
        "address":mac
    });
    if (response.statusCode == 200) {
      return "Success";
    } else {
      return "Error";
    }
  }
  Future<dynamic> delete_MAC_WIFI(String? id) async {
    final response = await http.delete(Uri.parse('${URL_DET_MAC_ADMIN}/$id'),body: {
    });
    if (response.statusCode == 200) {
      return "Success";
    } else {
      return "Error";
    }
  }


  Future<String> delete_User(String? id)async{
    final response = await http.delete(Uri.parse("$URL_DET_USER$id"));
    if(response.statusCode==200){
      return "Success";
    } else {
      return "Error";
    }
  }


 

}
