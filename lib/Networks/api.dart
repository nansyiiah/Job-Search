import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'https://heroku-api-adrian.herokuapp.com/api/';
  // 192.168.1.2 is my IP, change with your IP address
  var token = '';

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token')!;
  }

  auth(data, apiURL) async {
    var fullUrl = _url + apiURL;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  sendData(data, apiURL) async {
    var fullUrl = _url + apiURL;
    return await http.post(Uri.parse(fullUrl), body: jsonEncode(data));
  }

  getData(apiURL) async {
    var fullUrl = _url + apiURL;
    await _getToken();
    return await http.post(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
}
