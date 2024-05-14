import 'package:http/http.dart' as http;
import 'dart:convert';

class CallApi {
  final String apiUrl;
  final String _url = 'http://127.0.0.1:8000/api/';

  CallApi({required this.apiUrl});

  Future<http.Response> postData(Map<String, dynamic> data, String endpoint) async {
    var fullUrl = apiUrl + endpoint;
    return http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  Future<http.Response> postWithToken(String token, String apiUrl) async {
    var fullUrl = _url + apiUrl;
    return http.post(
      Uri.parse(fullUrl),
      headers: _setHeaderToken(token),
    );
  }
  Future<http.Response> getData(String endpoint,String token) async {
    var fullUrl = apiUrl + endpoint;
    return http.get(
      Uri.parse(fullUrl),
      headers: _setHeaderToken(token),
    );
  }

  Map<String, String> _setHeaders() {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      // Add any other headers if needed
    };
  }

  Map<String, String> _setHeaderToken(String token) {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
