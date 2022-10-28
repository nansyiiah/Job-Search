import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job/Networks/api.dart';
import 'package:job/Pages/DashboardScreen/DashboardScreen.dart';
import 'package:job/Pages/DashboardScreen/components/BottomNavigationBar.dart';
import 'package:job/Pages/RegisterScreen/RegisterScreen.dart';
import 'package:job/constants.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _passwordVisible = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  _login() async {
    var data = {
      'email': emailController.text,
      'password': passwordController.text,
    };
    var res = await Network().auth(data, 'auth/login');
    var body = json.decode(res.body);
    // print(body);
    if (body["message"] == "Success") {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body["token"]);
      localStorage.setString('user', body["data"]);
      Get.to(BottomNavBar());
    } else {
      const snackBar = SnackBar(
        content: Text("Email / Password Salah !"),
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
                padding: EdgeInsets.only(left: 30, top: 150),
                child: Text(
                  "Welcome Back!",
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
                height: 30,
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
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                child: InkWell(
                  onTap: () {
                    print("you tapped");
                  },
                  child: Text(
                    "Forget Password ?",
                    style: GoogleFonts.poppins(
                        color: Color(0xFF6A6A6A), fontSize: 12),
                  ),
                ),
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
                      _login();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "LOG IN",
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
                      "New User ?",
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
                        " Create Account",
                        style: GoogleFonts.poppins(
                          color: Color(0xFF1A1D1E),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(RegisterScreen());
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
