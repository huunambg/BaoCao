import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:personnel_5chaumedia/Models/datauser.dart';
import 'package:personnel_5chaumedia/Presenters/edit_password_presenter.dart';
import 'package:personnel_5chaumedia/Services/network_request.dart';
import 'package:personnel_5chaumedia/Sounds/sound.dart';
import 'package:personnel_5chaumedia/Const/rourte_api.dart';
import 'package:personnel_5chaumedia/Views/user/edit_password/edit_password_interface.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Edit_Password_Screen extends StatefulWidget {
  const Edit_Password_Screen({super.key});

  @override
  State<Edit_Password_Screen> createState() => _Edit_Password_ScreenState();
}

class _Edit_Password_ScreenState extends State<Edit_Password_Screen> implements Edit_Password_Interface {

  late Edit_Password_Presenter _edit_password_presenter;

_Edit_Password_ScreenState(){
  _edit_password_presenter = new Edit_Password_Presenter(this);
}

  bool check_old_pass = true;
  bool check_new_pass = true;
  bool check_renew_pass = true;
  final old_pass_controller = TextEditingController();
  final new_pass_controller = TextEditingController();
  final renew_pass_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7F67BE),
        title: Text("Đổi mật khẩu"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
                controller: old_pass_controller,
                obscureText: check_old_pass,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            check_old_pass = !check_old_pass;
                          });
                        },
                        icon: Icon(check_old_pass
                            ? Icons.visibility
                            : Icons.visibility_off)),
                    labelText: "Nhập mật khẩu cũ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)))),
            SizedBox(
              height: 10,
            ),
            TextField(
                obscureText: check_new_pass,
                controller: new_pass_controller,
                decoration: InputDecoration(
                  labelText: "Nhập mật khẩu mới",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          check_new_pass = !check_new_pass;
                        });
                      },
                      icon: Icon(check_new_pass
                          ? Icons.visibility
                          : Icons.visibility_off)),
                )),
            SizedBox(
              height: 10,
            ),
            TextField(
                obscureText: check_renew_pass,
                controller: renew_pass_controller,
                decoration: InputDecoration(
                  labelText: "Nhập lại mật khẩu mới",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          check_renew_pass = !check_renew_pass;
                        });
                      },
                      icon: Icon(check_renew_pass
                          ? Icons.visibility
                          : Icons.visibility_off)),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: btlogin_color,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                onPressed: () async {
              _edit_password_presenter.update_Password(context, h, old_pass_controller.text, new_pass_controller.text, renew_pass_controller.text);
                },
                child: const Text(
                  'Cập nhật',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 
  @override
  void edit_Password_Error(String message) {
    Sound().playBeepError();
    CherryToast.error(title: Text("$message")).show(context);
  }
 
  @override
  void edit_Password_Success(String message) {
    Sound().playBeepWarning();
    CherryToast.success(title: Text("$message")).show(context);
    setState(() {
      old_pass_controller.text="";
      new_pass_controller.text="";
      renew_pass_controller.text="";
    });
  }


}
