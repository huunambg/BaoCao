import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:personnel_5chaumedia/Models/datauser.dart';
import 'package:personnel_5chaumedia/Services/network_request.dart';
import 'package:personnel_5chaumedia/Sounds/sound.dart';
import 'package:personnel_5chaumedia/Views/user/edit_profile/edit_profile_interface.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Edit_Profile_Presenter {
  late Edit_Profile_Interface _edit_profile_interface;

  Edit_Profile_Presenter(Edit_Profile_Interface edit_profile_interface) {
    this._edit_profile_interface = edit_profile_interface;
  }

  Future<void> update_avatar(BuildContext context, String base64String) async {
    bool check = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ảnh đại diện"),
          content: Text("Bạn có muốn cập nhật ảnh đại diện"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<DataUser_Provider>().set_base64_img_edit(
                      context.read<DataUser_Provider>().base64_img());
                },
                child: Text("Hủy")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  check = true;
                },
                child: Text("Xác nhận"))
          ],
        );
      },
    );
    if (check == true) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Center(
                child: Lottie.asset("assets/lottie/loading.json"),
              ),
            ),
          );
        },
      );

      if (base64String == "") {
        Navigator.pop(context);
        _edit_profile_interface.update_Profile_Error("Vui lòng chọn ảnh mới");
      } else {
        String massaging = await NetworkRequest()
            .edit_img(context.read<DataUser_Provider>().id_per(), base64String);
        Navigator.pop(context);
        if (massaging != "Error") {
          _edit_profile_interface
              .update_Profile_Succes("Cập nhật ảnh đại diện thành công");
          context.read<DataUser_Provider>().set_base64_img(base64String);
        } else {
          _edit_profile_interface.update_Profile_Error("Cập nhật ảnh thất bại");
        }
        check = false;
      }
    }
  }

  Future<void> update_Profile(
      BuildContext context, String name, String email, String phone) async {
    if (phone != "" &&
        int.tryParse(phone) != null &&
        email != "" &&
        name != "") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? pass = await prefs.getString('password');
      String? massage = await NetworkRequest().edit_ProfileS(
          context.read<DataUser_Provider>().id_per(), name, email, phone, pass);
      Navigator.pop(context);
      if (massage != "Error") {
        _edit_profile_interface
            .update_Profile_Succes("Cập nhật dữ liệu thành công");
        await prefs.setString('user_name', name);
        await prefs.setString('email', email);
        await prefs.setString('phone', phone);
        context.read<DataUser_Provider>().set_id_name_personnel();
      } else {
        _edit_profile_interface
            .update_Profile_Error("Cập nhật dữ liệu thất bại");
      }
    }
  }
}
