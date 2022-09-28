import 'dart:convert' as convert;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:voice_chat_app/config/agora_config.dart';
import 'package:voice_chat_app/models/login_request_model.dart';
import 'package:voice_chat_app/models/login_response_model.dart';

final apiService = Provider((ref) => APIService());

class APIService {
  static var client = http.Client();

  Future<String> getRtcToken(String channel, int uid) async {
    var url =
        Uri.parse('${AgoraConfig.apiURL}/rtc/$channel/publisher/uid/$uid');
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse['rtcToken'];
    }
    return '';
  }

  static Future<bool> loginGetToken(
    LoginRequestModel model,
  ) async {
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
    };

    var url = Uri.parse('${AgoraConfig.apiURL}/login');

    var response = await client.post(
      url,
      headers: requestHeader,
      body: convert.jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200) {
      loginResponseModel(response.body);
      return true;
    } else {
      return false;
    }
  }
}
