import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/main/repository_providers.dart';
import 'package:window_manager/window_manager.dart';
import 'core/main/root_router.dart';
import 'core/main/app_theme.dart';
import 'core/main/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.linux) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(300, 600),
      center: true,
      title: 'Aerialib Linux',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Run app
  runApp(MultiBlocProvider(
    providers: getBlocProviders(),
    child: const MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    print("[Main] Build ran");
    return MaterialApp(
      title: 'Aerialib',
      theme: getLightTheme(),
      darkTheme: getDarkTheme(),
      themeMode: ThemeMode.system, // TODO add toggle - .light or .dark
      onGenerateRoute: generateRoute,
      home: const RootRouter(),
    );
  }
}
