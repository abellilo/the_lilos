import 'package:flutter/material.dart';
import 'package:thewallsocials/screens/login_page.dart';
import 'package:thewallsocials/screens/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLogin = true;

  void tooglePage(){
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLogin){
      return LoginPage(onTap: tooglePage,);
    }
    else{
      return RegisterPage(onTap: tooglePage,);
    }
  }
}
