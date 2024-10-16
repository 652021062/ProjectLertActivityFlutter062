import 'package:flutter/material.dart';
import 'package:flutter_lab1/providers/user_providers.dart';
import 'package:flutter_lab1/variables.dart';
import 'package:flutter_lab1/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class ProductService {
  Future<List<ProductModel>> fetchProducts(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await http.get(
        Uri.parse('$apiURL/api/products'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((product) => ProductModel.fromJson(product)).toList();
      } else {
        print('Error fetching products: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Caught error while fetching products: $e');
      throw Exception('Failed to load products: $e');
    }
  }

  Future<bool> addProduct(BuildContext context, ProductModel product) async {
    // ตรวจสอบค่าของ product ก่อนส่ง
    if (product.activityName.isEmpty ||
        product.details.isEmpty ||
        product.numberOfApplicants < 0 ||
        product.time.isEmpty ||
        product.activityHours.isEmpty) {
      print('Error: All fields are required and must be valid.');
      return false;
    }

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await http.post(
        Uri.parse('$apiURL/api/product'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.accessToken}',
        },
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to add product: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding product: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(BuildContext context, String productId) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await http.delete(
        Uri.parse('$apiURL/api/product/$productId'),
        headers: <String, String>{
          'Authorization': 'Bearer ${userProvider.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete product: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }

  Future<bool> updateProduct(ProductModel product, BuildContext context) async {
    // ตรวจสอบค่าของ product ก่อนส่ง
    if (product.activityName.isEmpty ||
        product.details.isEmpty ||
        product.numberOfApplicants < 0 ||
        product.time.isEmpty ||
        product.activityHours.isEmpty) {
      print('Error: All fields are required and must be valid.');
      return false;
    }

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await http.put(
        Uri.parse('$apiURL/api/product/${product.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.accessToken}',
        },
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update product: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating product: $e');
      return false;
    }
  }
}
