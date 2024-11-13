import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:simplecrud/data/network/item_api_service.dart';
import 'package:simplecrud/domain/usecases/create_item.dart';
import 'package:simplecrud/domain/usecases/delete_item.dart';
import 'package:simplecrud/domain/usecases/get_list_of_items.dart';
import 'package:simplecrud/domain/usecases/get_single_item.dart';
import 'package:simplecrud/domain/usecases/update_item.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<ItemApiService>(
      () => ItemApiService(getIt<Dio>()));

  getIt.registerLazySingleton<GetListOfItems>(
      () => GetListOfItems(getIt<ItemApiService>()));
  getIt.registerLazySingleton<GetSingleItem>(
      () => GetSingleItem(getIt<ItemApiService>()));
  getIt.registerLazySingleton<CreateItem>(
      () => CreateItem(getIt<ItemApiService>()));
  getIt.registerLazySingleton<UpdateItem>(
      () => UpdateItem(getIt<ItemApiService>()));
  getIt.registerLazySingleton<DeleteItem>(
      () => DeleteItem(getIt<ItemApiService>()));
}
