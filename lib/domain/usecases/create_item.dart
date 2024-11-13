import 'package:simplecrud/data/models/item_model.dart';
import 'package:simplecrud/data/network/item_api_service.dart';
import 'package:simplecrud/domain/entities/item.dart';

class CreateItem {
  final ItemApiService apiService;

  CreateItem(this.apiService);

  Future<Item> call(Item item) async {
    ItemModel itemModel = ItemModel(
      id: item.id,
      name: item.name,
      data: item.data,
    );

    ItemModel createdItem = await apiService.createItem(itemModel);

    return Item(
      id: createdItem.id,
      name: createdItem.name,
      data: createdItem.data,
      createdAt: createdItem.createdAt,
    );
  }
}
