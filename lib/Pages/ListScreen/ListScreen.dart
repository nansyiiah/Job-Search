import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job/Models/data.dart';
import 'package:job/Pages/ListScreen/DetailScreen.dart';
import 'package:job/constants.dart';
import 'package:http/http.dart' as http;

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final String url = "https://heroku-api-adrian.herokuapp.com/api/store/all";
  getJsonData() async {
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var jsonData = jsonDecode(response.body);
    List<Result> data = [];
    for (var u in jsonData["data"]) {
      Result datass = Result(
        id: u['id'],
        companyName: u['company_name'],
        gender: u['gender'],
        imageUrl: u['image_url'],
        koordinat: u['koordinat'],
        lokasi: u['lokasi'],
        pelamar: u['pelamar'],
        position: u['position'],
        salary: u['salary'],
      );
      data.add(datass);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("List Screen"),
        backgroundColor: kPrimaryColor,
      ),
      body: FutureBuilder(
        future: getJsonData(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            var data = (snapshot.data as List<Result>).toList();
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                              item: data[index].id!,
                              title: data[index].companyName!),
                        ),
                      );
                    },
                    child: Container(
                      height: 130,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryColor,
                            blurRadius: 0.2,
                            offset: Offset(0, 0.2),
                            spreadRadius: 0.1,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.all(20),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      data[index].imageUrl.toString()),
                                  radius: 40,
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 40),
                                    child: Text(data[index].pelamar.toString()),
                                  ),
                                  Container(
                                    child: Text(data[index].gender.toString()),
                                  ),
                                  Container(
                                    child:
                                        Text(data[index].position.toString()),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
