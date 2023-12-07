import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:location/location.dart';
import 'package:personnel_5chaumedia/Presenters/home_presenter.dart';
import 'package:personnel_5chaumedia/Services/network_request.dart';
import 'package:personnel_5chaumedia/Sounds/sound.dart';
import 'package:personnel_5chaumedia/Views/user/home/home_interface.dart';
import 'package:simple_barcode_scanner/enum.dart';
import '/Models/detailrollcall.dart';
import '/Models/location.dart';
import '/Models/settings.dart';
import '/Models/wifi.dart';
import '/Widgets/appbar.dart';
import '/Widgets/buttonrollcall.dart';
import '/Widgets/detailhome.dart';
import '/Widgets/todayrollcall.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});
  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> implements Home_Interface {
  String? id_per;
  @override
  void dispose() {
    super.dispose();
  }

  NetworkRequest _rollcall_presenter = new NetworkRequest();
  var data;
  int? working_day;
  int? total_working_day;
  int? leave_permission;
  int? leave_without_permission;
  int? time;
  Location location = Location();

  late Home_Presenter _home_presenter;

  _HomePageUserState() {
    _home_presenter = new Home_Presenter(this);
  }
  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    get_data_current_day();
    _home_presenter.show_Statistical_By_Month();
  }

  Future<void> checkLocationPermission() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {}
    }
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {}
    }
  }

  Future<void> get_data_current_day() async {
    context.read<Wifi_Provider>().setname(null);
    context.read<Location_Provider>().set__curren_address();
    await context.read<DetailRollCallUser_Provider>().set_Data_Day_OneDay();
    context.read<DetailRollCallUser_Provider>().set_break_time_rollcall();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Color(context.watch<Setting_Provider>().background_color()),
        appBar: CustomAppBar(context),
        body: data != null
            ? ListView(
                children: [
                  CustomItemTodayRollCall(),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "5 Châu Media ",
                          style: TextStyle(color: Colors.blue, fontSize: 16)),
                      TextSpan(
                          text:
                              "chúc bạn 1 ngày làm việc vui vẻ mời bạn chấm công bằng khuôn mặt hoặc QR")
                    ])),
                  ),
                  CustomButtonRollcall(
                    ontapface: () async {
                      CherryToast.warning(title: Text("Đang update!"))
                          .show(context);
                      Sound().playBeepWarning();
                    },
                    ontapqr: () async {
                      _home_presenter.scan_QR(
                          context, mounted, MediaQuery.of(context).size.height);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomDetailHome(
                      title: "Vị trí hiện tại:",
                      content:
                          context.watch<Location_Provider>().current_address(),
                      icon: Icons.place_outlined),
                  CustomDetailHome(
                      title: "Mạng hiện tại:",
                      content: context.watch<Wifi_Provider>().getname(),
                      icon: Ionicons.git_network_outline),
                  CustomDetailHome(
                      title: "Tổng số ngày đi làm:",
                      content:
                          total_working_day != null && total_working_day != 0
                              ? "${total_working_day}"
                              : "Chưa đi làm",
                      icon: Icons.check_box_outlined),
                  CustomDetailHome(
                      title: "Tổng số ngày nghỉ có phép:",
                      content: leave_permission != null
                          ? "$leave_permission"
                          : "Chưa đi làm",
                      icon: Icons.warning_amber_rounded),
                  CustomDetailHome(
                      title: "Tổng số ngày nghỉ không phép:",
                      content: leave_without_permission != null
                          ? "$leave_without_permission"
                          : "Chưa đi làm",
                      icon: Icons.warning_amber_rounded),
                  CustomDetailHome(
                      title: "Tổng số phút làm:",
                      content: time != null ? "$time" : "Chưa đi làm",
                      icon: Icons.list_alt_rounded),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  @override
  void rollcall_Error(String message) {
    CherryToast.error(title: Text("$message")).show(context);
    Sound().playBeepError();
  }

  @override
  void rollcall_Success(String message) {
    CherryToast.success(title: Text("$message")).show(context);
    Sound().playBeepSucces();
  }

  @override
  Future<void> scan_QR() async {
    var scanResult = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(
              scanType: ScanType.qr, cancelButtonText: "Thoát"),
        ));
    if (!mounted) return;
    _home_presenter.check_Res_QR_Rollcall(context, scanResult);
  }

  @override
  void show_Statistical_By_Month(res) 
  {
    data = res;
    if (data != null && data != "Error") {
      working_day = data['working_day'];
      total_working_day = data['total_working_day'];
      leave_permission = data['leave_permission'];
      time = data['total_working_time'];
      leave_without_permission = data['leave_without_permission'];
    } 
    if (mounted) {
      setState(() {});
    }
  }
}
