import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:personnel_5chaumedia/Models/datauser.dart';
import 'package:personnel_5chaumedia/Views/user/notification/notification_interface.dart';
import 'package:personnel_5chaumedia/Presenters/notification_presenter.dart';
import '/Models/notification.dart';
import '/Models/settings.dart';
import '/Widgets/TruncateText.dart';
import '/Widgets/appbar.dart';
import '/Widgets/showmodelbottomsheet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notification_Screen extends StatefulWidget {
  const Notification_Screen({super.key});

  @override
  State<Notification_Screen> createState() => _Notification_ScreenState();
}

class _Notification_ScreenState extends State<Notification_Screen>
    implements Notification_Interface {
  String? id_per;
  late Notification_Presenter _notification_presenter;

  _Notification_ScreenState() {
    _notification_presenter = new Notification_Presenter(this);
  }
  List<dynamic> data_checked = [];
  Future<void> load_save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id_per = prefs.getString('id_personnel');
  }
  List<dynamic> list_Notification = [];

  Future<void> fetch_data() async {
    _notification_presenter.get_Data();
    await load_save();
    data_checked = await _notification_presenter.fetch_Data_Notification_Checked(id_per);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    fetch_data();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      _notification_presenter.get_Data();
    });
  }

  bool check(int id) {
    bool res = false;
    data_checked.forEach((item) {
      if (item == id) {
        res = true;
      }
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          backgroundColor:
              Color(context.watch<Setting_Provider>().background_color()),
          appBar: CustomAppBar(context),
          body: list_Notification.length!=0 ?  ListView.builder(
            itemCount: list_Notification.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  _notification_presenter.see_Detail_Notification(list_Notification[index]);
                },
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.all(10),
                  height: h * 0.185,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color.fromARGB(255, 172, 163, 163))),
                    color: check(list_Notification[index]['id']) == false
                        ? Color.fromARGB(120, 206, 198, 198)
                        : Colors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: w * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TruncateText_Bold(
                                    "📢 ${list_Notification[index]['title']}",
                                    maxLength: 60,
                                    size: 15),
                                SizedBox(
                                  height: 5,
                                ),
                                TruncateText(
                                    "${list_Notification[index]['content']}.",
                                    maxLength: 130),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${DateFormat("H:m:s dd/MM/yy").format(DateTime.parse(list_Notification[index]['created_at']).add(Duration(hours: 7)))}",
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ): Center(child: CircularProgressIndicator(),)),
    );
  }

  String date_Format(DateTime dateTime) {
    String formattedDateTime = DateFormat("H:m:s dd/MM/YY").format(dateTime);
    return formattedDateTime;
  }

  @override
  void get_Notificatioon(data) {
    if (mounted) {
      setState(() {
        list_Notification = data;
      });
    }
  }

  @override
  Future<void> see_Detail_Notification(data) async {
    _notification_presenter.set_Data_Notification_Checked(id_per, data['id']);
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return CusstomshowModalBottomSheet(
          images: "assets/icons/logo.jpg",
          title: data['title'],
          content: data['content'],
          time: DateFormat("H:m:s dd/MM/yy").format(
              DateTime.parse(data['created_at']).add(Duration(hours: 7))),
        );
      },
    );
    context.read<Notification_Provider>().set_count_notification_not_checked(
        context.read<DataUser_Provider>().id_personnel().toString());
    await fetch_data();
    if (mounted) {
      setState(() {});
    }
  }
}
