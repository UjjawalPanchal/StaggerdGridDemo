/*
* Created by Ujjawal Panchal on 11/11/22.
*/
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practice/api_helper/api_call.dart';
import 'package:practice/model/image_response_pojo.dart';
import 'package:practice/utils/utility.dart';

class CommonServiceCall {
  static Future<dynamic> getImagesBySize(String size) async {
    final http.Response response = await ApiCalls.get(
      baseUrl + size,
      <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 201 || response.statusCode == 200 || response.statusCode == 400) {
      Utility.printLog(json.decode(response.body));
      ImageResponsePojo images = ImageResponsePojo.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      if (images.status != 0 && images.data != null && images.data!.isNotEmpty) {
        return images.data;
      }
    }
    return [];
  }
}
