import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:training_partner/core/resources/open_ai/gpt_message.dart';

class GptService {
  Future<GptMessage> getGptResponse(List<GptMessage> messages) async {
    var url = Uri.parse('https://chat-gpt26.p.rapidapi.com');

    var headers = {
      'Content-Type': 'application/json',
      'X-Rapidapi-Key': '4fc7dca7abmsh066fe84045dcbfbp191d59jsncca4e043c3cd',
      'X-Rapidapi-Host': 'chat-gpt26.p.rapidapi.com'
    };

    var body = json.encode({"model": "gpt-3.5-turbo", "messages": messages});

    var response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return GptMessage.fromJson(jsonDecode(response.body)['choices'][0]['message']);
    } else {
      throw 'HTTP status code: ${response.statusCode}\nBody: ${response.body}';
    }
  }
}
