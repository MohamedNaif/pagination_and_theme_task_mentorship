import 'package:pagination_and_theme_task/core/api/api_consumer.dart';
import 'package:pagination_and_theme_task/core/api/end_points.dart';
import '../models/product_model.dart';

class ProductsRemoteDataSource {
  final ApiConsumer apiConsumer;

  ProductsRemoteDataSource({required this.apiConsumer});

  /// Fetch products with limit and skip (pagination)
  Future<List<ProductModel>> fetchProducts({
    int limit = 10,
    int skip = 0,
  }) async {
    final response = await apiConsumer.get(
      path: EndPoints.products,
      queryParameters: {'limit': limit, 'skip': skip},
    );

    if (response == null) return [];

    final List items = response['products'] as List? ?? [];
    return items
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
