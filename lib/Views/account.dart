import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:personnel_5chaumedia/Models/countdown.dart';
import 'package:personnel_5chaumedia/Models/datauser.dart';
import 'package:personnel_5chaumedia/Views/editpassword.dart';
import 'package:personnel_5chaumedia/Views/editprofile.dart';
import 'package:personnel_5chaumedia/Views/login.dart';
import 'package:personnel_5chaumedia/Views/loginnew.dart';
import 'package:personnel_5chaumedia/Presenters/networks.dart';
import '/Models/settings.dart';
import '/Widgets/itemaccount.dart';
import '/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  AudioPlayer player = AudioPlayer();
  String? id_per;
  bool check_color = false;
  int check_exist_Notification_visted = 0;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  @override
  Widget build(BuildContext context) {
    // double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Color(context.watch<Setting_Provider>().background_color()),
        body: ListView(
          padding: EdgeInsets.only(top: 35, bottom: 10, left: 10, right: 10),
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child: Container(
                    height: h * 0.2,
                    width: h * 0.2,
                    child: context.read<DataUser_Provider>().base64_img() !=
                                "Error" &&
                            context.read<DataUser_Provider>().base64_img() != ""
                        ? Image(
                            image: MemoryImage(base64Decode(context
                                .watch<DataUser_Provider>()
                                .base64_img())),
                            fit: BoxFit.cover,
                          )
                        : Image.asset("assets/icons/person.png",
                            fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "${context.watch<DataUser_Provider>().name_personnel()}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
),
                Text("Nhân viên chính thức")
              ],
            ),
            SizedBox(height: 20),
            ItemAccount_OK(
                icon: Icons.person_outline_outlined,
                onpressed: () {
                  context.read<DataUser_Provider>().set_base64_img_edit(
                      context.read<DataUser_Provider>().base64_img());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Edit_Profile_Screen()));
                },
                titile: "Chỉnh sửa thông tin"),
            ItemAccount_OK(
                icon: Ionicons.lock_closed_outline,
                onpressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Edit_Password_Screen()));
                },
                titile: "Đổi mật khẩu"),
            ItemAccount_OK(
                icon: Ionicons.help,
                onpressed: () async {
                  NetworkInfo networkInfo = NetworkInfo();
                  String? Mac = await networkInfo.getWifiBSSID();
                  CherryToast.info(title: Text("${Mac}")).show(context);
                  print("MAC: $Mac");
                },
                titile: "Show MAC WIFI"),
            ItemAccount_OK(
                icon: Ionicons.settings_outline,
                onpressed: () {
                  check_color = !check_color;
                  context
                      .read<Setting_Provider>()
                      .set_background_color(check_color);
                },
                titile: "Cài đặt"),
            ItemAccount_OK(
                icon: Icons.clear_sharp,
                onpressed: () async {
                  context.read<CountDown_Provider>().set_countdown(30);
                  bool check_click = false;
                  bool check_dele = false;
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Xóa tài khoản"),
                        content: Text("Bạn có muốn xóa tài khoản"),
                        actionsPadding: EdgeInsets.only(left: 30, right: 30),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        actions: [
                          context
                                      .watch<CountDown_Provider>()
                                      .check_countdown() ==
                                  false
                              ? Container(
                                  margin: EdgeInsets.only(left: 15),
                                  height: 20,
                                  width: 20,
                                  child: Text(
                                    "${context.watch<CountDown_Provider>().countdown()}",
style: TextStyle(color: Colors.red),
                                  ))
                              : TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    check_click = true;
                                  },
                                  child: Text("Xóa")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Quay lại"))
                        ],
                      );
                    },
                  );
                  if (check_click == true) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Xóa tài khoản"),
                          content: Text(
                              "Khi bạn xoá tài khoản bạn sẽ không thể khôi phục dữ liệu cũng như sử dụng tài khoản hiện tại để đăng nhập vào ứng dụng bạn sẽ được đưa về màn hình đăng nhập.Bạn có chắc chắn muốn xoá."),
                          actionsPadding: EdgeInsets.only(left: 30, right: 30),
                          actionsAlignment: MainAxisAlignment.spaceBetween,
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  check_dele = true;
                                },
                                child: Text("Đồng ý")),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Quay lại"))
                          ],
                        );
                      },
                    );

                    if (check_dele == true) {
                      if (await NetworkWork_Presenters().delete_User(context
                              .read<DataUser_Provider>()
                              .id_personnel()) ==
                          "Success") {
                        CherryToast.success(
                                title: Text("Xóa tài khoản thành công"))
                            .show(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login_Screen_new()));
                      } else {
                        CherryToast.error(title: Text("Xóa tài khoản thất bại"))
                            .show(context);
                      }
                    }
                  }
},
                titile: "Xóa tài khoản"),
            ItemAccount_OK(
                icon: Ionicons.arrow_back_circle_outline,
                onpressed: () async {
                  bool check = false;
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Thông báo'),
                      content: Text('Bạn có chắc muốn đăng xuất không?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            check = true;
                          },
                          child: Text('Có'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Đóng dialog
                          },
                          child: Text('Không'),
                        ),
                      ],
                    ),
                  );
                  if (check == true) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Container(
                            height: h * 0.3,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        );
                      },
                    );
                    logout(context);
                  }
                },
                titile: "Đăng xuất"),
          ],
        ),
      ),
    );
  }

  Future<void> _loadSaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id_per = prefs.getString('id_per');
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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  void playBeep() async {
    await player.play(AssetSource("sounds/tb.mp3"));
  }

  void playBeepWarning() async {
    await player.play(AssetSource("sounds/warning.mp3"));
  }
}