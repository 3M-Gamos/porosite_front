// porosity_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/material.dart';
class PorosityService {
  Future<double> calculatePorosity(Map<String, dynamic> requestData) async {
    var url = 'http://127.0.0.1:8000/calculate-porosity/';
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode(requestData);

    var response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['porosity'];
    } else {
      throw Exception('Failed to calculate porosity');
    }
  }
  Future<List<Material>> materialDrop() async {
  var url = 'http://127.0.0.1:8000/materials/';
  var headers = {'Content-Type': 'application/json'};

  var response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    // Access the 'results' key since the response is paginated
    List<dynamic> items = data['results'];
    List<Material> materials = items.map<Material>((json) {
      return Material.fromJson(json as Map<String, dynamic>);
    }).toList();
    return materials;
  } else {
    throw Exception('Failed to load materials');
  }
}

}
