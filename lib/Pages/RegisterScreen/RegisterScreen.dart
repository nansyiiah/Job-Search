import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job/Networks/api.dart';
import 'package:job/Pages/LoginScreen/LoginScreen.dart';
import 'package:job/constants.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _passwordVisible = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  _register() async {
    var data = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text
    };
    var res = await Network().auth(data, 'auth/register');
    var body = json.decode(res.body);
    if (body["message"] == "Registration Successfully") {
      Get.to(LoginScreen());
    } else {
      var snackBar = SnackBar(
        content: Text("Error email sudah terpakai / kolom ada yang kosong !"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 25, top: 100),
                child: Text(
                  "Register Account",
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  "Fill your details or continue \nwith social media",
                  style: GoogleFonts.poppins(
                    color: Color(0xFF6A6A6A),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "Fullname",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: "Email Address",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  obscureText: !_passwordVisible,
                  controller: passwordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Password",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: SizedBox(
                  height: 54,
                  width: size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      _register();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "SIGN UP",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Already Have Account?",
                      style: GoogleFonts.poppins(
                        color: Color(0xFF6A6A6A),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        " Log In",
                        style: GoogleFonts.poppins(
                          color: Color(0xFF1A1D1E),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(LoginScreen());
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
