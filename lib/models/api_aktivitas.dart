import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sidedi/models/avtivitas_model.dart';

class ApiManager {
  Future<List<Activitas>> fetchData() async {
    // geting response from API.
    var response = await http
        .get(Uri.parse("http://192.168.0.107:8000/api/aktivitas-index"));
    // checking if Get request is successful by 200 status.
    if (response.statusCode == 200) {
      // decoding recieved string data into JSON data.
      var result = jsonDecode(response.body);
      // getting only Contries data from whole covid data which we convert into json.
      List jsonResponse = result["data"] as List;
      // print(jsonResponse);
      // return list by maping it with Activitas class.
      return jsonResponse.map((e) => Activitas.fromJson(e)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
