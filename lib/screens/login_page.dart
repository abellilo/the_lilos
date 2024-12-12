import 'package:flutter/material.dart';
import 'package:thewallsocials/components/mybutton.dart';
import 'package:thewallsocials/components/mytextfield.dart';
import 'package:provider/provider.dart';
import 'package:thewallsocials/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signIn() async {
    try {
      await Provider.of<AuthService>(context, listen: false)
          .signIn(emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),

                    //logo
                    const Icon(
                      Icons.lock,
                      size: 100,
                    ),

                    const SizedBox(
                      height: 50,
                    ),

                    //welcome back
                    const Text("Welcome back, you've been missed!"),

                    const SizedBox(
                      height: 25,
                    ),

                    //email textfield
                    MyTextField(
                        hintText: "Email",
                        controller: emailController,
                        obscureText: false),

                    const SizedBox(
                      height: 10,
                    ),

                    //password textfield
                    MyTextField(
                        hintText: "Password",
                        controller: passwordController,
                        obscureText: true),

                    const SizedBox(
                      height: 25,
                    ),

                    //sign in button
                    MyButton(text: "Sign In", onTap: signIn),

                    const SizedBox(
                      height: 25,
                    ),

                    //go to register page
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //dont have an account
                        Text("Don't have an account? "),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            "Register now",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
