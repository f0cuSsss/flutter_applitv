import 'package:http/http.dart' as http;

class HTTPService {
  static Future doGet(Uri uri) async {
    return await http.get(uri);
  }
}
