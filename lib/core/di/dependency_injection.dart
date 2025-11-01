import 'package:dio/dio.dart';
import 'package:pagination_and_theme_task/core/api/api_consumer.dart';
import 'package:get_it/get_it.dart';
import 'package:pagination_and_theme_task/core/api/dio_consumer.dart';
import 'package:flutter/material.dart';
import 'package:pagination_and_theme_task/core/theme/theme_controller.dart';
import 'package:pagination_and_theme_task/core/storage/cache_helper.dart';

// Products feature imports
import 'package:pagination_and_theme_task/features/products/data/datasources/products_remote_datasource.dart';
import 'package:pagination_and_theme_task/features/products/data/repositories/products_repository_impl.dart';
import 'package:pagination_and_theme_task/features/products/presentation/cubit/products_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupDependencyInjection() {
  // Dio Setup
  getIt.registerSingleton<Dio>(Dio());

  // ApiConsumer Setup
  getIt.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(dio: getIt<Dio>()),
  );

  // Theme controller (ValueNotifier) - initial value comes from SharedPreferences
  String? _themePref = AppSharedPreferences.getString(key: 'theme_mode');
  ThemeMode _initialTheme = ThemeMode.system;
  if (_themePref != null && _themePref == 'dark') {
    _initialTheme = ThemeMode.dark;
  } else if (_themePref != null && _themePref == 'light') {
    _initialTheme = ThemeMode.light;
  }
  getIt.registerSingleton<ThemeController>(ThemeController(_initialTheme));

  // Products feature registrations
  getIt.registerLazySingleton(
    () => ProductsRemoteDataSource(apiConsumer: getIt<ApiConsumer>()),
  );

  getIt.registerLazySingleton<ProductsRepositoryImpl>(
    () => ProductsRepositoryImpl(
      remoteDataSource: getIt<ProductsRemoteDataSource>(),
    ),
  );

  // Factory for cubit so UI can request a new instance when needed
  getIt.registerFactory<ProductsCubit>(
    () => ProductsCubit(repository: getIt<ProductsRepositoryImpl>()),
  );
}
