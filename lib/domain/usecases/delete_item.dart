import 'package:simplecrud/data/network/item_api_service.dart';

class DeleteItem {
  final ItemApiService apiService;

  DeleteItem(this.apiService);

  Future<void> call(String id) {
    return apiService.deleteItem(id);
  }
}
