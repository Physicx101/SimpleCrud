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

  void fetchItems() async {
    try {
      emit(ItemLoading());
      final items = await getListOfItems();
      emit(ItemLoaded(items));
    } catch (e) {
      emit(ItemError(e.toString()));
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

  void createNewItem(String name, Map<String, dynamic> data) async {
    try {
      emit(ItemLoading());
      final newItem = Item(id: uuid.v4(), name: name, data: data);
      await createItem(newItem);
      fetchItems();
    } catch (e) {
      emit(ItemError(e.toString()));
    }
  }

  void updateExistingItem(
      String id, String name, Map<String, dynamic> data) async {
    try {
      emit(ItemLoading());
      final updatedItem = Item(id: id, name: name, data: data);
      await updateItem(id, updatedItem);
      fetchItems();
    } catch (e) {
      emit(ItemError(e.toString()));
    }
  }

  void deleteItemById(String id) async {
    try {
      emit(ItemLoading());
      await deleteItem(id);
      fetchItems();
    } catch (e) {
      emit(ItemError(e.toString()));
    }
  }
}
