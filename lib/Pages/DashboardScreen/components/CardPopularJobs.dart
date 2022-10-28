import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job/Models/JobsData.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:job/Networks/api.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:job/Pages/DashboardScreen/DashboardScreen.dart';
import 'package:job/Pages/DashboardScreen/components/BottomNavigationBar.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CardPopularJobs extends StatefulWidget {
  const CardPopularJobs({super.key});

  @override
  State<CardPopularJobs> createState() => _CardPopularJobsState();
}

class _CardPopularJobsState extends State<CardPopularJobs> {
  String? name = "adrian";
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool? isImage;
  bool? isPasang;
  bool? isLoading = true;
  String testingImage = '';

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        isPasang = true;
      });
      isImage = true;
    }
  }

  List gender = ["Male", "Female"];
  bool bottomIsChecked = false;
  bool bottomIsSwitched = false;
  int bottomRadioValue = 0;
  var locationLatitude = "";
  var genderSelected = "Male";
  var position = "";
  String companyName = '';
  String positionKerja = '';
  String location = '';
  String salary = '';
  var token = '';
  var data = {};
  XFile? futureImg;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String urlImage = '';
  bool? isProcessing = true;
  String latitudeLongitude = '';
  String locationLongitude = '';

  // List company = [PopularJobsData(companyName: )];
  String url = '';
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future uploadFile() async {
    print(_image!.path.split('/').last);
    final path = 'img/' + _image!.path.split('/').last;
    final file = File(_image!.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    setState(() {
      urlImage = urlDownload;
      isProcessing = false;
    });
    print("Upload Success");
  }

  _getCompanyData() async {
    data = {
      'company_name': companyName,
      'position': positionKerja,
      'salary': salary,
      'koordinat': latitudeLongitude,
      'lokasi': location,
      'gender': genderSelected,
      'image_url': urlImage,
      'pelamar': fullnameController.text,
    };
    var res = await Network().auth(data, 'store');
    var body = json.decode(res.body);
    if (body["message"] == "insert data successfully") {
      print("Success");
      const snackBar = SnackBar(
        content: Text("Success Insert Data !"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        Get.to(BottomNavBar());
      });
    } else {
      print(data);
    }
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      token = token;
    } else {
      token = "null";
    }
  }

  Future<String?> getCurrentLocation() async {
    await Geolocator.requestPermission();
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator.getLastKnownPosition();

    setState(() {
      locationLatitude = position.latitude.toString();
      locationLongitude = position.longitude.toString();
      latitudeLongitude =
          locationLatitude.toString() + "," + locationLongitude.toString();
    });
    return latitudeLongitude;
  }

  void _showModal() {
    Future<void> future = showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Form Pendaftaran",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    child: isImage == true
                        ? CircleAvatar(
                            backgroundImage: FileImage(File(_image!.path)),
                            radius: 30,
                          )
                        : CircleAvatar(
                            child: Center(child: Text("No Image")),
                            radius: 30,
                          ),
                    onTap: () async {
                      await _openImagePicker();
                      if (isPasang == true) {
                        await uploadFile();
                        if (isProcessing == false) {
                          state(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: fullnameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Nama",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_city),
                        labelText: "Alamat",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: "No HP",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Radio(
                        value: 0,
                        groupValue: bottomRadioValue,
                        onChanged: (value) {
                          state(() {
                            bottomRadioValue = value!;
                            genderSelected = gender[value];
                          });
                        },
                      ),
                      new Text(
                        'Male',
                      ),
                      new Radio(
                        value: 1,
                        groupValue: bottomRadioValue,
                        onChanged: (value) {
                          state(() {
                            bottomRadioValue = value!;
                            genderSelected = gender[value];
                          });
                        },
                      ),
                      new Text(
                        'Female',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Container(
                        child: Text("Lokasi Anda : "),
                      ),
                      Spacer(),
                      Container(
                        child: Text(latitudeLongitude.toString()),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.only(right: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            getCurrentLocation();
                            var posisi = await getCurrentLocation();
                            print(posisi);
                            state(() {
                              latitudeLongitude = posisi!;
                            });
                          },
                          child: Text("Get Lokasi !"),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: isLoading == false
                        ? () {
                            _getCompanyData();
                          }
                        : null,
                    child: Text("Submit !"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                companyName = items[index].companyName.toString();
                positionKerja = items[index].positionName.toString();
                location = items[index].location.toString();
                salary = items[index].salary.toString();
              });
              _showModal();
            },
            child: Container(
              height: 160,
              width: 260,
              margin: EdgeInsets.only(left: 30, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 0.2,
                    offset: Offset(0, 0.2),
                    spreadRadius: 0.1,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 40,
                            height: 40,
                            margin: EdgeInsets.only(top: 15, left: 20),
                            decoration: BoxDecoration(
                              color: Color(0xFFE4F2FF),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  child: Image.asset(
                                    items[index].iconUrl.toString(),
                                    width: 22.67,
                                    height: 22.67,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 15, right: 20),
                            child: Image.asset("assets/img/loveIcon.png"),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          items[index].companyName.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF6A6A6A),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          items[index].positionName.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF151313),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              items[index].salary.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF151313),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            child: Text(
                              items[index].location.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6A6A6A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
