import 'dart:io';
import 'package:path/path.dart';
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

  Future<dynamic> postData(Map<String, dynamic> map) async {
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
        return null;
      }
    } catch (err) {
      print("Exception: " + err.toString());
      return null;
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

  static Future sendFile(
      String filePath, String fileName, String requested_url) async {
//    try {
//      var request = http.MultipartRequest('POST', Uri.parse(requested_url));
////      request.files.add(http.MultipartFile('audioFile',
////          File(filePath).readAsBytes().asStream(), File(filePath).lengthSync(),
////          filename: filePath.split("/").last));
////      var res = await request.send();
//      request.files.add(http.MultipartFile.fromBytes(
//          'audioFile', await File(filePath).readAsBytes()));
//
//      var res = request.send().then((response) {
//        if (response.statusCode == 200) print("Uploaded!");
//
//        response.stream.transform(utf8.decoder).listen((value) {});
//      });
//
////      print("Image Response: ----> " + res.statusCode.toString());
//    } catch (err) {
//      print(err.toString());
//    }
//    print("Image Response: ----> " + res.statusCode.toString());

    var audioFile = File(filePath);
    var stream = http.ByteStream(audioFile.openRead());
    // get file length
    var length = await audioFile.length(); //audioFile is your image file
    Map<String, String> headers = {
      "Content-Type": "multipart/form-data"
    }; // ignore this headers if there is no authentication

    // string to uri
    var uri = Uri.parse(requested_url);

    // create multipart request
    var request = http.MultipartRequest("POST", uri);

    // multipart that takes file
//    var type = MediaType('audio', 'x-m4a');
    var multipartFileSign = http.MultipartFile(
      'audioFile',
      stream,
      length,
      filename: basename(audioFile.path),
    );

    // add file to multipart
    request.files.add(multipartFileSign);

//    //add headers
//    request.headers.addAll(headers);
//
//    //adding params
//    request.fields['loginId'] = '12';
//    request.fields['firstName'] = 'abc';
//    // request.fields['lastName'] = 'efg';

    // send
    var response = await request.send();

    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
}
