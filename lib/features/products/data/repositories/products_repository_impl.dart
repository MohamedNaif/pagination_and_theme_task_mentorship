import 'package:pagination_and_theme_task/features/products/data/datasources/products_remote_datasource.dart';
import 'package:pagination_and_theme_task/features/products/data/models/product_model.dart';
import '../../domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int skip,
  }) {
    return remoteDataSource.fetchProducts(limit: limit, skip: skip);
  }
}
