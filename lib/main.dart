import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplecrud/domain/usecases/create_item.dart';
import 'package:simplecrud/domain/usecases/delete_item.dart';
import 'package:simplecrud/domain/usecases/get_list_of_items.dart';
import 'package:simplecrud/domain/usecases/get_single_item.dart';
import 'package:simplecrud/domain/usecases/update_item.dart';
import 'package:simplecrud/presentation/cubit/item_cubit.dart';
import 'package:simplecrud/presentation/pages/item_page.dart';
import 'package:simplecrud/service_locator.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ItemCubit>(
          create: (_) => ItemCubit(
            getIt<GetListOfItems>(),
            getIt<GetSingleItem>(),
            getIt<CreateItem>(),
            getIt<UpdateItem>(),
            getIt<DeleteItem>(),
          ),
        ),
      ],
      child: MaterialApp(
          title: 'Simple CRUD App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const ItemPage()),
    );
  }
}
