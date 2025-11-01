import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:pagination_and_theme_task/core/storage/cache_helper.dart';
import 'package:pagination_and_theme_task/features/products/data/models/product_model.dart';
import 'package:pagination_and_theme_task/features/products/data/repositories/products_repository_impl.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepositoryImpl repository;
  final int pageSize;

  ProductsCubit({required this.repository, this.pageSize = 10})
    : super(ProductsInitial());

  int _skip = 0;
  bool _hasMore = true;
  final List<ProductModel> _items = [];

  Future<void> fetchNext() async {
    if (!_hasMore || state is ProductsLoading) return;
    emit(ProductsLoading(items: List.from(_items)));

    try {
      final products = await repository.getProducts(
        limit: pageSize,
        skip: _skip,
      );
      if (products.isEmpty) {
        _hasMore = false;
      } else {
        _items.addAll(products);
        _skip += products.length;
        // cache last items as simple JSON strings (ids) for demo
        await AppSharedPreferences.setString(
          key: 'cached_products',
          value: _items.map((e) => e.id.toString()).join(','),
        );
      }

      emit(ProductsLoaded(items: List.from(_items), hasMore: _hasMore));
    } catch (e) {
      // simple error logging to console, BlocObserver will also log
      // store last error message for debugging
      await AppSharedPreferences.setString(
        key: 'last_error',
        value: e.toString(),
      );
      emit(ProductsError(message: e.toString(), items: List.from(_items)));
    }
  }
}
