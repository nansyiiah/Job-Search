import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job/Models/JobsData.dart';
import 'package:job/Pages/DashboardScreen/components/Body.dart';
import 'package:job/Pages/DashboardScreen/components/BottomNavigationBar.dart';
import 'package:job/Pages/LoginScreen/LoginScreen.dart';
import 'package:job/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String name = '';
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString('user');
    if (user != null) {
      setState(() {
        name = user;
      });
    } else {
      setState(() {
        name = "null";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Flexible(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 20),
                  text: "Hello, $name",
                ),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                showAlertDialog(context);
              },
              child: CircleAvatar(
                child: Icon(Icons.logout, color: Colors.white),
                radius: 24,
                backgroundColor: kPrimaryColor,
              ),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: HomeBody(),
    );
  }
}

showAlertDialog(BuildContext context) {
  _logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    Get.to(LoginScreen());
  }

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("Logout"),
    onPressed: () {
      _logout();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Logout"),
    content: Text(
      "Are you sure want to log out ?",
      style: GoogleFonts.poppins(),
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
