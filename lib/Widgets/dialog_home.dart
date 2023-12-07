import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Dialog_Home{

void show_Dialog_Loading_Rollcall(BuildContext context){
        showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Lottie.asset("assets/lottie/loadingrollcall.json"),
          );
        },
      );
}


void checking_dialog(BuildContext context, double h ,bool check) {
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
  void error_distance_dialog(BuildContext context, double h) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: h * 0.4,
            child: Column(
              children: [
                Lottie.asset("assets/lottie/sad.json"),
                Text("Bạn không ở vị trí của công ty",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Thoát'),
            ),
          ],
        );
      },
    );
  }

   void error_wifi_dialog(BuildContext context, double h) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: h * 0.4,
            child: Column(
              children: [
                Lottie.asset("assets/lottie/wifierror.json"),
                Text("Wifi không hợp lệ!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Thoát'),
            ),
          ],
        );
      },
    );
  }

  void error_wifi_distance_dialog(BuildContext context, double h) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: h * 0.4,
            child: Column(
              children: [
                Lottie.asset("assets/lottie/sad.json"),
                Text("Vị trí và wifi của bạn không hợp lệ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Thoát'),
            ),
          ],
        );
      },
    );
  }
}