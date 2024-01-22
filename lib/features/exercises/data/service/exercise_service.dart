import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:training_partner/features/exercises/models/movement.dart';

class ExerciseService {
  Future<MovementData> fetchMovementList() async {
    final url = Uri.parse('https://exercisedb.p.rapidapi.com/exercises?limit=1500');

    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': '285d3fd772mshf7dda38702a6023p1c552ejsn8f9de0708237',
        'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      return MovementData.fromService(json.decode(response.body));
    } else {
      throw 'HTTP status code: ${response.statusCode}\nBody: ${response.body}';
    }
  }
}
