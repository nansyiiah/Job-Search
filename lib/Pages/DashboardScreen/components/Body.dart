import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job/Pages/DashboardScreen/components/CardPopularJobs.dart';
import 'package:job/Pages/DashboardScreen/components/CardRecentPost.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          padding: EdgeInsets.only(left: 30),
          child: Text(
            "Popular Job",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        CardPopularJobs(),
        SizedBox(
          height: 30,
        ),
        Container(
          padding: EdgeInsets.only(left: 30),
          child: Text(
            "Recent Post",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        CardRecentPost(),
      ],
    );
  }
}
