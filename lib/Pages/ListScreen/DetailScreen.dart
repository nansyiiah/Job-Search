import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job/Models/data.dart';
import 'dart:convert';
import 'package:job/Networks/api.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:job/Pages/DashboardScreen/components/BottomNavigationBar.dart';
import 'package:job/Pages/ListScreen/ListScreen.dart';
import 'package:get/get.dart';
import '../../constants.dart';

class DetailScreen extends StatefulWidget {
  final int item;
  final String title;
  const DetailScreen({Key? key, required this.item, required this.title})
      : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<List<Result>> result;
  String nama = '';
  TextEditingController fullnameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  String urlImage = '';
  File? _image;
  bool? isImage;
  UploadTask? uploadTask;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    result = fetchData(widget.item);
    isImage = false;
  }

  Future<List<Result>> fetchData(id) async {
    var response = await http.get(
        Uri.parse("https://heroku-api-adrian.herokuapp.com/api/store/${id}"),
        headers: {"Accept": "application/json"});
    var jsonData = jsonDecode(response.body);
    List<Result> data = [];
    Result datass = Result(
      companyName: jsonData["data"]["company_name"],
      id: jsonData["data"]["id"],
      gender: jsonData["data"]["gender"],
      imageUrl: jsonData["data"]["image_url"],
      koordinat: jsonData["data"]["koordinat"],
      lokasi: jsonData["data"]["lokasi"],
      pelamar: jsonData["data"]["pelamar"],
      position: jsonData["data"]["position"],
      salary: jsonData["data"]["salary"],
    );
    data.add(datass);
    return data;
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
    });
  }

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      isImage = true;
      uploadFile();
    }
  }

  showAlert() {
    AlertDialog alert = AlertDialog(
      title: Text("Delete data"),
      content: Container(
        child: Text("Are you sure want to delete data ?"),
      ),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Ok'),
          onPressed: () {
            deleteData(widget.item);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (context) => alert);
    return;
  }

  deleteData(id) async {
    var response = await http.delete(
      Uri.parse("https://heroku-api-adrian.herokuapp.com/api/store/${id}"),
    );
    print("Success Delete Data !");
    Get.to(BottomNavBar());
  }

  changeData(id) async {
    var data = {
      'pelamar': fullnameController.text,
      'image_url': urlImage,
      'gender': genderController.text,
    };
    var res = await Network().auth(data, 'store/${id}');
    var body = json.decode(res.body);
    print(body);
    if (body["code"] == 200) {
      const snackBar = SnackBar(
        content: Text("Success"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Get.to(BottomNavBar());
    } else {
      const snackBar = SnackBar(
        content: Text("data ada yang kosong !"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Data",
          style: GoogleFonts.poppins(fontSize: 20),
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                showAlert();
              },
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
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
              padding: EdgeInsets.only(top: 50),
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  urlImage = data[index].imageUrl.toString();
                  fullnameController.text = data[index].pelamar.toString();
                  genderController.text = data[index].gender.toString();
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
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
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(20),
                                child: InkWell(
                                  child: isImage == false
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            data[index].imageUrl.toString(),
                                          ),
                                          radius: 60,
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                              FileImage(File(_image!.path)),
                                          radius: 60,
                                        ),
                                  onTap: () async {
                                    await _openImagePicker();
                                  },
                                ),
                              ),
                              Container(
                                child: Text(
                                  data[index].pelamar.toString(),
                                  style: GoogleFonts.poppins(fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: "Full Name",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  controller: fullnameController,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: "Gender",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  controller: genderController,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  changeData(widget.item);
                                },
                                child: Text("Edit Data !"),
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
        },
        future: result,
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("Delete !"),
    onPressed: () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete data"),
    content: Text(
      "Are you sure want to delete data ?",
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
