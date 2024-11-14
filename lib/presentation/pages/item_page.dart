import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/item_cubit.dart';
import '../../domain/entities/item.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  @override
  void initState() {
    super.initState();
    context.read<ItemCubit>().fetchItems(); // Fetch items on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
      ),
      body: BlocListener<ItemCubit, ItemState>(
        listener: (context, state) {
          // Show dialog or snackbar based on state changes
          if (state is ItemCreateSuccess) {
            showApiResponseDialog(context, state.createdItem);
          } else if (state is ItemUpdateSuccess) {
            showApiResponseDialog(context, state.updatedItem);
          } else if (state is ItemDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ItemError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<ItemCubit, ItemState>(
          builder: (context, state) {
            if (state is ItemLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ItemLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];

                  // To check if item is user created and modifiable
                  final isUserCreated =
                      context.read<ItemCubit>().userCreatedItems.contains(item);

                  return ListTile(
                    onTap: () async {
                      final currentItem = await context
                          .read<ItemCubit>()
                          .fetchSingleItem(item.id);
                      if (context.mounted) {
                        await showDetailDialog(context, currentItem);
                      }
                    },
                    title: Text(item.name),
                    subtitle: _buildItemDetails(item),
                    trailing: isUserCreated
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async =>
                                    await showEditItemDialog(context, item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => showDeleteConfirmationDialog(
                                    context, item.id),
                              ),
                            ],
                          )
                        : null,
                  );
                },
              );
            } else if (state is ItemError) {
              return Center(
                child: Text(state.message),
              );
            }
            return const Center(
              child: Text('No items available.'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await showCreateItemDialog(context),
        tooltip: 'Create new item',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildItemDetails(Item item) {
    if (item.data == null || item.data!.isEmpty) {
      return const Text('No details available');
    }

    List<Widget> details = [];

    item.data!.forEach((key, value) {
      details.add(
        Text('$key: $value', style: const TextStyle(fontSize: 14)),
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: details,
    );
  }

  // Async method for creating an item dialog
  Future<void> showCreateItemDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController yearController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController colorController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create New Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Year'),
            ),
            TextField(
              controller: priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: colorController,
              decoration: const InputDecoration(labelText: 'Color'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              String name = nameController.text;
              String yearText = yearController.text;
              String priceText = priceController.text;
              String colorText = colorController.text;

              if (name.isEmpty ||
                  yearText.isEmpty ||
                  priceText.isEmpty ||
                  colorText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill out all fields.')),
                );
                return;
              }

              int? year = int.tryParse(yearText);
              double? price = double.tryParse(priceText);
              if (year == null || price == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Invalid year or price format.')),
                );
                return;
              }

              Map<String, dynamic> data = {
                'year': year,
                'price': price,
                'color': colorText,
              };
              context.read<ItemCubit>().createNewItem(name, data);
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> showEditItemDialog(BuildContext context, Item item) async {
    final TextEditingController nameController =
        TextEditingController(text: item.name);
    final TextEditingController yearController =
        TextEditingController(text: item.data?['year']?.toString() ?? '');
    final TextEditingController priceController =
        TextEditingController(text: item.data?['price']?.toString() ?? '');
    final TextEditingController colorController =
        TextEditingController(text: item.data?['color'] ?? '');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Year'),
            ),
            TextField(
              controller: priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: colorController,
              decoration: const InputDecoration(labelText: 'Color'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              String updatedName = nameController.text;
              String updatedYearText = yearController.text;
              String updatedPriceText = priceController.text;
              String updatedColor = colorController.text;

              if (updatedName.isEmpty ||
                  updatedYearText.isEmpty ||
                  updatedPriceText.isEmpty ||
                  updatedColor.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields.')),
                );
                return;
              }

              int? updatedYear = int.tryParse(updatedYearText);
              double? updatedPrice = double.tryParse(updatedPriceText);

              if (updatedYear == null || updatedPrice == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Invalid year or price format.')),
                );
                return;
              }

              Map<String, dynamic> updatedData = {
                'year': updatedYear,
                'price': updatedPrice,
                'color': updatedColor,
              };
              context.read<ItemCubit>().updateExistingItem(
                    item.id,
                    updatedName,
                    updatedData,
                  );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> showApiResponseDialog(BuildContext context, Item item) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Item Updated Successfully'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Id: ${item.id}'),
            Text('Name: ${item.name}'),
            Text('Year: ${item.data?['year']}'),
            Text('Price: \$${item.data?['price']}'),
            Text('Color: ${item.data?['color']}'),
            if (item.createdAt != null) Text('Created At: ${item.createdAt}'),
            if (item.updatedAt != null) Text('Updated At: ${item.updatedAt}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> showDetailDialog(BuildContext context, Item item) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item.name),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_buildItemDetails(item)]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ItemCubit>().deleteItemById(id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
