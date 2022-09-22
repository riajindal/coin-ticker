import 'dart:convert';

import 'package:http/http.dart' as http;

class Networking {
  final url;

  Networking({this.url});

  Future<dynamic> getData() async {
    http.Response response = await http.get(Uri.parse(url));
    String data = response.body;
    print(response.statusCode);
    return jsonDecode(data);
  }
}
