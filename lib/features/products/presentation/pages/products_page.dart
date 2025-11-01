import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_and_theme_task/core/widgets/list_view_pagination.dart';
import 'package:pagination_and_theme_task/features/products/presentation/cubit/products_cubit.dart';
import 'package:pagination_and_theme_task/features/products/data/models/product_model.dart';
import 'package:go_router/go_router.dart';
import 'package:pagination_and_theme_task/core/di/dependency_injection.dart';
import 'package:pagination_and_theme_task/core/theme/theme_controller.dart';
import 'package:pagination_and_theme_task/core/storage/cache_helper.dart';
import 'package:pagination_and_theme_task/config/routing/routes.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late ProductsCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<ProductsCubit>();
    // initial fetch
    cubit.fetchNext();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = getIt<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ValueListenableBuilder<ThemeMode>(
              valueListenable: themeController,
              builder: (context, value, _) {
                final isDark = value == ThemeMode.dark;
                return Switch(
                  value: isDark,
                  onChanged: (v) async {
                    final newMode = v ? ThemeMode.dark : ThemeMode.light;
                    themeController.value = newMode;
                    await AppSharedPreferences.setString(
                      key: 'theme_mode',
                      value: v ? 'dark' : 'light',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          List<ProductModel> items = [];
          bool hasMore = true;
          if (state is ProductsLoading) {
            items = state.items.cast<ProductModel>();
          } else if (state is ProductsLoaded) {
            items = state.items.cast<ProductModel>();
            hasMore = state.hasMore;
          } else if (state is ProductsError) {
            items = state.items.cast<ProductModel>();
          }

          return Column(
            children: [
              Expanded(
                child: ListViewPagination(
                  itemCount: items.length + (hasMore ? 1 : 0),
                  addEvent: () => cubit.fetchNext(),
                  itemBuilder: (ctx, index) {
                    if (index >= items.length) {
                      // loading indicator
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final product = items[index];
                    return ListTile(
                      onTap: () {
                        // Navigate to details and pass the product as extra
                        context.push(Routes.productDetailsPage, extra: product);
                      },
                      leading: product.thumbnail.isNotEmpty
                          ? Image.network(
                              product.thumbnail,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            )
                          : null,
                      title: Text(product.title),
                      subtitle: Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
