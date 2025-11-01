import 'package:pagination_and_theme_task/features/products/data/models/product_model.dart';

abstract class ProductsRepository {
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int skip,
  });
}
