import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Services {
  // static const url = "https://kj001.repit.tech";
  static const url = "http://10.0.2.2:8000";
  static const apiUrl = "$url/api";
  static late SharedPreferences prefs;

  static Future<Map?> login(
      {required String nim, required String password}) async {
    try {
      Response? response = await Dio().post(
        "$apiUrl/login",
        options: Options(headers: {
          "Accept": "application/json",
        }),
        data: {
          "nim": nim,
          "password": password,
        },
      );
      if (response.statusCode == 200) {
        prefs = await SharedPreferences.getInstance();
        prefs.setString("token", response.data['token'].toString());
        return response.data as Map;
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          throw e.response!.data['message'];
        }
      } else {
        rethrow;
      }
    }
    return null;
  }

  static Future<Response?> register(
      {required String name,
      required String nim,
      required String password}) async {
    try {
      Response? response = await Dio().post("$apiUrl/register", data: {
        "name": name,
        "nim": nim,
        "password": password,
      });
      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          throw e.response!.data['message'];
        }
      } else {
        rethrow;
      }
    }
    return null;
  }

  static Future<Response?> logout() async {
    prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
      Response? response = await Dio().get("$apiUrl/logout",
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          }));
      if (response.statusCode == 200) {
        prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        return response;
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          throw e.response!.data['message'];
        }
      } else {
        rethrow;
      }
    }
    return null;
  }

  static Future<Response?> createPost(
      {required String title, required String content}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      Response? response = await Dio().post("$apiUrl/posts",
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          }),
          data: {
            "title": title,
            "content": content,
          });
      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          throw e.response!.data['message'];
        }
      } else {
        rethrow;
      }
    }
    return null;
  }

  static Future<Map?> getMyPosts() async {
    prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
      Response? response = await Dio().get(
        "$apiUrl/user/posts",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200) {
        return response.data as Map;
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          throw e.response!.data['message'];
        }
      } else {
        rethrow;
      }
    }
    return null;
  }

  static Future<Map?> getPosts() async {
    prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
      Response? response = await Dio().get(
        "$apiUrl/posts",
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }),
      );
      if (response.statusCode == 200) {
        return response.data as Map;
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          throw e.response!.data['message'];
        }
      } else {
        rethrow;
      }
    }
    return null;
  }

  static Future<bool> validateToken() async {
    prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
      Response? response = await Dio().get(
        "$apiUrl/validate-token",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          }
        ),
      );
      if (response.statusCode == 200) {
        return true;
      }
    }catch(e){
      if(e is DioException){
        if(e.response != null){
          throw e.response!.data['message'];
        }
      }else{
        rethrow;
      }
    }
    return false;
  }
}
