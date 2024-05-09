import 'dart:convert';

import 'package:http/http.dart' as http;

class PostService {
  // baseurl for API
  String baseUrl =
      "https://crudcrud.com/api/acf8062f54204b18927a36e9da1319dd/unicorns";
  // returns a list of all posts as per my API
  // may use this in a futurebuilder
  Future<List> getPosts() async {
    try {
      var response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        return Future.error("Server Error !");
      }
    } catch (SocketException) {
      // fetching error
      // may be timeout, no internet or dns not resolved
      return Future.error("Error Fetching Data !");
    }
  }

  Future<String> createPost(Map data) async {
    try {
      var response = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      if (response.statusCode == 200) {
        return "success";
      } else {
        print(response.body);
        // server error
        return "err";
      }
    } catch (SocketException) {
      // fetching error
      return "Bad";
    }
  }

  deletePost(Map data) async {
    try {
      var response = await http.delete(
        Uri.parse("$baseUrl/${data['_id']}"),
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      //
      if (response.statusCode == 200) {
        return "success";
      } else {
        print(response.body);
        // server error
        return "Server err";
      }
    } catch (SocketException) {
      // fetching error
      return "Fetch err";
    }
  }

  Future<String> updatePost(Map<String, dynamic> data, link) async {
    try {
      var response = await http.put(
        Uri.parse("$baseUrl/$link"),
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        return "success";
      } else {
        print("Server error: ${response.body}");
        return "err";
      }
    } catch (e) {
      print("Error updating post: $e");
      return "err";
    }
  }
}
