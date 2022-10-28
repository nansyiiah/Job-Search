import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job/Pages/DashboardScreen/DashboardScreen.dart';
import 'package:job/Pages/DashboardScreen/components/BottomNavigationBar.dart';
import 'package:job/Pages/LoginScreen/LoginScreen.dart';
import 'package:job/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool isAuth = false;
  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      if (mounted) {
        setState(() {
          isAuth = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, right: 35),
              child: Image.asset(
                "assets/img/landingIcon.png",
              ),
            ),
            SizedBox(
              height: 62,
            ),
            Container(
              child: Text(
                "Find a Perfect\n Job Match",
                style: GoogleFonts.poppins(
                    fontSize: 34, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.only(
                left: 35,
                right: 35,
              ),
              child: Text(
                "Finding your dream job is more easire and faster with JobHub",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6A6A6A),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 54,
              width: 251,
              child: ElevatedButton(
                onPressed: () {
                  if (isAuth) {
                    Get.to(BottomNavBar());
                  } else {
                    Get.to(LoginScreen());
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Let's Get Started",
                      style: GoogleFonts.poppins(),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
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
            )
          ],
        ),
      ),
    );
  }
}
