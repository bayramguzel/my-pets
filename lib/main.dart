import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_pets/l10n/app_localizations.dart';

import 'notification_service.dart';
import 'providers/pet_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'widgets/app_gradient_background.dart';

/// Simple Microsoft Clarity integration helper.
/// For web, script already in index.html. For mobile, we can optionally send custom events later.
class ClarityService {
  static bool _initialized = false;
  static const String projectId = 'td1wrqc5mh';

  static Future<void> init() async {
    if (_initialized) return;
    // Currently, official Flutter mobile SDK not provided; web script handled in index.html.
    // Placeholder for potential platform channel/event forwarding.
    _initialized = true;
  }

  static void trackEvent(String name, [Map<String, dynamic>? data]) {
    // Web interop could be added with dart:js when needed.
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Decide whether to show splash screen (once per day)
  final prefs = await SharedPreferences.getInstance();
  final String? lastSplashDate = prefs.getString('last_splash_date');
  final String today = DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD
  bool showSplash = lastSplashDate != today;

  if (showSplash) {
    await prefs.setString('last_splash_date', today);
  }

  Future<void>(() async {
    try {
      await NotificationService().initialize();
    } catch (_) {}
  });

  ClarityService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetData()),
        ChangeNotifierProvider(create: (_) => AppSettings()),
        ChangeNotifierProvider(create: (_) => ExploreData()),
      ],
      child: MyPetsApp(showSplash: showSplash),
    ),
  );
}

class MyPetsApp extends StatelessWidget {
  final bool showSplash;
  const MyPetsApp({super.key, required this.showSplash});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'My Pets',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: settings.selectedLanguage == 'system'
              ? null
              : Locale(settings.selectedLanguage),
          localeResolutionCallback: (locale, supportedLocales) {
            if (settings.selectedLanguage != 'system') {
              final override = settings.selectedLanguage.toLowerCase();
              if (override == 'tr' || override == 'de' || override == 'en') {
                return Locale(override);
              }
              return const Locale('en');
            }
            final device = locale?.languageCode.toLowerCase();
            if (device == 'tr' || device == 'de' || device == 'en') {
              return Locale(device!);
            }
            return const Locale('en');
          },
          theme: _buildLightTheme(settings.selectedColorScheme),
          darkTheme: _buildDarkTheme(settings.selectedColorScheme),
          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          builder: (context, child) =>
              AppGradientBackground(child: child ?? const SizedBox.shrink()),
          home: showSplash
              ? const SplashScreen()
              : const MainNavigationScreen(),
        );
      },
    );
  }

  ThemeData _buildLightTheme(AppColorScheme colorScheme) {
    ColorScheme scheme;
    switch (colorScheme) {
      case AppColorScheme.orangeTheme:
        scheme = ColorScheme.fromSeed(seedColor: Colors.orange);
        break;
      case AppColorScheme.greenTheme:
        scheme = ColorScheme.fromSeed(seedColor: Colors.green);
        break;
      case AppColorScheme.purpleTheme:
        scheme = ColorScheme.fromSeed(seedColor: Colors.purple);
        break;
      case AppColorScheme.redTheme:
        scheme = ColorScheme.fromSeed(seedColor: Colors.red);
        break;
      case AppColorScheme.pinkTheme:
        scheme = ColorScheme.fromSeed(seedColor: Colors.pink);
        break;
      case AppColorScheme.tealTheme:
        scheme = ColorScheme.fromSeed(seedColor: Colors.teal);
        break;
      case AppColorScheme.yellowTheme:
        scheme = ColorScheme.fromSeed(seedColor: Colors.yellow);
        break;
      case AppColorScheme.cyanTheme:
        scheme = ColorScheme.fromSeed(seedColor: Colors.cyan);
        break;
      case AppColorScheme.brownTheme:
        scheme = ColorScheme.fromSeed(seedColor: Colors.brown);
        break;
      default:
        scheme = ColorScheme.fromSeed(seedColor: Colors.blue);
    }
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: scheme.primary,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false, // Left-aligned app bar titles
        foregroundColor: scheme.onSurface,
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primary.withValues(alpha: 0.12),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 1,
        surfaceTintColor: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
        ),
      ),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surface,
        disabledColor: scheme.onSurface.withValues(alpha: 0.12),
        selectedColor: scheme.primary.withValues(alpha: 0.12),
        secondarySelectedColor: scheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        labelStyle: TextStyle(color: scheme.onSurface),
        secondaryLabelStyle: TextStyle(color: scheme.onPrimary),
        brightness: Brightness.light,
      ),
    );
  }

  ThemeData _buildDarkTheme(AppColorScheme colorScheme) {
    ColorScheme scheme;
    switch (colorScheme) {
      case AppColorScheme.orangeTheme:
        scheme = ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
        );
        break;
      case AppColorScheme.greenTheme:
        scheme = ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        );
        break;
      case AppColorScheme.purpleTheme:
        scheme = ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        );
        break;
      case AppColorScheme.redTheme:
        scheme = ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        );
        break;
      case AppColorScheme.pinkTheme:
        scheme = ColorScheme.fromSeed(
          seedColor: Colors.pink,
          brightness: Brightness.dark,
        );
        break;
      case AppColorScheme.tealTheme:
        scheme = ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        );
        break;
      case AppColorScheme.yellowTheme:
        scheme = ColorScheme.fromSeed(
          seedColor: Colors.yellow,
          brightness: Brightness.dark,
        );
        break;
      case AppColorScheme.cyanTheme:
        scheme = ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        );
        break;
      case AppColorScheme.brownTheme:
        scheme = ColorScheme.fromSeed(
          seedColor: Colors.brown,
          brightness: Brightness.dark,
        );
        break;
      default:
        scheme = ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        );
    }
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: scheme.primary,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false, // Left-aligned app bar titles
        foregroundColor: scheme.onSurface,
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primary.withValues(alpha: 0.2),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 1,
        surfaceTintColor: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surface,
        disabledColor: scheme.onSurface.withValues(alpha: 0.12),
        selectedColor: scheme.primary.withValues(alpha: 0.2),
        secondarySelectedColor: scheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        labelStyle: TextStyle(color: scheme.onSurface),
        secondaryLabelStyle: TextStyle(color: scheme.onPrimary),
        brightness: Brightness.dark,
      ),
    );
  }
}
