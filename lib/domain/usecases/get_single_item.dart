import 'package:simplecrud/data/models/item_model.dart';
import 'package:simplecrud/data/network/item_api_service.dart';
import 'package:simplecrud/domain/entities/item.dart';

class GetSingleItem {
  final ItemApiService apiService;

  GetSingleItem(this.apiService);

  Future<Item> call(String id) async {
    ItemModel itemModel = await apiService.fetchItem(id);

    return Item(
      id: itemModel.id,
      name: itemModel.name,
      data: itemModel.data,
    );
  }
}
