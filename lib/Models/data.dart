// To parse this JSON data, do
//
//     final dataMovie = dataMovieFromJson(jsonString);

import 'dart:convert';

class Datas {
  final int id;
  final String companyName;
  final String position;
  final String salary;
  final String koordinat;
  final String lokasi;
  final String gender;
  final String imageUrl;
  final String pelamar;
  Datas(
    this.id,
    this.companyName,
    this.position,
    this.salary,
    this.koordinat,
    this.lokasi,
    this.gender,
    this.imageUrl,
    this.pelamar,
  );
}

class DataMovie {
  int? message;
  List<Result>? datas;

  DataMovie({this.message, this.datas});

  DataMovie.fromJson(Map<String, dynamic> json) {
    message = json['page'];
    if (json['data'] != null) {
      datas = <Result>[];
      json['results'].forEach((v) {
        datas!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.datas != null) {
      data['data'] = this.datas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  Result({
    this.id,
    this.companyName,
    this.position,
    this.salary,
    this.koordinat,
    this.lokasi,
    this.gender,
    this.imageUrl,
    this.pelamar,
  });

  final int? id;
  final String? companyName;
  final String? position;
  final String? salary;
  final String? koordinat;
  final String? lokasi;
  final String? gender;
  final String? imageUrl;
  final String? pelamar;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        companyName: json["company_name"],
        position: json["position"],
        salary: json["salary"],
        koordinat: json["koordinat"],
        lokasi: json["lokasi"],
        gender: json["gender"],
        imageUrl: json["image_url"],
        pelamar: json["pelamar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "position": position,
        "salary": salary,
        "koordinat": koordinat,
        "lokasi": lokasi,
        "gender": gender,
        "image_url": imageUrl,
        "pelamar": pelamar,
      };
}
