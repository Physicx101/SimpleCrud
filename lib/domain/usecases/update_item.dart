import 'package:simplecrud/data/models/item_model.dart';
import 'package:simplecrud/data/network/item_api_service.dart';

import '../entities/item.dart';

class UpdateItem {
  final ItemApiService apiService;

  UpdateItem(this.apiService);

  Future<Item> call(String id, Item item) async {
    ItemModel itemModel = ItemModel(
      id: id,
      name: item.name,
      data: item.data,
    );

    ItemModel updatedItem = await apiService.updateItem(id, itemModel);

    return Item(
      id: updatedItem.id,
      name: updatedItem.name,
      data: updatedItem.data,
    );
  }
}
