import 'package:http/http.dart' as http;

const String baseUrl = 'https://staging-server.in/android-task/api.php?size=';

enum ServiceState { initial, loading, complete }

class ApiCalls {
  static Future<http.Response> get(String url, Map<String, String> mapHeaders) async {
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: mapHeaders,
    );
    return response;
  }
}
