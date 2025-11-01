// import 'dart:typed_data';
import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_and_theme_task/core/di/dependency_injection.dart';
import 'package:pagination_and_theme_task/features/products/presentation/pages/products_page.dart';
import 'package:pagination_and_theme_task/features/products/presentation/cubit/products_cubit.dart';
import 'package:pagination_and_theme_task/features/products/presentation/pages/product_details_page.dart';
import 'package:pagination_and_theme_task/features/products/data/models/product_model.dart';
import 'package:pagination_and_theme_task/config/routing/routes.dart';
// import 'package:pagination_and_theme_task/core/di/dependency_injection.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

CustomTransitionPage<void> _buildPageWithSlideTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  required TextDirection? textDirection,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 600),
    reverseTransitionDuration: const Duration(milliseconds: 600),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const slideBegin = Offset(1.0, 0.0);
      const slideEnd = Offset.zero;
      const slideCurve = Curves.easeOutCubic;
      var slideTween = Tween(
        begin: slideBegin,
        end: slideEnd,
      ).chain(CurveTween(curve: slideCurve));
      var slideAnimation = animation.drive(slideTween);

      const fadeBegin = 1.0;
      const fadeEnd = 0.0;
      var fadeOutTween = Tween(
        begin: fadeBegin,
        end: fadeEnd,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      var fadeOutAnimation = secondaryAnimation.drive(fadeOutTween);

      return AnimatedBuilder(
        animation: secondaryAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: fadeOutAnimation,
            child: SlideTransition(
              textDirection: textDirection ?? TextDirection.ltr,
              position: slideAnimation,
              child: child!,
            ),
          );
        },
        child: child,
      );
    },
  );
}

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,

  initialLocation: () {
    return Routes.products;
  }(),

  routes: [
    GoRoute(
      path: Routes.home,
      pageBuilder: (context, state) => _buildPageWithSlideTransition(
        context: context,
        state: state,
        child: const Scaffold(),
        textDirection: TextDirection.rtl,
      ),
    ),
    GoRoute(
      path: Routes.products,
      pageBuilder: (context, state) => _buildPageWithSlideTransition(
        context: context,
        state: state,
        child: BlocProvider(
          create: (_) => getIt<ProductsCubit>(),
          child: const ProductsPage(),
        ),
        textDirection: TextDirection.ltr,
      ),
    ),
    GoRoute(
      path: Routes.productDetailsPage,
      pageBuilder: (context, state) {
        final extra = state.extra;
        ProductModel? product;
        if (extra is ProductModel) product = extra;
        return _buildPageWithSlideTransition(
          context: context,
          state: state,
          child: product != null
              ? ProductDetailsPage(product: product)
              : const Scaffold(body: Center(child: Text('Product not found'))),
          textDirection: TextDirection.ltr,
        );
      },
    ),
  ],
);
