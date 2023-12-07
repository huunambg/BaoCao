import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:personnel_5chaumedia/Models/datauser.dart';
import 'package:personnel_5chaumedia/Models/detailrollcall.dart';
import 'package:personnel_5chaumedia/Models/location.dart';
import 'package:personnel_5chaumedia/Services/network_request.dart';
import 'package:personnel_5chaumedia/Sounds/sound.dart';
import 'package:personnel_5chaumedia/Views/user/home/home_interface.dart';
import 'package:personnel_5chaumedia/Widgets/dialog_home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home_Presenter {
  late Home_Interface _home_interface;
  String? id_per;
  String? current_address, Text_QR;
  int distance = 0;
  int meter = 0;
  String? get_MAC_WIFI;
  bool mac_check = false;
  String? rollcall_time;
  int timecheck = 5;
  int time_delay = 0;
  bool check = true;
  var data;
  int? working_day;
  int? total_working_day;
  int? leave_permission;
  int? leave_without_permission;
  int? time;
  Location location = Location();

  NetworkRequest _networkRequest = new NetworkRequest();
  Home_Presenter(Home_Interface home_interface) {
    this._home_interface = home_interface;
  }


Future<void> show_Statistical_By_Month() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    id_per = prefs.getString('id_per');
    data = await _networkRequest.Statistical_By_Month(id_per);
    _home_interface.show_Statistical_By_Month(data);

}

  Future<void> scan_QR(BuildContext context, var mounted,double h) async {
    if (context.read<DetailRollCallUser_Provider>().Data_Day_One_Day()[0]
            ['out2'] !=
        null) {
      CherryToast.warning(title: Text("Bạn đã điểm danh hôm nay"))
          .show(context);
      Sound().playBeepWarning();
    } else {
      checking_dialog(context,h);
      await getcalculateDistance();
      await checkmac();
      if (check) {
        if (mounted != false) Navigator.pop(context);
        if (distance <= meter && mac_check == true) {
          _home_interface.scan_QR();
        } else if (mac_check == true && distance > meter) {
         Dialog_Home().error_distance_dialog(context,h);
        } else if (mac_check == false && distance <= meter) {
         Dialog_Home().error_wifi_dialog(context,h);
        } else if (mac_check == false && distance > meter) {
         Dialog_Home().error_wifi_distance_dialog(context,h);
        }
      }
      check = true;
    }
  }

  Future<void> check_Res_QR_Rollcall(
      BuildContext context, var scanResult) async {
    print("QR res :$scanResult");
    if (scanResult == Text_QR && mac_check == true) {
      Dialog_Home().show_Dialog_Loading_Rollcall(context);
      int time_delay = await get_caculator_time_rollcall(context);
      print("Time delay $time_delay");
      if (time_delay <= 0) {
        if (context.read<Location_Provider>().current_address().toString() !=
            "Chưa tìm thấy.") {
          String res = await _networkRequest.rollcall_personnel(
              id_per, context.read<Location_Provider>().current_address());
          Navigator.pop(context);
          if (res == "Successful Attendance") {
            _home_interface.rollcall_Success("Chấm công thành công");
            context.read<DetailRollCallUser_Provider>().set_Data_Day_OneDay();
          } else {
            _home_interface
                .rollcall_Error("Bạn đã hoàn thành chấm công hôm nay");
          }
        } else {
          Navigator.pop(context);
          _home_interface.rollcall_Error("Chưa tìm được vị trí của bạn");
        }
      } else if (time_delay > 0) {
        Navigator.pop(context);
        _home_interface
            .rollcall_Error("Bạn phải chờ $time_delay phút để chấm công");
      }
    } else if (scanResult != Text_QR &&
        scanResult != "-1" &&
        mac_check == true) {
      _home_interface.rollcall_Error("Mã QR không hợp lệ !");
    }
  }


  Future<double> _calculateDistance() async {
    var data3 = await _networkRequest.getLocation();
    //print(data3);
    meter = data3['meter'];
    double fixedLatitude = double.parse(data3['latitude']); // kinh độ
    double fixedLongitude = double.parse(data3['longitude']); // vĩ độ
    Position currentPosition = await Geolocator.getCurrentPosition();
    double distance = await Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      fixedLatitude,
      fixedLongitude,
    );

    print("lat${currentPosition.latitude}  long ${currentPosition.longitude}");
    return distance;
  }

  Future<void> getcalculateDistance() async {
    double _distance = await _calculateDistance();
    distance = _distance.round();
    print("Distance : $distance");
    Text_QR = await _networkRequest.get_Text_QR_Rollcall();
  }

  Future<void> checkmac() async {
    mac_check = false;
    NetworkInfo networkInfo = NetworkInfo();
    get_MAC_WIFI = await networkInfo.getWifiBSSID();
    List<String> macParts = get_MAC_WIFI!.split(":");
    List<String> formattedMacParts = [];
    for (String part in macParts) {
      if (part.length == 1) {
        formattedMacParts.add("0$part");
      } else {
        formattedMacParts.add(part);
      }
    }
    String formattedMacAddress = formattedMacParts.join(":");
    //  print("GET MAC WIFI : ${formattedMacAddress}");
    List<dynamic> mac = await NetworkRequest().get_MAC_WIFI();
    mac.forEach((element) {
      if (formattedMacAddress == element['address']) {
        mac_check = true;
      }
      //print("${element['address']}");
    });
  }

  Future<int> get_caculator_time_rollcall(BuildContext context) async {
    String last_rollcall = await NetworkRequest()
        .get_last_rollcall(context.read<DataUser_Provider>().id_personnel());
    print("Last rollcall: $last_rollcall");
    Duration difference =
        DateTime.now().difference(DateTime.parse(last_rollcall));
    print("Caculator last time: ${difference.inMinutes}");
    int time_calc = difference.inMinutes;
    int time_delay =
        context.read<DetailRollCallUser_Provider>().break_time_rollcall() -
            time_calc;
    return time_delay;
  }

  void checking_dialog(BuildContext context, double h) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Stack(
            children: [
              Container(
                  height: h * 0.4,
                  child: Column(
                    children: [
                      Lottie.asset("assets/lottie/checkinglocation.json"),
                      Text("Đang kiểm tra vị trí và Wifi của bạn.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15))
                    ],
                  )),
              Positioned(
                bottom: 0,
                right: 0,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    check = false;
                  },
                  child: Text("Thoát"),
                ),
              )
            ],
          ),
        );
      },
    );
  }



 
}
