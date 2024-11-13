import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplecrud/domain/usecases/create_item.dart';
import 'package:simplecrud/domain/usecases/delete_item.dart';
import 'package:simplecrud/domain/usecases/get_list_of_items.dart';
import 'package:simplecrud/domain/usecases/get_single_item.dart';
import 'package:simplecrud/domain/usecases/update_item.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/item.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List<Item> items;

  const ItemLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class SingleItemLoaded extends ItemState {
  final Item item;

  const SingleItemLoaded(this.item);

  @override
  List<Object> get props => [item];
}

class ItemError extends ItemState {
  final String message;

  const ItemError(this.message);

  @override
  List<Object> get props => [message];
}

class ItemCreateSuccess extends ItemState {
  final Item createdItem;

  const ItemCreateSuccess(this.createdItem);

  @override
  List<Object> get props => [createdItem];
}

class ItemUpdateSuccess extends ItemState {
  final Item updatedItem;

  const ItemUpdateSuccess(this.updatedItem);

  @override
  List<Object> get props => [updatedItem];
}

class ItemDeleteSuccess extends ItemState {
  final String message;

  const ItemDeleteSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ItemCubit extends Cubit<ItemState> {
  final GetListOfItems getListOfItems;
  final GetSingleItem getSingleItem;
  final CreateItem createItem;
  final UpdateItem updateItem;
  final DeleteItem deleteItem;

  ItemCubit(
    this.getListOfItems,
    this.getSingleItem,
    this.createItem,
    this.updateItem,
    this.deleteItem,
  ) : super(ItemLoading());

  final Uuid uuid = const Uuid();
  final List<Item> userCreatedItems = []; // To track user-created items

  void fetchItems() async {
    try {
      emit(ItemLoading());
      final publicItems = await getListOfItems();
      final allItems = [...userCreatedItems, ...publicItems];
      emit(ItemLoaded(allItems));
    } catch (e) {
      emit(ItemError("Failed to load items: ${e.toString()}"));
    }
  }

  void fetchSingleItem(String id) async {
    try {
      emit(ItemLoading());
      final item = await getSingleItem(id);
      emit(SingleItemLoaded(item));
    } catch (e) {
      emit(ItemError(e.toString()));
    }
  }

  Future<void> createNewItem(String name, Map<String, dynamic> data) async {
    try {
      emit(ItemLoading());
      final newItem =
          await createItem(Item(id: uuid.v4(), name: name, data: data));
      userCreatedItems.add(newItem);
      emit(ItemCreateSuccess(newItem));
      fetchItems();
    } catch (e) {
      emit(ItemError(e.toString()));
      rethrow;
    }
  }

  Future<void> updateExistingItem(
      String id, String name, Map<String, dynamic> data) async {
    try {
      emit(ItemLoading()); // Show loading spinner
      final updatedItem =
          await updateItem(id, Item(id: id, name: name, data: data));
      final index = userCreatedItems.indexWhere((item) => item.id == id);
      // To update entry in user created items
      if (index != -1) {
        userCreatedItems[index] = updatedItem;
      }
      emit(ItemUpdateSuccess(updatedItem));
      fetchItems();
    } catch (e) {
      emit(ItemError(e.toString()));
      rethrow;
    }
  }

  Future<void> deleteItemById(String id) async {
    try {
      emit(ItemLoading());
      final responseMessage = await deleteItem(id);
      userCreatedItems.removeWhere((item) => item.id == id);
      emit(ItemDeleteSuccess(responseMessage));
      fetchItems();
    } catch (e) {
      emit(ItemError(e.toString()));
    }
  }
}
