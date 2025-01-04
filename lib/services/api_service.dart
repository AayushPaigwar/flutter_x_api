import 'dart:convert';

import 'package:flutter_x_api/models/products_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL
  static const String baseUrl = 'https://fakestoreapi.com/products';

  // Get all products
  static Future<List<ProductsModel>> fetchAllProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      return jsonData.map((json) => ProductsModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
