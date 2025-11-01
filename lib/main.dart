import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_and_theme_task/bloc_observer.dart';
import 'package:pagination_and_theme_task/config/routing/app_router.dart';
import 'package:pagination_and_theme_task/config/theme/app_theme.dart';
import 'package:pagination_and_theme_task/core/di/dependency_injection.dart';
import 'package:pagination_and_theme_task/core/storage/cache_helper.dart';
import 'package:pagination_and_theme_task/core/storage/lang.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSharedPreferences.initialSharedPreference();

  Bloc.observer = MyBlocObserver();
  MyBlocObserver();

  setupDependencyInjection();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [arabicLocal, englishLocal],
      fallbackLocale: englishLocal,
      path: assetsLocalization,

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    // load cached theme preference if exists
    final t = AppSharedPreferences.getString(key: 'theme_mode');
    if (t != null && t == 'dark') {
      themeMode = ThemeMode.dark;
    } else if (t != null && t == 'light') {
      themeMode = ThemeMode.light;
    }
  }

  @override
  void didChangeDependencies() {
    context.setLocale(arabicLocal);
    super.didChangeDependencies();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      routerConfig: router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
    );
  }
}
