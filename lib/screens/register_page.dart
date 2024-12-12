import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thewallsocials/services/auth_services.dart';
import '../components/mybutton.dart';
import '../components/mytextfield.dart';

class RegisterPage extends StatefulWidget {
  void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> register() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Passwordds do not match")));
      return;
    }

    try {
      await Provider.of<AuthService>(context, listen: false)
          .registerUser(emailController.text, passwordController.text);
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
                      height: 10,
                    ),

                    //confirm password textfield
                    MyTextField(
                        hintText: "Confirm Password",
                        controller: confirmPasswordController,
                        obscureText: true),

                    const SizedBox(
                      height: 25,
                    ),

                    //sign in button
                    MyButton(text: "Sign Up", onTap: register),

                    const SizedBox(
                      height: 25,
                    ),

                    //go to register page
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //dont have an account
                        Text("Already have an account? "),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            "Login now",
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
