import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String url;

  NetworkHelper(this.url);

  Future getData() async {
    http.Response response = await http.get(this.url);
    try {
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        print(response.statusCode);
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future postData(Map<String, dynamic> map) async {
    final http.Response response = await http.post(
      this.url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(map),
    );
    try {
      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(response.statusCode);
      }
    } catch (err) {
      print("Exception: " + err.toString());
    }
  }

  Future putData(Map<String, dynamic> map) async {
    final http.Response response = await http.put(
      this.url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(map),
    );
    try {
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(response.statusCode);
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future deleteData() async {
    final http.Response response =
        await http.delete(this.url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    try {
      if (response.statusCode == 200) {
//      return jsonDecode(response.body);
        print(response.body);
      } else {
        print(response.statusCode);
      }
    } catch (err) {
      print(err.toString());
    }
  }
}
