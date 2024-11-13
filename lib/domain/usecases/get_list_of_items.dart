import 'package:simplecrud/data/models/item_model.dart';
import 'package:simplecrud/data/network/item_api_service.dart';

import '../entities/item.dart';

class GetListOfItems {
  final ItemApiService apiService;

  GetListOfItems(this.apiService);

  Future<List<Item>> call() async {
    List<ItemModel> itemModels = await apiService.fetchItems();

    return itemModels.map((itemModel) {
      return Item(
        id: itemModel.id,
        name: itemModel.name,
        data: itemModel.data,
      );
    }).toList();
  }
}
