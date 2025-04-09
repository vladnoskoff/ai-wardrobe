import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';

class ApiService {
  static const String baseUrl = "http://test.noskov-steam.ru:4083";
  static final storage = FlutterSecureStorage();

  // Регистрация пользователя
  static Future<void> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );
    if (response.statusCode != 200) {
      throw Exception("Ошибка регистрации");
    }
  }

  // Логин пользователя
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: "token", value: data["access_token"]);
      return data;  // Ensure to return the response data
    } else {
      throw Exception("Ошибка входа");
    }
  }

  // Обновить стиль пользователя
  static Future<void> updateUserStyle(int userId, String style) async {
    final response = await http.put(
      Uri.parse("$baseUrl/users/$userId/style?style=$style"),
    );
    if (response.statusCode != 200) {
      throw Exception("Ошибка при обновлении стиля");
    }
  }

  // Обновить ключи API
  static Future<void> updateAPIKeys(int userId, String openaiApiKey, String weatherApiKey) async {
    final response = await http.put(
      Uri.parse("$baseUrl/users/$userId/update_keys?openai_api_key=$openaiApiKey&weather_api_key=$weatherApiKey"),
    );
    if (response.statusCode != 200) {
      throw Exception("Ошибка при обновлении ключей API");
    }
  }

  // Получение сохраненного токена
  static Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  // Получить список одежды
  static Future<List<dynamic>> getClothes() async {
    final response = await http.get(Uri.parse("$baseUrl/clothes/"));
    
    if (response.statusCode == 200) {
      final utf8Response = utf8.decode(response.bodyBytes); // Декодируем в utf8
      print("Ответ от сервера: $utf8Response"); // Выводим ответ в консоль Flutter
      return jsonDecode(utf8Response);
    } else {
      throw Exception("Ошибка при загрузке одежды: ${response.statusCode}");
    }
  }
  
  // Добавление одежды
  static Future<Map<String, dynamic>> addClothes(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/clothes/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  // Загрузка изображения
  static Future<String> uploadImage(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/clothes/upload-image/'),
    );
    request.files.add(
      await http.MultipartFile.fromPath('file', image.path),
    );

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var result = jsonDecode(responseData);

    if (response.statusCode == 200) {
      return result['image_url'];
    } else {
      throw Exception('Ошибка при загрузке изображения');
    }
  }

  // Удалить вещь
  static Future<void> deleteClothes(int clothesId) async {
    final response = await http.delete(Uri.parse("$baseUrl/clothes/$clothesId"));
    if (response.statusCode != 200) {
      throw Exception('Ошибка при удалении одежды');
    }
  }

  // Получить погоды
  static Future<Map<String, dynamic>> getWeather(String city) async {
    final response = await http.get(Uri.parse("$baseUrl/weather/$city"));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      return decodedData;
    } else {
      throw Exception('Ошибка при получении данных о погоде');
    }
  }

  // Получить подбор наряда
  static Future<Map<String, dynamic>> getOutfit(int userId, String city) async {
    final response = await http.get(Uri.parse("$baseUrl/outfits/$userId/$city"));
    return jsonDecode(response.body);
  }

  // Получить историю нарядов
  static Future<List<dynamic>> getOutfitHistory(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/outfits/history/$userId"));
    return jsonDecode(response.body);
  }

  // Оценка наряда
  static Future<void> rateOutfit(int outfitId, int rating) async {
    final response = await http.put(
      Uri.parse("$baseUrl/outfits/rate/$outfitId?rating=$rating"),
    );
    if (response.statusCode != 200) {
      throw Exception("Ошибка при обновлении рейтинга");
    }
  }

  // Получить рекомендации от ИИ
  static Future<String> getAIRecommendation(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/ai/recommendation/$userId"));
    return jsonDecode(response.body)["recommendation"];
  }

  // Получить визуальное изображение наряда
  static Future<String> getVisualOutfit(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/ai/visual-recommendation/$userId"));
    return jsonDecode(response.body)["image_url"];
  }

  // Получить часто используемые вещи
  static Future<List<dynamic>> getMostWornClothes(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/analytics/most_worn/$userId"));
    return jsonDecode(response.body);
  }

  // Получить забытые вещи
  static Future<List<dynamic>> getLeastWornClothes(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/analytics/least_worn/$userId"));
    return jsonDecode(response.body);
  }
}
