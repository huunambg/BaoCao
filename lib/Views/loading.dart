import 'package:flutter/material.dart';
import 'package:personnel_5chaumedia/Presenters/login_presenter.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
      Login_Presenter login_presenter = new Login_Presenter();

  @override
  void initState() {
    super.initState();
  login_presenter.load_login(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
