import 'package:dio/dio.dart';
import 'package:simplecrud/data/models/item_model.dart';

class ItemApiService {
  final Dio _dio;
  final String _baseUrl;

  ItemApiService(this._dio, {String? baseUrl})
      : _baseUrl = baseUrl ?? 'https://api.restful-api.dev';

  Future<List<ItemModel>> fetchItems() async {
    final response = await _dio.get('$_baseUrl/objects');
    return (response.data as List)
        .map((json) => ItemModel.fromJson(json))
        .toList();
  }

  Future<ItemModel> fetchItem(String id) async {
    final response = await _dio.get('$_baseUrl/objects/$id');
    return ItemModel.fromJson(response.data);
  }

  Future<ItemModel> createItem(ItemModel item) async {
    final response = await _dio.post(
      '$_baseUrl/objects',
      data: item.toJson(),
    );
    return ItemModel.fromJson(response.data);
  }

  Future<ItemModel> updateItem(String id, ItemModel item) async {
    final response = await _dio.put(
      '$_baseUrl/objects/$id',
      data: item.toJson(),
    );
    return ItemModel.fromJson(response.data);
  }

  Future<String> deleteItem(String id) async {
    final response = await _dio.delete('$_baseUrl/objects/$id');
    if (response.statusCode == 200 || response.statusCode == 204) {
      return response.data['message']; // Return the success message
    } else {
      throw Exception('Failed to delete the item');
    }
  }
}
