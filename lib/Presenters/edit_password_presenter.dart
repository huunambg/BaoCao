import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:personnel_5chaumedia/Models/datauser.dart';
import 'package:personnel_5chaumedia/Services/network_request.dart';
import 'package:personnel_5chaumedia/Sounds/sound.dart';
import 'package:personnel_5chaumedia/Views/user/edit_password/edit_password_interface.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Edit_Password_Presenter {
  late Edit_Password_Interface _edit_password_presenter;

  Edit_Password_Presenter(Edit_Password_Interface edit_password_presenter) {
    this._edit_password_presenter = edit_password_presenter;
  }
  Future<void> update_Password(BuildContext context, double h, String old_pass,
      String new_pass, String re_new_pass) async {
    bool check = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Đổi mật khẩu"),
          content: Text("Bạn có muốn đổi mật khẩu mới"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: h * 0.3,
            child: Center(
              child: Lottie.asset("assets/lottie/loading.json"),
            ),
          ),
        );
      },
    );
    if (check == true) {
      if (old_pass == "" || new_pass == "" || re_new_pass == "") {
        Navigator.pop(context);
        Sound().playBeepError();
        CherryToast.warning(title: Text("Vui lòng kiểm tra dữ liệu"))
            .show(context);
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? old_pass = await prefs.getString('password');
        Navigator.pop(context);
        if (old_pass == old_pass) {
          if (new_pass == re_new_pass) {
            String? massage = await NetworkRequest().edit_ProfileS(
                context.read<DataUser_Provider>().id_per(),
                context.read<DataUser_Provider>().name_personnel(),
                context.read<DataUser_Provider>().email(),
                context.read<DataUser_Provider>().phone(),
                new_pass);

            if (massage != "Error") {
              _edit_password_presenter
                  .edit_Password_Success("Cập nhật mật khẩu thành công");
              prefs.setString('password', new_pass);
            } else {
              _edit_password_presenter
                  .edit_Password_Error("Cập nhật mật khẩu thất bại");
            }
          } else {
            _edit_password_presenter
                .edit_Password_Error("Nhập lại mật khẩu không khớp");
          }
        } else {
          _edit_password_presenter
              .edit_Password_Error("Mật khẩu cũ không đúng");
        }
      }
      check = false;
    } else {
      Navigator.pop(context);
    }
  }
}
