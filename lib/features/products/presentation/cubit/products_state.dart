part of 'products_cubit.dart';

@immutable
abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {
  final List items;
  ProductsLoading({required this.items});
}

class ProductsLoaded extends ProductsState {
  final List items;
  final bool hasMore;
  ProductsLoaded({required this.items, required this.hasMore});
}

class ProductsError extends ProductsState {
  final String message;
  final List items;
  ProductsError({required this.message, required this.items});
}
