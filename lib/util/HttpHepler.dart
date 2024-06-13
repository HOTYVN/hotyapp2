import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpRequest{
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  Future<dynamic> get(String url) async {

  }

  Future<dynamic> post(String url) async {

  }
}
