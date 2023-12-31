import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:personnel_5chaumedia/Views/user/notification/notification_interface.dart';
import 'package:personnel_5chaumedia/Services/network_request.dart';
import 'package:personnel_5chaumedia/Const/rourte_api.dart';

class Notification_Presenter{
     
   late Notification_Interface _notification_interface;

    Notification_Presenter(Notification_Interface notification_interface){
      this._notification_interface = notification_interface;
    }


Future<void> get_Data() async {
   List<dynamic> data = await NetworkRequest().fetchData_Notification();
  _notification_interface.get_Notificatioon(data);


}

 void see_Detail_Notification(var data){
  _notification_interface.see_Detail_Notification(data);
 }
 

    Future<dynamic> fetchData_Notification() async {
    final response = await http.get(Uri.parse('$URL_GET_NOTIFICATION'));

    if (response.statusCode == 200) {
   //   print(List.from(jsonDecode(response.body)['data'].reversed.toList()));
      return List.from(jsonDecode(response.body)['data'].reversed.toList());
    } else if (response.statusCode == 404) {
      return [];
    }
  }




  Future<int> get_count_notification_not_check(String? id) async {
    final response =
        await http.get(Uri.parse('$URL_GET_COUNT_NOTIFICATION_NOT_CHECKED$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['count'];
    } else {
      return 0;
    }
  }

  Future<dynamic> fetch_Data_Notification_Checked(String? id) async {
    final response =
        await http.get(Uri.parse('${URL_GET_NOTIFICATION_CHECKED}$id')); //
    if (response.statusCode == 200) {
   //   print(jsonDecode(response.body)['data']);
      return jsonDecode(response.body)['data'];
    } else {
        // print("Error");
      return [];
    }
  }

  Future<void> set_Data_Notification_Checked(String? id_per, int? id_n) async {
    final response = await http
        .get(Uri.parse('${URL_SET_NOTIFICATION_CHECKED}$id_per/$id_n')); //
    if (response.statusCode == 200) {
      //   print("Succes");
    } else {
      //   print("Error");
    }
  }

}