import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  final String today = DateTime.now().toIso8601String().substring(
    0,
    10,
  ); // YYYY-MM-DD
  bool showSplash = lastSplashDate != today;

  if (showSplash) {
    await prefs.setString('last_splash_date', today);
  }

  Future<void>(() async {
    try {
      await NotificationService().initialize();
    } catch (_) {}
  });
  Future<void>(() async {
    try {
      await MobileAds.instance.initialize();
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
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
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
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
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
    );
  }
}

/*
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import 'package:my_pets/utils/localization_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'notification_service.dart';
import 'screens/add_data_screen.dart';
import 'screens/splash_screen.dart';
import 'widgets/banner_ad_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';

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
  await NotificationService().initialize();
  await MobileAds.instance.initialize();
  ClarityService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetData()),
        ChangeNotifierProvider(create: (_) => AppSettings()),
        ChangeNotifierProvider(create: (_) => ExploreData()),
      ],
      child: MyPetsApp(),
    ),
  );
}

class MyPetsApp extends StatelessWidget {
  const MyPetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'My Pets',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(settings.selectedLanguage),
          theme: _buildLightTheme(settings.selectedColorScheme),
          darkTheme: _buildDarkTheme(settings.selectedColorScheme),
          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const SplashScreen(),
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
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
    return ThemeData(colorScheme: scheme, useMaterial3: true);
  }
}

/// SETTINGS SCREEN
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(context, l10n.themeSettings),
          SwitchListTile(
            title: Text(l10n.darkMode),
            value: settings.isDarkMode,
            onChanged: (value) => settings.toggleDarkMode(value),
            secondary: const Icon(Icons.dark_mode),
          ),
          ListTile(
            title: Text(l10n.appTheme),
            subtitle: Text(
              _getThemeName(context, settings.selectedColorScheme),
            ),
            trailing: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _getThemeColor(settings.selectedColorScheme),
                shape: BoxShape.circle,
                border: Border.all(
                  color: settings.isDarkMode
                      ? Colors.black26
                      : Colors.grey[200]!,
                  width: 2,
                ),
              ),
            ),
            leading: const Icon(Icons.color_lens),
            onTap: () => _showThemePicker(context, settings),
          ),
          const Divider(),
          _buildSectionTitle(context, l10n.generalSettings),
          SwitchListTile(
            title: Text(l10n.notifications),
            value: settings.notificationsEnabled,
            onChanged: (value) => settings.toggleNotifications(value),
            secondary: const Icon(Icons.notifications),
          ),
          SwitchListTile(
            title: Text(l10n.sound),
            value: settings.soundEnabled,
            onChanged: (value) => settings.toggleSound(value),
            secondary: const Icon(Icons.volume_up),
          ),
          ListTile(
            title: Text(l10n.language),
            subtitle: Text(
              settings.selectedLanguage == 'system'
                  ? l10n.deviceLanguage
                  : settings.selectedLanguage == 'tr'
                  ? 'Türkçe'
                  : settings.selectedLanguage == 'de'
                  ? 'Deutsch'
                  : 'English',
            ),
            leading: const Icon(Icons.language),
            onTap: () => _showLanguagePicker(context, settings),
          ),
          const Divider(),
          _buildSectionTitle(context, l10n.about),
          ListTile(
            title: Text(l10n.aboutTheApp),
            leading: const Icon(Icons.info),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'My Pets',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.pets, size: 48),
                children: [
                  Text(l10n.appDescription),
                  const SizedBox(height: 16),
                  const Text('Web: www.41software.com'),
                  const Text('Email: info@41software.com'),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () async {
                      final Uri url = Uri.parse(
                        'https://www.41software.com/privacy/privacy_mypets.php',
                      );
                      if (!await launchUrl(url)) {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Text(l10n.privacyPolicy),
                  ),
                ],
              );
            },
          ),
          ListTile(
            title: Text(l10n.contactUs),
            leading: const Icon(Icons.email),
            onTap: () => _launchEmail('mailto:info@41software.com'),
          ),
          ListTile(
            title: Text(l10n.privacyPolicy),
            leading: const Icon(Icons.privacy_tip),
            onTap: () async {
              final Uri url = Uri.parse(
                'https://www.41software.com/privacy/privacy_mypets.php',
              );
              if (!await launchUrl(url)) {
                throw 'Could not launch $url';
              }
            },
          ),
          const Divider(),
          _buildSectionTitle(context, l10n.dataManagement),
          ListTile(
            title: Text(
              l10n.deleteAllData,
              style: const TextStyle(color: Colors.red),
            ),
            subtitle: Text(l10n.deleteAllDataWarning),
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            onTap: () => _showDeleteAllDataConfirm(context),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri uri = Uri.parse(email);
    if (!await launchUrl(uri)) {
      // Fallback if mailto fails
      debugPrint('Could not launch $email');
    }
  }

  Padding _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  String _getThemeName(BuildContext context, AppColorScheme scheme) {
    final l10n = AppLocalizations.of(context)!;
    switch (scheme) {
      case AppColorScheme.defaultTheme:
        return l10n.defaultTheme;
      case AppColorScheme.orangeTheme:
        return l10n.orangeTheme;
      case AppColorScheme.greenTheme:
        return l10n.greenTheme;
      case AppColorScheme.purpleTheme:
        return l10n.purpleTheme;
      case AppColorScheme.redTheme:
        return l10n.red;
      case AppColorScheme.pinkTheme:
        return l10n.pink;
      case AppColorScheme.tealTheme:
        return l10n.teal;
      case AppColorScheme.yellowTheme:
        return l10n.yellow;
      case AppColorScheme.cyanTheme:
        return l10n.cyan;
      case AppColorScheme.brownTheme:
        return l10n.brown;
    }
  }

  Color _getThemeColor(AppColorScheme scheme) {
    switch (scheme) {
      case AppColorScheme.orangeTheme:
        return Colors.orange;
      case AppColorScheme.greenTheme:
        return Colors.green;
      case AppColorScheme.purpleTheme:
        return Colors.purple;
      case AppColorScheme.redTheme:
        return Colors.red;
      case AppColorScheme.pinkTheme:
        return Colors.pink;
      case AppColorScheme.tealTheme:
        return Colors.teal;
      case AppColorScheme.yellowTheme:
        return Colors.yellow;
      case AppColorScheme.cyanTheme:
        return Colors.cyan;
      case AppColorScheme.brownTheme:
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }

  void _showThemePicker(BuildContext context, AppSettings settings) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.selectTheme),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: AppColorScheme.values.length,
              itemBuilder: (context, index) {
                final scheme = AppColorScheme.values[index];
                final isSelected = settings.selectedColorScheme == scheme;
                final themeColor = _getThemeColor(scheme);
                return InkWell(
                  onTap: () {
                    settings.setSelectedColorScheme(scheme);
                    Navigator.of(dialogContext).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? themeColor
                            : Colors.grey.withValues(alpha: 0.3),
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected
                          ? themeColor.withValues(alpha: 0.1)
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: themeColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: themeColor.withValues(alpha: 0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getThemeName(context, scheme),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : null,
                              color: isSelected ? themeColor : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showLanguagePicker(BuildContext context, AppSettings settings) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.selectLanguage),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(l10n.deviceLanguage),
                    leading: Icon(
                      settings.selectedLanguage == 'system'
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: settings.selectedLanguage == 'system'
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    onTap: () {
                      settings.setSelectedLanguage('system');
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                  ListTile(
                    title: const Text('Türkçe'),
                    leading: Icon(
                      settings.selectedLanguage == 'tr'
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: settings.selectedLanguage == 'tr'
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    onTap: () {
                      settings.setSelectedLanguage('tr');
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                  ListTile(
                    title: const Text('English'),
                    leading: Icon(
                      settings.selectedLanguage == 'en'
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: settings.selectedLanguage == 'en'
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    onTap: () {
                      settings.setSelectedLanguage('en');
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                  ListTile(
                    title: const Text('Deutsch'),
                    leading: Icon(
                      settings.selectedLanguage == 'de'
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: settings.selectedLanguage == 'de'
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    onTap: () {
                      settings.setSelectedLanguage('de');
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteAllDataConfirm(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAllData),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.deleteAllDataConfirm),
            const SizedBox(height: 16),
            Text(
              l10n.deleteAllDataWarning,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              await Provider.of<PetData>(context, listen: false).clearAll();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.deleteSuccess)));
              }
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

/// ENHANCED DATA MODELS
class Pet {
  final String id;
  String name;
  String type;
  String? breed;
  DateTime? birthDate;
  String photoUrl;
  String? nationalId;
  String? veterinarianName;
  String? veterinarianContact;
  String? notes;
  String? gender;
  double? weight;
  String? microchipId;
  String? insurance;
  String? emergencyContact;
  String? medicalHistory;
  String? allergies;
  String? currentMedications;
  DateTime? nextAppointment;
  String healthStatus;
  // New & Aesthetic fields
  String? color;
  DateTime? adoptionDate;
  String? trainingLevel; // beginner, intermediate, advanced
  String? favoriteFood;
  String? favoriteToy;
  double? height; // cm
  String? bloodType;
  DateTime? lastVetVisit;
  String? dietType; // regular, prescription, raw, homemade
  int? dailyExerciseMinutes;
  String? personality; // playful, calm, aggressive, shy, friendly
  String? activityLevel;
  bool? isSpayedOrNeutered;
  String? dietaryRequirements;
  String? favoriteToys;
  String? behavioralNotes;
  String? passportNumber;
  String? ownerName;
  String? ownerContact;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    this.breed,
    this.birthDate,
    this.photoUrl = 'https://via.placeholder.com/300x300.png?text=Pet+Photo',
    this.nationalId,
    this.veterinarianName,
    this.veterinarianContact,
    this.notes,
    this.gender,
    this.weight,
    this.microchipId,
    this.insurance,
    this.emergencyContact,
    this.medicalHistory,
    this.allergies,
    this.currentMedications,
    this.nextAppointment,
    this.healthStatus = 'good',
    this.color,
    this.adoptionDate,
    this.trainingLevel,
    this.favoriteFood,
    this.favoriteToy,
    this.height,
    this.bloodType,
    this.lastVetVisit,
    this.dietType,
    this.dailyExerciseMinutes,
    this.personality,
    this.activityLevel,
    this.isSpayedOrNeutered,
    this.dietaryRequirements,
    this.favoriteToys,
    this.behavioralNotes,
    this.passportNumber,
    this.ownerName,
    this.ownerContact,
  });

  int get ageInYears {
    if (birthDate == null) return 0;
    final DateTime now = DateTime.now();
    int age = now.year - birthDate!.year;
    if (now.month < birthDate!.month ||
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      age--;
    }
    return max(0, age);
  }

  // --- Simulation Helpers ---

  String get humanAge {
    if (birthDate == null) return '0';
    int years = ageInYears;
    int hAge = 0;

    switch (type.toLowerCase()) {
      case 'dog':
        if (years == 0) {
          hAge = (ageInMonths * 1.25).toInt();
        } else if (years == 1) {
          hAge = 15;
        } else if (years == 2) {
          hAge = 24;
        } else {
          hAge = 24 + (years - 2) * 4;
        }
        break;
      case 'cat':
        if (years == 0) {
          hAge = (ageInMonths * 1.25).toInt();
        } else if (years == 1) {
          hAge = 15;
        } else if (years == 2) {
          hAge = 24;
        } else {
          hAge = 24 + (years - 2) * 4;
        }
        break;
      case 'bird':
        hAge = years * 5;
        break;
      case 'rabbit':
        if (years == 0) {
          hAge = ageInMonths * 2;
        } else {
          hAge = 21 + (years - 1) * 6;
        }
        break;
      default:
        hAge = years * 7;
    }
    return hAge.toString();
  }

  String get dailyCalories {
    if (weight == null || weight == 0) return '0';
    // RER (Resting Energy Requirement) = 70 * (weight in kg ^ 0.75)
    double rer = (70 * pow(weight!, 0.75)).toDouble();
    double factor = 1.6; // Average active adult
    if (activityLevel == 'low') factor = 1.2;
    if (activityLevel == 'high') factor = 2.0;

    return (rer * factor).toStringAsFixed(0);
  }

  String get waterRequirement {
    if (weight == null || weight == 0) return '0';
    // Average 50-60ml per kg
    return (weight! * 55).toStringAsFixed(0);
  }

  int get ageInMonths {
    if (birthDate == null) return 0;
    final DateTime now = DateTime.now();
    int months =
        (now.year - birthDate!.year) * 12 + now.month - birthDate!.month;
    if (now.day < birthDate!.day) {
      months--;
    }
    return max(0, months);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'birthDate': birthDate?.toIso8601String(),
      'photoUrl': photoUrl,
      'nationalId': nationalId,
      'veterinarianName': veterinarianName,
      'veterinarianContact': veterinarianContact,
      'notes': notes,
      'gender': gender,
      'weight': weight,
      'microchipId': microchipId,
      'insurance': insurance,
      'emergencyContact': emergencyContact,
      'medicalHistory': medicalHistory,
      'allergies': allergies,
      'currentMedications': currentMedications,
      'nextAppointment': nextAppointment?.toIso8601String(),
      'healthStatus': healthStatus,
      'color': color,
      'isSpayedOrNeutered': isSpayedOrNeutered,
      'adoptionDate': adoptionDate?.toIso8601String(),
      'trainingLevel': trainingLevel,
      'favoriteFood': favoriteFood,
      'favoriteToy': favoriteToy,
      'height': height,
      'bloodType': bloodType,
      'lastVetVisit': lastVetVisit?.toIso8601String(),
      'dietType': dietType,
      'dailyExerciseMinutes': dailyExerciseMinutes,
      'personality': personality,
      'activityLevel': activityLevel,
      'dietaryRequirements': dietaryRequirements,
      'favoriteToys': favoriteToys,
      'behavioralNotes': behavioralNotes,
      'passportNumber': passportNumber,
      'ownerName': ownerName,
      'ownerContact': ownerContact,
    };
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      breed: json['breed'],
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : null,
      photoUrl:
          json['photoUrl'] ??
          'https://via.placeholder.com/300x300.png?text=Pet+Photo',
      nationalId: json['nationalId'],
      veterinarianName: json['veterinarianName'],
      veterinarianContact: json['veterinarianContact'],
      notes: json['notes'],
      gender: json['gender'],
      weight: json['weight']?.toDouble(),
      microchipId: json['microchipId'],
      insurance: json['insurance'],
      emergencyContact: json['emergencyContact'],
      medicalHistory: json['medicalHistory'],
      allergies: json['allergies'],
      currentMedications: json['currentMedications'],
      nextAppointment: json['nextAppointment'] != null
          ? DateTime.parse(json['nextAppointment'])
          : null,
      healthStatus: json['healthStatus'] ?? 'good',
      color: json['color'],
      adoptionDate: json['adoptionDate'] != null
          ? DateTime.parse(json['adoptionDate'])
          : null,
      trainingLevel: json['trainingLevel'],
      favoriteFood: json['favoriteFood'],
      favoriteToy: json['favoriteToy'],
      height: json['height']?.toDouble(),
      bloodType: json['bloodType'],
      lastVetVisit: json['lastVetVisit'] != null
          ? DateTime.parse(json['lastVetVisit'])
          : null,
      dietType: json['dietType'],
      dailyExerciseMinutes: json['dailyExerciseMinutes'],
      personality: json['personality'],
      activityLevel: json['activityLevel'],
      isSpayedOrNeutered: json['isSpayedOrNeutered'],
      dietaryRequirements: json['dietaryRequirements'],
      favoriteToys: json['favoriteToys'],
      behavioralNotes: json['behavioralNotes'],
      passportNumber: json['passportNumber'],
      ownerName: json['ownerName'],
      ownerContact: json['ownerContact'],
    );
  }
}

class PetActivity {
  final String id;
  final String petId;
  DateTime date;
  String category;
  String description;
  double? cost;

  PetActivity({
    required this.id,
    required this.petId,
    required this.date,
    required this.category,
    required this.description,
    this.cost,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'date': date.toIso8601String(),
      'category': category,
      'description': description,
      'cost': cost,
    };
  }

  factory PetActivity.fromJson(Map<String, dynamic> json) {
    return PetActivity(
      id: json['id'],
      petId: json['petId'],
      date: DateTime.parse(json['date']),
      category: json['category'],
      description: json['description'],
      cost: json['cost']?.toDouble(),
    );
  }
}

class Vaccination {
  final String id;
  final String petId;
  String vaccineName;
  DateTime vaccineDate;
  DateTime? nextDueDate;
  String? veterinarian;
  String? batchNumber;
  String? notes;

  Vaccination({
    required this.id,
    required this.petId,
    required this.vaccineName,
    required this.vaccineDate,
    this.nextDueDate,
    this.veterinarian,
    this.batchNumber,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'vaccineName': vaccineName,
      'vaccineDate': vaccineDate.toIso8601String(),
      'nextDueDate': nextDueDate?.toIso8601String(),
      'veterinarian': veterinarian,
      'batchNumber': batchNumber,
      'notes': notes,
    };
  }

  factory Vaccination.fromJson(Map<String, dynamic> json) {
    return Vaccination(
      id: json['id'],
      petId: json['petId'],
      vaccineName: json['vaccineName'],
      vaccineDate: DateTime.parse(json['vaccineDate']),
      nextDueDate: json['nextDueDate'] != null
          ? DateTime.parse(json['nextDueDate'])
          : null,
      veterinarian: json['veterinarian'],
      batchNumber: json['batchNumber'],
      notes: json['notes'],
    );
  }
}

class HealthReminder {
  final String id;
  final String petId;
  String title;
  DateTime reminderDate;
  TimeOfDay reminderTime;
  String repeatType;
  bool isActive;

  HealthReminder({
    required this.id,
    required this.petId,
    required this.title,
    required this.reminderDate,
    required this.reminderTime,
    this.repeatType = 'never',
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'title': title,
      'reminderDate': reminderDate.toIso8601String(),
      'reminderTime': '${reminderTime.hour}:${reminderTime.minute}',
      'repeatType': repeatType,
      'isActive': isActive,
    };
  }

  factory HealthReminder.fromJson(Map<String, dynamic> json) {
    final timeParts = json['reminderTime'].split(':');
    return HealthReminder(
      id: json['id'],
      petId: json['petId'],
      title: json['title'],
      reminderDate: DateTime.parse(json['reminderDate']),
      reminderTime: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      repeatType: json['repeatType'] ?? 'never',
      isActive: json['isActive'] ?? true,
    );
  }
}

class Expense {
  final String id;
  final String petId;
  double amount;
  String category;
  DateTime date;
  String description;

  Expense({
    required this.id,
    required this.petId,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      petId: json['petId'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }
}

/// ENHANCED DATA PROVIDER
class PetData extends ChangeNotifier {
  final List<Pet> _pets = [];
  final List<PetActivity> _activities = [];
  final List<Vaccination> _vaccinations = [];
  final List<HealthReminder> _reminders = [];
  final List<Expense> _expenses = [];
  String _viewMode = 'list'; // 'list' or 'grid'

  String get viewMode => _viewMode;

  void setViewMode(String mode) {
    _viewMode = mode;
    notifyListeners();
  }

  PetData() {
    _loadSampleData();
    _loadFromStorage();
  }

  void _loadSampleData() {
    _pets.addAll([
      Pet(
        id: 'pet_1',
        name: 'Buddy',
        type: 'dog',
        breed: 'Golden Retriever',
        birthDate: DateTime(2020, 5, 10),
        photoUrl: 'https://via.placeholder.com/300x300.png?text=Buddy',
        nationalId: 'TRPET12345',
        veterinarianName: 'Dr. Ayşe Demir',
        veterinarianContact: '0555 123 4567',
        notes: 'Enerjik ve oyun oynamayı çok seviyor. Mama alerjisi yok.',
        gender: 'male',
        weight: 25.5,
        microchipId: 'MC123456789',
        healthStatus: 'excellent',
      ),
      Pet(
        id: 'pet_2',
        name: 'Whiskers',
        type: 'cat',
        breed: 'Siyam',
        birthDate: DateTime(2022, 1, 15),
        photoUrl: 'https://via.placeholder.com/300x300.png?text=Whiskers',
        nationalId: 'TRCAT67890',
        veterinarianName: 'Dr. Can Kara',
        veterinarianContact: '0544 987 6543',
        notes: 'Sakindir, genelde uyur. Süt ürünlerine karşı hassasiyeti var.',
        gender: 'female',
        weight: 4.2,
        healthStatus: 'good',
      ),
    ]);

    _activities.addAll([
      PetActivity(
        id: 'act_1',
        petId: 'pet_1',
        date: DateTime.now().subtract(const Duration(days: 30)),
        category: 'veterinaryVisit',
        description: 'Yıllık kontrol, her şey yolunda.',
        cost: 150.0,
      ),
      PetActivity(
        id: 'act_2',
        petId: 'pet_1',
        date: DateTime.now().subtract(const Duration(days: 15)),
        category: 'feeding',
        description: 'Yeni mamaya geçildi. Her öğünde 2 ölçek.',
        cost: 85.0,
      ),
    ]);

    _vaccinations.addAll([
      Vaccination(
        id: 'vac_1',
        petId: 'pet_1',
        vaccineName: 'Kuduz',
        vaccineDate: DateTime.now().subtract(const Duration(days: 365)),
        nextDueDate: DateTime.now().add(const Duration(days: 30)),
        veterinarian: 'Dr. Ayşe Demir',
      ),
    ]);

    _expenses.addAll([
      Expense(
        id: 'exp_1',
        petId: 'pet_1',
        amount: 150.0,
        category: 'medical',
        date: DateTime.now().subtract(const Duration(days: 30)),
        description: 'Veteriner kontrolü',
      ),
    ]);
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final petsJson = prefs.getString('pets');
      if (petsJson != null) {
        final List<dynamic> petsList = jsonDecode(petsJson);
        _pets.clear();
        _pets.addAll(petsList.map((json) => Pet.fromJson(json)).toList());
      }

      final activitiesJson = prefs.getString('activities');
      if (activitiesJson != null) {
        final List<dynamic> activitiesList = jsonDecode(activitiesJson);
        _activities.clear();
        _activities.addAll(
          activitiesList.map((json) => PetActivity.fromJson(json)).toList(),
        );
      }

      final vaccinationsJson = prefs.getString('vaccinations');
      if (vaccinationsJson != null) {
        final List<dynamic> vaccinationsList = jsonDecode(vaccinationsJson);
        _vaccinations.clear();
        _vaccinations.addAll(
          vaccinationsList.map((json) => Vaccination.fromJson(json)).toList(),
        );
      }

      final remindersJson = prefs.getString('reminders');
      if (remindersJson != null) {
        final List<dynamic> remindersList = jsonDecode(remindersJson);
        _reminders.clear();
        _reminders.addAll(
          remindersList.map((json) => HealthReminder.fromJson(json)).toList(),
        );
      }

      final expensesJson = prefs.getString('expenses');
      if (expensesJson != null) {
        final List<dynamic> expensesList = jsonDecode(expensesJson);
        _expenses.clear();
        _expenses.addAll(
          expensesList.map((json) => Expense.fromJson(json)).toList(),
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading data from storage: $e');
    }
  }

  // --- Added getters & helpers for insights/export ---
  List<Pet> get pets => List.unmodifiable(_pets);

  void reorderPets(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Pet item = _pets.removeAt(oldIndex);
    _pets.insert(newIndex, item);
    _saveToStorage();
    notifyListeners();
  }

  List<PetActivity> get activities => List.unmodifiable(_activities);
  List<Vaccination> get vaccinations => List.unmodifiable(_vaccinations);
  List<HealthReminder> get reminders => List.unmodifiable(_reminders);
  List<Expense> get expenses => List.unmodifiable(_expenses);

  Pet? getPetById(String id) {
    try {
      return _pets.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'pets',
        jsonEncode(_pets.map((pet) => pet.toJson()).toList()),
      );
      await prefs.setString(
        'activities',
        jsonEncode(_activities.map((activity) => activity.toJson()).toList()),
      );
      await prefs.setString(
        'vaccinations',
        jsonEncode(
          _vaccinations.map((vaccination) => vaccination.toJson()).toList(),
        ),
      );
      await prefs.setString(
        'reminders',
        jsonEncode(_reminders.map((reminder) => reminder.toJson()).toList()),
      );
      await prefs.setString(
        'expenses',
        jsonEncode(_expenses.map((expense) => expense.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Error saving data to storage: $e');
    }
  }

  // Pet methods
  void addPet(Pet pet) {
    _pets.add(pet);
    _saveToStorage();
    notifyListeners();
  }

  void updatePet(Pet updatedPet) {
    final int index = _pets.indexWhere((Pet pet) => pet.id == updatedPet.id);
    if (index != -1) {
      _pets[index] = updatedPet;
      _saveToStorage();
      notifyListeners();
    }
  }

  void deletePet(String petId) {
    _pets.removeWhere((Pet pet) => pet.id == petId);
    _activities.removeWhere((PetActivity activity) => activity.petId == petId);
    _vaccinations.removeWhere(
      (Vaccination vaccination) => vaccination.petId == petId,
    );
    _reminders.removeWhere(
      (HealthReminder reminder) => reminder.petId == petId,
    );
    _expenses.removeWhere((Expense expense) => expense.petId == petId);
    _saveToStorage();
    notifyListeners();
  }

  Future<void> clearAll() async {
    _pets.clear();
    _activities.clear();
    _vaccinations.clear();
    _reminders.clear();
    _expenses.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  // Activity methods
  void addActivity(PetActivity activity) {
    _activities.add(activity);
    _saveToStorage();
    notifyListeners();
  }

  void updateActivity(PetActivity updatedActivity) {
    final int index = _activities.indexWhere(
      (PetActivity activity) => activity.id == updatedActivity.id,
    );
    if (index != -1) {
      _activities[index] = updatedActivity;
      _saveToStorage();
      notifyListeners();
    }
  }

  void deleteActivity(String activityId) {
    _activities.removeWhere(
      (PetActivity activity) => activity.id == activityId,
    );
    _saveToStorage();
    notifyListeners();
  }

  List<PetActivity> getActivitiesForPet(String petId, String? category) {
    List<PetActivity> filteredActivities = _activities
        .where((PetActivity activity) => activity.petId == petId)
        .toList();
    if (category != null && category != 'allCategories') {
      filteredActivities = filteredActivities
          .where((PetActivity activity) => activity.category == category)
          .toList();
    }
    filteredActivities.sort(
      (PetActivity a, PetActivity b) => b.date.compareTo(a.date),
    );
    return filteredActivities;
  }

  // Vaccination methods
  void addVaccination(Vaccination vaccination) {
    _vaccinations.add(vaccination);
    _saveToStorage();
    notifyListeners();
  }

  void updateVaccination(Vaccination updatedVaccination) {
    final int index = _vaccinations.indexWhere(
      (Vaccination vaccination) => vaccination.id == updatedVaccination.id,
    );
    if (index != -1) {
      _vaccinations[index] = updatedVaccination;
      _saveToStorage();
      notifyListeners();
    }
  }

  void deleteVaccination(String vaccinationId) {
    _vaccinations.removeWhere(
      (Vaccination vaccination) => vaccination.id == vaccinationId,
    );
    _saveToStorage();
    notifyListeners();
  }

  List<Vaccination> getVaccinationsForPet(String petId) {
    return _vaccinations
        .where((Vaccination vaccination) => vaccination.petId == petId)
        .toList()
      ..sort(
        (Vaccination a, Vaccination b) =>
            b.vaccineDate.compareTo(a.vaccineDate),
      );
  }

  // Reminder methods
  void addReminder(HealthReminder reminder) {
    _reminders.add(reminder);
    _saveToStorage();
    notifyListeners();
  }

  void updateReminder(HealthReminder updatedReminder) {
    final int index = _reminders.indexWhere(
      (HealthReminder reminder) => reminder.id == updatedReminder.id,
    );
    if (index != -1) {
      _reminders[index] = updatedReminder;
      _saveToStorage();
      notifyListeners();
    }
  }

  void deleteReminder(String reminderId) {
    _reminders.removeWhere(
      (HealthReminder reminder) => reminder.id == reminderId,
    );
    _saveToStorage();
    notifyListeners();
  }

  List<HealthReminder> getRemindersForPet(String petId) {
    return _reminders
        .where((HealthReminder reminder) => reminder.petId == petId)
        .toList()
      ..sort(
        (HealthReminder a, HealthReminder b) =>
            a.reminderDate.compareTo(b.reminderDate),
      );
  }

  // Expense methods
  void addExpense(Expense expense) {
    _expenses.add(expense);
    _saveToStorage();
    notifyListeners();
  }

  void updateExpense(Expense updatedExpense) {
    final int index = _expenses.indexWhere(
      (Expense expense) => expense.id == updatedExpense.id,
    );
    if (index != -1) {
      _expenses[index] = updatedExpense;
      _saveToStorage();
      notifyListeners();
    }
  }

  void deleteExpense(String expenseId) {
    _expenses.removeWhere((Expense expense) => expense.id == expenseId);
    _saveToStorage();
    notifyListeners();
  }

  List<Expense> getExpensesForPet(String petId) {
    return _expenses.where((Expense expense) => expense.petId == petId).toList()
      ..sort((Expense a, Expense b) => b.date.compareTo(a.date));
  }

  double getTotalExpensesForPet(String petId) {
    return _expenses
        .where((Expense expense) => expense.petId == petId)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double getMonthlyExpensesForPet(String petId, DateTime month) {
    return _expenses
        .where(
          (Expense expense) =>
              expense.petId == petId &&
              expense.date.year == month.year &&
              expense.date.month == month.month,
        )
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }
}

enum AppColorScheme {
  defaultTheme,
  orangeTheme,
  greenTheme,
  purpleTheme,
  redTheme,
  pinkTheme,
  tealTheme,
  yellowTheme,
  cyanTheme,
  brownTheme,
}

class AppSettings extends ChangeNotifier {
  bool _isDarkMode;
  bool _notificationsEnabled;
  bool _soundEnabled;
  AppColorScheme _selectedColorScheme;
  String _selectedLanguage;

  AppSettings()
    : _isDarkMode = false,
      _notificationsEnabled = true,
      _soundEnabled = true,
      _selectedColorScheme = AppColorScheme.defaultTheme,
      _selectedLanguage = 'system' {
    _loadFromStorage();
  }

  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  AppColorScheme get selectedColorScheme => _selectedColorScheme;
  String get selectedLanguage => _selectedLanguage;

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _soundEnabled = prefs.getBool('soundEnabled') ?? true;
      _selectedColorScheme =
          AppColorScheme.values[prefs.getInt('selectedColorScheme') ?? 0];
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'system';
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
      await prefs.setBool('notificationsEnabled', _notificationsEnabled);
      await prefs.setBool('soundEnabled', _soundEnabled);
      await prefs.setInt('selectedColorScheme', _selectedColorScheme.index);
      await prefs.setString('selectedLanguage', _selectedLanguage);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  void toggleDarkMode(bool value) {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      _saveToStorage();
      notifyListeners();
    }
  }

  void toggleNotifications(bool value) {
    if (_notificationsEnabled != value) {
      _notificationsEnabled = value;
      _saveToStorage();
      notifyListeners();
    }
  }

  void toggleSound(bool value) {
    if (_soundEnabled != value) {
      _soundEnabled = value;
      _saveToStorage();
      notifyListeners();
    }
  }

  void setSelectedColorScheme(AppColorScheme colorScheme) {
    if (_selectedColorScheme != colorScheme) {
      _selectedColorScheme = colorScheme;
      _saveToStorage();
      notifyListeners();
    }
  }

  void setSelectedLanguage(String language) {
    if (_selectedLanguage != language) {
      _selectedLanguage = language;
      _saveToStorage();
      notifyListeners();
    }
  }
}

class ExploreArticle {
  final String id;
  final String titleKey;
  final String categoryKey;
  final String imageUrl;
  final String contentKey;

  ExploreArticle({
    required this.id,
    required this.titleKey,
    required this.categoryKey,
    required this.imageUrl,
    required this.contentKey,
  });
}

class ExploreData extends ChangeNotifier {
  final List<ExploreArticle> _articles = [
    ExploreArticle(
      id: 'exp_1',
      titleKey: 'healthyFeedingTips',
      categoryKey: 'dogCare',
      imageUrl:
          'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=400&h=200&fit=crop',
      contentKey: 'healthyFeedingContent',
    ),
    ExploreArticle(
      id: 'exp_2',
      titleKey: 'catHappinessTips',
      categoryKey: 'catCare',
      imageUrl:
          'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=400&h=200&fit=crop',
      contentKey: 'catHappinessContent',
    ),
    ExploreArticle(
      id: 'exp_3',
      titleKey: 'birdTrainingBasics',
      categoryKey: 'birdCare',
      imageUrl:
          'https://images.unsplash.com/photo-1552728089-57bdde30beb3?w=400&h=200&fit=crop',
      contentKey: 'birdTrainingContent',
    ),
    ExploreArticle(
      id: 'exp_4',
      titleKey: 'smallPetHabitat',
      categoryKey: 'generalCare',
      imageUrl:
          'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?w=400&h=200&fit=crop',
      contentKey: 'smallPetHabitatContent',
    ),
    ExploreArticle(
      id: 'exp_5',
      titleKey: 'commonDiseaseSymptoms',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1530041539828-114de669390e?w=400&h=200&fit=crop',
      contentKey: 'commonDiseaseSymptomsContent',
    ),
    ExploreArticle(
      id: 'exp_6',
      titleKey: 'travelingWithPets',
      categoryKey: 'lifestyle',
      imageUrl:
          'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=400&h=200&fit=crop',
      contentKey: 'travelingWithPetsContent',
    ),
    ExploreArticle(
      id: 'exp_7',
      titleKey: 'firstAidForPets',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?w=400&h=200&fit=crop',
      contentKey: 'firstAidForPetsContent',
    ),
    ExploreArticle(
      id: 'exp_8',
      titleKey: 'choosingRightPet',
      categoryKey: 'lifestyle',
      imageUrl:
          'https://images.unsplash.com/photo-1450778869180-41d0601e046e?w=400&h=200&fit=crop',
      contentKey: 'choosingRightPetContent',
    ),
    ExploreArticle(
      id: 'exp_9',
      titleKey: 'dentalCareForPets',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1601758174114-e711c0cbaa69?w=400&h=200&fit=crop',
      contentKey: 'dentalCareForPetsContent',
    ),
    ExploreArticle(
      id: 'exp_10',
      titleKey: 'socializingYourPuppy',
      categoryKey: 'dogCare',
      imageUrl:
          'https://images.unsplash.com/photo-1517849845537-4d257902454a?w=400&h=200&fit=crop',
      contentKey: 'socializingYourPuppyContent',
    ),
    ExploreArticle(
      id: 'exp_11',
      titleKey: 'litterBoxProblems',
      categoryKey: 'catCare',
      imageUrl:
          'https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?w=400&h=200&fit=crop',
      contentKey: 'litterBoxProblemsContent',
    ),
    ExploreArticle(
      id: 'exp_12',
      titleKey: 'fishAquariumSetup',
      categoryKey: 'fishCare',
      imageUrl:
          'https://images.unsplash.com/photo-1520990269656-26d97974ebca?w=400&h=200&fit=crop',
      contentKey: 'fishAquariumSetupContent',
    ),
    ExploreArticle(
      id: 'exp_13',
      titleKey: 'rabbitDiet',
      categoryKey: 'rabbitCare',
      imageUrl:
          'https://images.unsplash.com/photo-1535241749838-299277b6305f?w=400&h=200&fit=crop',
      contentKey: 'rabbitDietContent',
    ),
    ExploreArticle(
      id: 'exp_14',
      titleKey: 'introducingNewPet',
      categoryKey: 'lifestyle',
      imageUrl:
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=400&h=200&fit=crop',
      contentKey: 'introducingNewPetContent',
    ),
    ExploreArticle(
      id: 'exp_15',
      titleKey: 'winterCareTips',
      categoryKey: 'generalCare',
      imageUrl:
          'https://images.unsplash.com/photo-1542435503-956c469947f6?w=400&h=200&fit=crop',
      contentKey: 'winterCareTipsContent',
    ),
    ExploreArticle(
      id: 'exp_16',
      titleKey: 'summerSafety',
      categoryKey: 'generalCare',
      imageUrl:
          'https://images.unsplash.com/photo-1601758125946-6ec2ef64daf8?w=400&h=200&fit=crop',
      contentKey: 'summerSafetyContent',
    ),
    ExploreArticle(
      id: 'exp_17',
      titleKey: 'understandingBodyLanguage',
      categoryKey: 'behavior',
      imageUrl:
          'https://images.unsplash.com/photo-1544568100-847a948585b9?w=400&h=200&fit=crop',
      contentKey: 'understandingBodyLanguageContent',
    ),
    ExploreArticle(
      id: 'exp_18',
      titleKey: 'diyPetToys',
      categoryKey: 'lifestyle',
      imageUrl:
          'https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?w=400&h=200&fit=crop',
      contentKey: 'diyPetToysContent',
    ),
    ExploreArticle(
      id: 'exp_19',
      titleKey: 'seniorPetCare',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1558788353-f76d92427f16?w=400&h=200&fit=crop',
      contentKey: 'seniorPetCareContent',
    ),
    ExploreArticle(
      id: 'exp_20',
      titleKey: 'parasitePrevention',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1507682044626-a4b4b3900f5f?w=400&h=200&fit=crop',
      contentKey: 'parasitePreventionContent',
    ),
    ExploreArticle(
      id: 'exp_21',
      titleKey: 'groomingYourPetAtHome',
      categoryKey: 'generalCare',
      imageUrl:
          'https://images.unsplash.com/photo-1515131430684-83dcf38f0ef5?w=400&h=200&fit=crop',
      contentKey: 'groomingYourPetAtHomeContent',
    ),
    // Hamster Bakımı
    ExploreArticle(
      id: 'exp_22',
      titleKey: 'hamsterCareBasics',
      categoryKey: 'hamsterCare',
      imageUrl:
          'https://images.unsplash.com/photo-1425082661705-1834bfd09dca?w=400&h=200&fit=crop',
      contentKey: 'hamsterCareBasicsContent',
    ),
    ExploreArticle(
      id: 'exp_23',
      titleKey: 'hamsterDiet',
      categoryKey: 'hamsterCare',
      imageUrl:
          'https://images.unsplash.com/photo-1548767797-d8c844163c4c?w=400&h=200&fit=crop',
      contentKey: 'hamsterDietContent',
    ),
    // Kaplumbağa Bakımı
    ExploreArticle(
      id: 'exp_24',
      titleKey: 'turtleCareGuide',
      categoryKey: 'exoticCare',
      imageUrl:
          'https://images.unsplash.com/photo-1437622368342-7a3d73a34c8f?w=400&h=200&fit=crop',
      contentKey: 'turtleCareGuideContent',
    ),
    // Yavru Bakımı
    ExploreArticle(
      id: 'exp_25',
      titleKey: 'puppyCareGuide',
      categoryKey: 'dogCare',
      imageUrl:
          'https://images.unsplash.com/photo-1601979031925-424e53b6caaa?w=400&h=200&fit=crop',
      contentKey: 'puppyCareGuideContent',
    ),
    ExploreArticle(
      id: 'exp_26',
      titleKey: 'kittenCareGuide',
      categoryKey: 'catCare',
      imageUrl:
          'https://images.unsplash.com/photo-1574144611937-0df059b5ef3e?w=400&h=200&fit=crop',
      contentKey: 'kittenCareGuideContent',
    ),
    ExploreArticle(
      id: 'exp_27',
      titleKey: 'petNutritionGuide',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1589923188900-85dae523321c?w=400&h=200&fit=crop',
      contentKey: 'petNutritionGuideContent',
    ),
    ExploreArticle(
      id: 'exp_28',
      titleKey: 'toxicFoodsForPets',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1596492784531-6e6eb5ea9993?w=400&h=200&fit=crop',
      contentKey: 'toxicFoodsForPetsContent',
    ),
    ExploreArticle(
      id: 'exp_29',
      titleKey: 'dogExerciseGuide',
      categoryKey: 'dogCare',
      imageUrl:
          'https://images.unsplash.com/photo-1534361960057-19889db9621e?w=400&h=200&fit=crop',
      contentKey: 'dogExerciseGuideContent',
    ),
    ExploreArticle(
      id: 'exp_30',
      titleKey: 'catPlaytimeIdeas',
      categoryKey: 'catCare',
      imageUrl:
          'https://images.unsplash.com/photo-1548546738-8502ce9a3544?w=400&h=200&fit=crop',
      contentKey: 'catPlaytimeIdeasContent',
    ),
    ExploreArticle(
      id: 'exp_31',
      titleKey: 'dogBehaviorProblems',
      categoryKey: 'behavior',
      imageUrl:
          'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=400&h=200&fit=crop',
      contentKey: 'dogBehaviorProblemsContent',
    ),
    ExploreArticle(
      id: 'exp_32',
      titleKey: 'catBehaviorProblems',
      categoryKey: 'behavior',
      imageUrl:
          'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=400&h=200&fit=crop',
      contentKey: 'catBehaviorProblemsContent',
    ),
    ExploreArticle(
      id: 'exp_33',
      titleKey: 'petAllergies',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400&h=200&fit=crop',
      contentKey: 'petAllergiesContent',
    ),
    ExploreArticle(
      id: 'exp_34',
      titleKey: 'petWeightManagement',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1558947530-cbcf6e9aeeae?w=400&h=200&fit=crop',
      contentKey: 'petWeightManagementContent',
    ),
    ExploreArticle(
      id: 'exp_35',
      titleKey: 'spayNeuterBenefits',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1576086213369-97a306d36557?w=400&h=200&fit=crop',
      contentKey: 'spayNeuterBenefitsContent',
    ),
    ExploreArticle(
      id: 'exp_36',
      titleKey: 'springPetCare',
      categoryKey: 'generalCare',
      imageUrl:
          'https://images.unsplash.com/photo-1522441815192-d9f04eb0614c?w=400&h=200&fit=crop',
      contentKey: 'springPetCareContent',
    ),
    ExploreArticle(
      id: 'exp_37',
      titleKey: 'autumnPetCare',
      categoryKey: 'generalCare',
      imageUrl:
          'https://images.unsplash.com/photo-1507608830360-bb5835389f86?w=400&h=200&fit=crop',
      contentKey: 'autumnPetCareContent',
    ),
    ExploreArticle(
      id: 'exp_38',
      titleKey: 'petFriendlyHome',
      categoryKey: 'lifestyle',
      imageUrl:
          'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?w=400&h=200&fit=crop',
      contentKey: 'petFriendlyHomeContent',
    ),
    ExploreArticle(
      id: 'exp_39',
      titleKey: 'movingWithPets',
      categoryKey: 'lifestyle',
      imageUrl:
          'https://images.unsplash.com/photo-1520038410233-7141be7e6f97?w=400&h=200&fit=crop',
      contentKey: 'movingWithPetsContent',
    ),
    ExploreArticle(
      id: 'exp_40',
      titleKey: 'petsAndBabies',
      categoryKey: 'lifestyle',
      imageUrl:
          'https://images.unsplash.com/photo-1537151608828-ea2b11777ee8?w=400&h=200&fit=crop',
      contentKey: 'petsAndBabiesContent',
    ),
    ExploreArticle(
      id: 'exp_41',
      titleKey: 'basicDogCommands',
      categoryKey: 'dogCare',
      imageUrl:
          'https://images.unsplash.com/photo-1598133894008-61f7fdb8cc3a?w=400&h=200&fit=crop',
      contentKey: 'basicDogCommandsContent',
    ),
    ExploreArticle(
      id: 'exp_42',
      titleKey: 'houseTraining',
      categoryKey: 'dogCare',
      imageUrl:
          'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=400&h=200&fit=crop',
      contentKey: 'houseTrainingContent',
    ),
    ExploreArticle(
      id: 'exp_43',
      titleKey: 'birdDietGuide',
      categoryKey: 'birdCare',
      imageUrl:
          'https://images.unsplash.com/photo-1522858547137-f1dcec554f55?w=400&h=200&fit=crop',
      contentKey: 'birdDietGuideContent',
    ),
    ExploreArticle(
      id: 'exp_44',
      titleKey: 'birdHealthSigns',
      categoryKey: 'birdCare',
      imageUrl:
          'https://images.unsplash.com/photo-1444464666168-49d633b867ad?w=400&h=200&fit=crop',
      contentKey: 'birdHealthSignsContent',
    ),
    ExploreArticle(
      id: 'exp_45',
      titleKey: 'fishTankMaintenance',
      categoryKey: 'fishCare',
      imageUrl:
          'https://images.unsplash.com/photo-1544551763-47a189531981?w=400&h=200&fit=crop',
      contentKey: 'fishTankMaintenanceContent',
    ),
    ExploreArticle(
      id: 'exp_46',
      titleKey: 'fishDiseasePrevention',
      categoryKey: 'fishCare',
      imageUrl:
          'https://images.unsplash.com/photo-1524704654690-b56c05c78a00?w=400&h=200&fit=crop',
      contentKey: 'fishDiseasePreventionContent',
    ),
    ExploreArticle(
      id: 'exp_47',
      titleKey: 'rabbitHousing',
      categoryKey: 'rabbitCare',
      imageUrl:
          'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?w=400&h=200&fit=crop',
      contentKey: 'rabbitHousingContent',
    ),
    ExploreArticle(
      id: 'exp_48',
      titleKey: 'rabbitHealthGuide',
      categoryKey: 'rabbitCare',
      imageUrl:
          'https://images.unsplash.com/photo-1559214369-a6b1d7919865?w=400&h=200&fit=crop',
      contentKey: 'rabbitHealthGuideContent',
    ),
    ExploreArticle(
      id: 'exp_49',
      titleKey: 'petEmergencyKit',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1584036561566-baf8f5f1b144?w=400&h=200&fit=crop',
      contentKey: 'petEmergencyKitContent',
    ),
    ExploreArticle(
      id: 'exp_50',
      titleKey: 'emergencySigns',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400&h=200&fit=crop',
      contentKey: 'emergencySignsContent',
    ),
  ];

  List<ExploreArticle> get articles =>
      List<ExploreArticle>.unmodifiable(_articles);
}

/// MAIN NAVIGATION SCREEN
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const PetListScreen(),
    const ExploreScreen(),
    const StatisticsScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: BannerAdWidget(adSize: AdSize.fullBanner),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.pets),
            label: l10n.myPets,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: l10n.explore,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics),
            label: l10n.statistics,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  String _viewMode = 'list'; // 'list' or 'grid'

  @override
  void initState() {
    super.initState();
    _loadViewMode();
  }

  void _loadViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _viewMode = prefs.getString('pet_list_view_mode') ?? 'list';
    });
  }

  void _toggleViewMode() async {
    final newMode = _viewMode == 'list' ? 'grid' : 'list';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pet_list_view_mode', newMode);
    setState(() {
      _viewMode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myPets),
        actions: [
          IconButton(
            icon: Icon(_viewMode == 'list' ? Icons.grid_view : Icons.view_list),
            onPressed: _toggleViewMode,
            tooltip: _viewMode == 'list'
                ? l10n.viewModeGrid
                : l10n.viewModeList,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const AddEditPetScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add_circle_outline, size: 28),
        label: Text(
          l10n.addPet,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      body: Consumer<PetData>(
        builder: (BuildContext context, PetData petData, Widget? child) {
          if (petData.pets.isEmpty) {
            return _buildEmptyState(context, l10n);
          }

          if (_viewMode == 'grid') {
            return GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: petData.pets.length,
              itemBuilder: (BuildContext context, int index) {
                return _GridPetCard(pet: petData.pets[index]);
              },
            );
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: petData.pets.length,
            onReorder: (oldIndex, newIndex) {
              petData.reorderPets(oldIndex, newIndex);
            },
            itemBuilder: (BuildContext context, int index) {
              final Pet pet = petData.pets[index];
              return PetCard(key: ValueKey(pet.id), pet: pet);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  ],
                ),
              ),
              child: Icon(
                Icons.pets,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noPetsYet,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.noPetsDescription,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const AddEditPetScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.addPet),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              l10n.popularPetTypes,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildPetTypeChip('🐕 ${l10n.dog}', Colors.brown),
                _buildPetTypeChip('🐈 ${l10n.cat}', Colors.purple),
                _buildPetTypeChip('🦜 ${l10n.bird}', Colors.teal),
                _buildPetTypeChip('🐠 ${l10n.fish}', Colors.blue),
                _buildPetTypeChip('🐰 ${l10n.rabbit}', Colors.green),
                _buildPetTypeChip('🐹 ${l10n.hamster}', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetTypeChip(String label, Color color) {
    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }
}

class _GridPetCard extends StatelessWidget {
  final Pet pet;

  const _GridPetCard({required this.pet});

  @override
  Widget build(BuildContext context) {
    final petColor = _getPetTypeColor(pet.type);
    final petEmoji = _getPetEmoji(pet.type);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: petColor.withOpacity(0.3)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => PetDetailScreen(pet: pet),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image(
                      image: _getPetImageProvider(pet.photoUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: petColor.withOpacity(0.1),
                          child: Center(
                            child: Text(
                              petEmoji,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        petEmoji,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pet.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pet.breed ?? pet.type,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _getPetTypeColor(String petType) {
  switch (petType.toLowerCase()) {
    case 'dog':
    case 'köpek':
      return Colors.brown;
    case 'cat':
    case 'kedi':
      return Colors.purple;
    case 'bird':
    case 'kuş':
      return Colors.teal;
    case 'rabbit':
    case 'tavşan':
      return Colors.green;
    case 'fish':
    case 'balık':
      return Colors.blue;
    case 'hamster':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}

String _getPetEmoji(String petType) {
  switch (petType.toLowerCase()) {
    case 'dog':
    case 'köpek':
      return '🐕';
    case 'cat':
    case 'kedi':
      return '🐈';
    case 'bird':
    case 'kuş':
      return '🦜';
    case 'rabbit':
    case 'tavşan':
      return '🐰';
    case 'fish':
    case 'balık':
      return '🐠';
    case 'hamster':
      return '🐹';
    default:
      return '🐾';
  }
}

ImageProvider _getPetImageProvider(String photoUrl) {
  if (photoUrl.startsWith('http')) {
    return NetworkImage(photoUrl);
  } else if (photoUrl.isEmpty || photoUrl.contains('placeholder')) {
    // Return a dummy transparent image or common placeholder
    return const NetworkImage(
      'https://via.placeholder.com/300x300.png?text=Pet+Photo',
    );
  } else {
    return FileImage(File(photoUrl));
  }
}

class PetCard extends StatelessWidget {
  final Pet pet;

  const PetCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final petColor = _getPetTypeColor(pet.type);
    final petEmoji = _getPetEmoji(pet.type);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: petColor, width: 3.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => PetDetailScreen(pet: pet),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: LinearGradient(
              colors: [petColor.withValues(alpha: 0.05), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: petColor.withValues(alpha: 0.2),
                      backgroundImage: _getPetImageProvider(pet.photoUrl),
                      onBackgroundImageError: (exception, stackTrace) {},
                      child: pet.photoUrl.contains('placeholder')
                          ? Text(petEmoji, style: const TextStyle(fontSize: 35))
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: petColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          petEmoji,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${getPetTypeTranslation(context, pet.type)} ${pet.breed != null ? '• ${pet.breed}' : ''}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (pet.birthDate != null)
                        Text(
                          '${l10n.age}: ${pet.ageInYears} ${l10n.years}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    _getHealthStatusIcon(pet.healthStatus),
                    const SizedBox(height: 8),
                    PopupMenuButton<String>(
                      onSelected: (String value) {
                        if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  AddEditPetScreen(pet: pet),
                            ),
                          );
                        } else if (value == 'delete') {
                          _showDeleteConfirmation(context, pet);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(Icons.edit),
                              const SizedBox(width: 8),
                              Text(l10n.edit),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(Icons.delete, color: Colors.red),
                              const SizedBox(width: 8),
                              Text(
                                l10n.delete,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getHealthStatusIcon(String status) {
    IconData icon;
    Color color;

    switch (status) {
      case 'excellent':
        icon = Icons.favorite;
        color = Colors.green;
        break;
      case 'good':
        icon = Icons.favorite_border;
        color = Colors.blue;
        break;
      case 'fair':
        icon = Icons.warning;
        color = Colors.orange;
        break;
      case 'poor':
        icon = Icons.error;
        color = Colors.red;
        break;
      default:
        icon = Icons.help;
        color = Colors.grey;
    }

    return Icon(icon, color: color, size: 20);
  }

  void _showDeleteConfirmation(BuildContext context, Pet pet) {
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.delete),
          content: Text(l10n.deletePetConfirmation(pet.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Provider.of<PetData>(context, listen: false).deletePet(pet.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.deleteSuccess)));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }
}

/// ADD/EDIT PET SCREEN
class AddEditPetScreen extends StatefulWidget {
  final Pet? pet;

  const AddEditPetScreen({super.key, this.pet});

  @override
  State<AddEditPetScreen> createState() => _AddEditPetScreenState();
}

class _AddEditPetScreenState extends State<AddEditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _nationalIdController;
  late TextEditingController _veterinarianNameController;
  late TextEditingController _veterinarianContactController;
  late TextEditingController _notesController;
  late TextEditingController _weightController;
  late TextEditingController _microchipIdController;
  late TextEditingController _insuranceController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _medicalHistoryController;
  late TextEditingController _allergiesController;
  late TextEditingController _currentMedicationsController;
  late TextEditingController _colorController;
  late TextEditingController _dietaryRequirementsController;
  late TextEditingController _favoriteToysController;
  late TextEditingController _behavioralNotesController;
  late TextEditingController _passportNumberController;
  late TextEditingController _ownerNameController;
  late TextEditingController _ownerContactController;
  late TextEditingController _customTypeController;

  String _selectedType = 'dog';
  String _selectedGender = 'unknown';
  String _selectedHealthStatus = 'good';
  String _selectedTrainingLevel = 'beginner';
  String _selectedActivityLevel = 'moderate';
  bool _isSpayedOrNeutered = false;
  DateTime? _birthDate;
  DateTime? _nextAppointment;
  DateTime? _adoptionDate;
  DateTime? _lastVetVisit;
  String _photoUrl = 'https://via.placeholder.com/300x300.png?text=Pet+Photo';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet?.name ?? '');
    _breedController = TextEditingController(text: widget.pet?.breed ?? '');
    _nationalIdController = TextEditingController(
      text: widget.pet?.nationalId ?? '',
    );
    _veterinarianNameController = TextEditingController(
      text: widget.pet?.veterinarianName ?? '',
    );
    _veterinarianContactController = TextEditingController(
      text: widget.pet?.veterinarianContact ?? '',
    );
    _notesController = TextEditingController(text: widget.pet?.notes ?? '');
    _weightController = TextEditingController(
      text: widget.pet?.weight?.toString() ?? '',
    );
    _microchipIdController = TextEditingController(
      text: widget.pet?.microchipId ?? '',
    );
    _insuranceController = TextEditingController(
      text: widget.pet?.insurance ?? '',
    );
    _emergencyContactController = TextEditingController(
      text: widget.pet?.emergencyContact ?? '',
    );
    _medicalHistoryController = TextEditingController(
      text: widget.pet?.medicalHistory ?? '',
    );
    _allergiesController = TextEditingController(
      text: widget.pet?.allergies ?? '',
    );
    _currentMedicationsController = TextEditingController(
      text: widget.pet?.currentMedications ?? '',
    );
    _colorController = TextEditingController(text: widget.pet?.color ?? '');
    _dietaryRequirementsController = TextEditingController(
      text: widget.pet?.dietaryRequirements ?? '',
    );
    _favoriteToysController = TextEditingController(
      text: widget.pet?.favoriteToys ?? '',
    );
    _behavioralNotesController = TextEditingController(
      text: widget.pet?.behavioralNotes ?? '',
    );
    _passportNumberController = TextEditingController(
      text: widget.pet?.passportNumber ?? '',
    );
    _ownerNameController = TextEditingController(
      text: widget.pet?.ownerName ?? '',
    );
    _ownerContactController = TextEditingController(
      text: widget.pet?.ownerContact ?? '',
    );
    _customTypeController = TextEditingController();

    if (widget.pet != null) {
      _selectedType = widget.pet!.type;
      final List<String> predefinedTypes = [
        'dog',
        'cat',
        'bird',
        'rabbit',
        'hamster',
        'fish',
      ];
      if (!predefinedTypes.contains(_selectedType) &&
          _selectedType != 'other') {
        _customTypeController.text = _selectedType;
        _selectedType = 'other';
      }
      _selectedGender = widget.pet!.gender ?? 'unknown';
      _selectedHealthStatus = widget.pet!.healthStatus;
      _selectedTrainingLevel = widget.pet!.trainingLevel ?? 'beginner';
      _selectedActivityLevel = widget.pet!.activityLevel ?? 'moderate';
      _isSpayedOrNeutered = widget.pet!.isSpayedOrNeutered ?? false;
      _birthDate = widget.pet!.birthDate;
      _nextAppointment = widget.pet!.nextAppointment;
      _adoptionDate = widget.pet!.adoptionDate;
      _lastVetVisit = widget.pet!.lastVetVisit;
      _photoUrl = widget.pet!.photoUrl;
    } else {
      // If it's a new pet, check for draft
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkDraft();
      });
    }

    // Add listeners to controllers to save draft
    _nameController.addListener(_autoSaveDraft);
    _breedController.addListener(_autoSaveDraft);
    _notesController.addListener(_autoSaveDraft);
  }

  void _checkDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final l10n = AppLocalizations.of(context)!;
    if (prefs.containsKey('pet_draft_name') ||
        prefs.containsKey('pet_draft_breed')) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.draftFound),
          content: Text(l10n.draftResumeQuestion),
          actions: [
            TextButton(
              onPressed: () {
                _clearDraft();
                Navigator.pop(context);
              },
              child: Text(l10n.noDelete),
            ),
            TextButton(
              onPressed: () {
                _loadDraft();
                Navigator.pop(context);
              },
              child: Text(l10n.yesResume),
            ),
          ],
        ),
      );
    }
  }

  void _autoSaveDraft() {
    if (widget.pet == null) {
      _saveDraft();
    }
  }

  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pet_draft_name', _nameController.text);
    await prefs.setString('pet_draft_breed', _breedController.text);
    await prefs.setString('pet_draft_type', _selectedType);
    await prefs.setString('pet_draft_photo', _photoUrl);
    await prefs.setString('pet_draft_notes', _notesController.text);
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('pet_draft_name') ?? '';
      _breedController.text = prefs.getString('pet_draft_breed') ?? '';
      _selectedType = prefs.getString('pet_draft_type') ?? 'dog';
      _photoUrl =
          prefs.getString('pet_draft_photo') ??
          'https://via.placeholder.com/300x300.png?text=Pet+Photo';
      _notesController.text = prefs.getString('pet_draft_notes') ?? '';
    });
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pet_draft_name');
    await prefs.remove('pet_draft_breed');
    await prefs.remove('pet_draft_type');
    await prefs.remove('pet_draft_photo');
    await prefs.remove('pet_draft_notes');
  }

  @override
  void dispose() {
    _nameController.removeListener(_autoSaveDraft);
    _breedController.removeListener(_autoSaveDraft);
    _notesController.removeListener(_autoSaveDraft);
    _nameController.dispose();
    _breedController.dispose();
    _nationalIdController.dispose();
    _veterinarianNameController.dispose();
    _veterinarianContactController.dispose();
    _notesController.dispose();
    _weightController.dispose();
    _microchipIdController.dispose();
    _insuranceController.dispose();
    _emergencyContactController.dispose();
    _medicalHistoryController.dispose();
    _allergiesController.dispose();
    _currentMedicationsController.dispose();
    _colorController.dispose();
    _dietaryRequirementsController.dispose();
    _favoriteToysController.dispose();
    _behavioralNotesController.dispose();
    _passportNumberController.dispose();
    _ownerNameController.dispose();
    _ownerContactController.dispose();
    _customTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.pet != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.edit : l10n.addPet),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: FilledButton.icon(
              onPressed: () {
                _savePet();
                if (!isEditing) _clearDraft();
              },
              icon: const Icon(Icons.save, size: 20),
              label: Text(
                l10n.save,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: [
            // Photo section
            const SizedBox(height: 16),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipOval(
                        child: GestureDetector(
                          onTap: _selectImage,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Image(
                              key: ValueKey(_photoUrl),
                              image: _getPetImageProvider(_photoUrl),
                              fit: BoxFit.cover,
                              width: 130,
                              height: 130,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.pets,
                                    size: 60,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      radius: 22,
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 22,
                          color: Colors.white,
                        ),
                        onPressed: _selectImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Name (Always visible)
            _buildFormField(
              controller: _nameController,
              label: l10n.petName,
              icon: Icons.badge,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterPetName;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Basic Information Accordion
            Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: true,
                leading: Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  l10n.basicInformation,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                childrenPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 8,
                ),
                children: [
                  _buildDropdownField<String>(
                    label: l10n.petType,
                    value: _selectedType,
                    icon: Icons.category,
                    items: [
                      DropdownMenuItem(
                        value: 'dog',
                        child: Text('🐾 ${l10n.dog}'),
                      ),
                      DropdownMenuItem(
                        value: 'cat',
                        child: Text('🐾 ${l10n.cat}'),
                      ),
                      DropdownMenuItem(
                        value: 'bird',
                        child: Text('🐾 ${l10n.bird}'),
                      ),
                      DropdownMenuItem(
                        value: 'rabbit',
                        child: Text('🐾 ${l10n.rabbit}'),
                      ),
                      DropdownMenuItem(
                        value: 'hamster',
                        child: Text('🐾 ${l10n.hamster}'),
                      ),
                      DropdownMenuItem(
                        value: 'fish',
                        child: Text('🐾 ${l10n.fish}'),
                      ),
                      DropdownMenuItem(
                        value: 'other',
                        child: Text('🐾 ${l10n.other}'),
                      ),
                    ],
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _selectedType = value;
                        });
                        _saveDraft();
                      }
                    },
                  ),
                  if (_selectedType == 'other') ...[
                    const SizedBox(height: 16),
                    _buildFormField(
                      controller: _customTypeController,
                      label: l10n.petType,
                      icon: Icons.edit_note,
                      hintText: l10n.other,
                    ),
                  ],
                  const SizedBox(height: 16),
                  _buildFormField(
                    controller: _breedController,
                    label: l10n.breed,
                    icon: Icons.pets,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    controller: _colorController,
                    label: l10n.color,
                    icon: Icons.palette,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField<String>(
                    label: l10n.gender,
                    value: _selectedGender,
                    icon: Icons.wc,
                    items: [
                      DropdownMenuItem(value: 'male', child: Text(l10n.male)),
                      DropdownMenuItem(
                        value: 'female',
                        child: Text(l10n.female),
                      ),
                      DropdownMenuItem(
                        value: 'unknown',
                        child: Text(l10n.unknown),
                      ),
                    ],
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _selectedGender = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SwitchListTile(
                      title: Text(
                        l10n.spayedOrNeutered,
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: _isSpayedOrNeutered,
                      dense: true,
                      activeThumbColor: Theme.of(context).colorScheme.primary,
                      onChanged: (bool value) {
                        setState(() {
                          _isSpayedOrNeutered = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Date Selection
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateTile(
                          label: l10n.birthDate,
                          date: _birthDate,
                          onTap: _selectBirthDate,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDateTile(
                          label: l10n.adoptionDate,
                          date: _adoptionDate,
                          onTap: _selectAdoptionDate,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    controller: _weightController,
                    label: '${l10n.weight} (${l10n.kg})',
                    icon: Icons.monitor_weight,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Health Information Accordion
            Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: Icon(
                  Icons.healing,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  l10n.healthStatus,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                childrenPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 8,
                ),
                children: [
                  _buildDropdownField<String>(
                    label: l10n.healthStatus,
                    value: _selectedHealthStatus,
                    icon: Icons.health_and_safety,
                    items: [
                      DropdownMenuItem(
                        value: 'excellent',
                        child: Text(l10n.excellent),
                      ),
                      DropdownMenuItem(value: 'good', child: Text(l10n.good)),
                      DropdownMenuItem(value: 'fair', child: Text(l10n.fair)),
                      DropdownMenuItem(value: 'poor', child: Text(l10n.poor)),
                    ],
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _selectedHealthStatus = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    controller: _veterinarianNameController,
                    label: l10n.veterinarianName,
                    icon: Icons.person_search,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    controller: _veterinarianContactController,
                    label: l10n.veterinarianContact,
                    icon: Icons.contact_phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateTile(
                          label: l10n.lastVetVisit,
                          date: _lastVetVisit,
                          onTap: _selectLastVetVisit,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDateTile(
                          label: l10n.nextAppointment,
                          date: _nextAppointment,
                          onTap: _selectNextAppointment,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Behavior & Training Accordion
            Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: Icon(
                  Icons.psychology,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  l10n.behavioralNotes,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                childrenPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 8,
                ),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField<String>(
                          label: l10n.trainingLevel,
                          value: _selectedTrainingLevel,
                          icon: Icons.school,
                          items: [
                            DropdownMenuItem(
                              value: 'beginner',
                              child: Text(l10n.beginner),
                            ),
                            DropdownMenuItem(
                              value: 'intermediate',
                              child: Text(l10n.intermediate),
                            ),
                            DropdownMenuItem(
                              value: 'advanced',
                              child: Text(l10n.advanced),
                            ),
                          ],
                          onChanged: (String? value) {
                            if (value != null) {
                              setState(() {
                                _selectedTrainingLevel = value;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField<String>(
                          label: l10n.activityLevel,
                          value: _selectedActivityLevel,
                          icon: Icons.directions_run,
                          items: [
                            DropdownMenuItem(
                              value: 'low',
                              child: Text(l10n.low),
                            ),
                            DropdownMenuItem(
                              value: 'moderate',
                              child: Text(l10n.moderate),
                            ),
                            DropdownMenuItem(
                              value: 'high',
                              child: Text(l10n.high),
                            ),
                          ],
                          onChanged: (String? value) {
                            if (value != null) {
                              setState(() {
                                _selectedActivityLevel = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    controller: _favoriteToysController,
                    label: l10n.favoriteToys,
                    icon: Icons.toys,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    controller: _behavioralNotesController,
                    label: l10n.behavioralNotes,
                    icon: Icons.notes,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Owner & Additional Info Accordion
            Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: Icon(
                  Icons.more_horiz,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  l10n.additionalInfo,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                childrenPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 8,
                ),
                children: [
                  _buildFormField(
                    controller: _ownerNameController,
                    label: l10n.ownerName,
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    controller: _notesController,
                    label: l10n.notes,
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100), // Space for bottom
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T value,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _buildDateTile({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Text(
                  date != null
                      ? DateFormat('dd/MM/yyyy').format(date)
                      : l10n.selectDate,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _selectImage() async {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(l10n.takePicture),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(l10n.chooseFromGallery),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        // Save image permanently
        final directory = await getApplicationDocumentsDirectory();
        final fileName = p.basename(image.path);
        final permanentPath = p.join(directory.path, fileName);
        await File(image.path).copy(permanentPath);

        setState(() {
          _photoUrl = permanentPath;
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorSelectingImage(e.toString()))),
        );
      }
    }
  }

  void _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  void _selectNextAppointment() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _nextAppointment ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _nextAppointment) {
      setState(() {
        _nextAppointment = picked;
      });
    }
  }

  void _selectAdoptionDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _adoptionDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _adoptionDate) {
      setState(() {
        _adoptionDate = picked;
      });
    }
  }

  void _selectLastVetVisit() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _lastVetVisit ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _lastVetVisit) {
      setState(() {
        _lastVetVisit = picked;
      });
    }
  }

  void _savePet() {
    if (_formKey.currentState!.validate()) {
      String finalType = _selectedType;
      if (_selectedType == 'other' && _customTypeController.text.isNotEmpty) {
        finalType = _customTypeController.text;
      }

      final pet = Pet(
        id: widget.pet?.id ?? 'pet_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        type: finalType,
        breed: _breedController.text.isEmpty ? null : _breedController.text,
        birthDate: _birthDate,
        photoUrl: _photoUrl,
        nationalId: _nationalIdController.text.isEmpty
            ? null
            : _nationalIdController.text,
        veterinarianName: _veterinarianNameController.text.isEmpty
            ? null
            : _veterinarianNameController.text,
        veterinarianContact: _veterinarianContactController.text.isEmpty
            ? null
            : _veterinarianContactController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        gender: _selectedGender,
        weight: _weightController.text.isEmpty
            ? null
            : double.tryParse(_weightController.text),
        microchipId: _microchipIdController.text.isEmpty
            ? null
            : _microchipIdController.text,
        insurance: _insuranceController.text.isEmpty
            ? null
            : _insuranceController.text,
        emergencyContact: _emergencyContactController.text.isEmpty
            ? null
            : _emergencyContactController.text,
        medicalHistory: _medicalHistoryController.text.isEmpty
            ? null
            : _medicalHistoryController.text,
        allergies: _allergiesController.text.isEmpty
            ? null
            : _allergiesController.text,
        currentMedications: _currentMedicationsController.text.isEmpty
            ? null
            : _currentMedicationsController.text,
        nextAppointment: _nextAppointment,
        healthStatus: _selectedHealthStatus,
        color: _colorController.text.isEmpty ? null : _colorController.text,
        isSpayedOrNeutered: _isSpayedOrNeutered,
        adoptionDate: _adoptionDate,
        trainingLevel: _selectedTrainingLevel,
        activityLevel: _selectedActivityLevel,
        dietaryRequirements: _dietaryRequirementsController.text.isEmpty
            ? null
            : _dietaryRequirementsController.text,
        favoriteToys: _favoriteToysController.text.isEmpty
            ? null
            : _favoriteToysController.text,
        behavioralNotes: _behavioralNotesController.text.isEmpty
            ? null
            : _behavioralNotesController.text,
        lastVetVisit: _lastVetVisit,
        passportNumber: _passportNumberController.text.isEmpty
            ? null
            : _passportNumberController.text,
        ownerName: _ownerNameController.text.isEmpty
            ? null
            : _ownerNameController.text,
        ownerContact: _ownerContactController.text.isEmpty
            ? null
            : _ownerContactController.text,
      );

      final petData = Provider.of<PetData>(context, listen: false);
      if (widget.pet != null) {
        petData.updatePet(pet);
      } else {
        petData.addPet(pet);
      }

      Navigator.pop(context);
    }
  }
}

/// PET DETAIL SCREEN
class PetDetailScreen extends StatefulWidget {
  final Pet pet;

  const PetDetailScreen({super.key, required this.pet});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      AddEditPetScreen(pet: widget.pet),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(
              text: l10n.petDetails,
              icon: Text(
                _getPetEmoji(widget.pet.type),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Tab(text: l10n.activities, icon: const Icon(Icons.event_note)),
            Tab(text: l10n.vaccinationRecord, icon: const Icon(Icons.vaccines)),
            Tab(text: l10n.healthReminders, icon: const Icon(Icons.alarm)),
            Tab(text: l10n.expenses, icon: const Icon(Icons.payments)),
            Tab(text: l10n.petSimulation, icon: const Icon(Icons.analytics)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDetailsTab(),
          _buildActivitiesTab(),
          _buildVaccinationsTab(),
          _buildRemindersTab(),
          _buildExpensesTab(),
          _buildSimulationTab(),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: _getPetImageProvider(widget.pet.photoUrl),
              onBackgroundImageError: (exception, stackTrace) {},
              child: widget.pet.photoUrl.contains('placeholder')
                  ? Icon(Icons.pets, size: 60, color: Colors.grey[600])
                  : null,
            ),
          ),
          const SizedBox(height: 24),

          _buildInfoCard(l10n.basicInfo, [
            _buildInfoRow(l10n.petName, widget.pet.name),
            _buildInfoRow(
              l10n.petType,
              getPetTypeTranslation(context, widget.pet.type),
            ),
            if (widget.pet.breed != null)
              _buildInfoRow(l10n.breed, widget.pet.breed!),
            if (widget.pet.color != null)
              _buildInfoRow(l10n.color, widget.pet.color!),
            if (widget.pet.gender != null)
              _buildInfoRow(
                l10n.gender,
                _getGenderTranslation(context, widget.pet.gender!),
              ),
            if (widget.pet.isSpayedOrNeutered != null)
              _buildInfoRow(
                l10n.spayedOrNeutered,
                widget.pet.isSpayedOrNeutered! ? l10n.yes : l10n.no,
              ),
            if (widget.pet.birthDate != null)
              _buildInfoRow(
                l10n.birthDate,
                DateFormat('dd/MM/yyyy').format(widget.pet.birthDate!),
              ),
            if (widget.pet.birthDate != null)
              _buildInfoRow(l10n.age, '${widget.pet.ageInYears} ${l10n.years}'),
            if (widget.pet.adoptionDate != null)
              _buildInfoRow(
                l10n.adoptionDate,
                DateFormat('dd/MM/yyyy').format(widget.pet.adoptionDate!),
              ),
            if (widget.pet.weight != null)
              _buildInfoRow(l10n.weight, '${widget.pet.weight} ${l10n.kg}'),
          ]),

          const SizedBox(height: 16),

          _buildInfoCard(l10n.healthInfo, [
            _buildInfoRow(
              l10n.healthStatus,
              _getHealthStatusTranslation(context, widget.pet.healthStatus),
            ),
            if (widget.pet.veterinarianName != null)
              _buildInfoRow(
                l10n.veterinarianName,
                widget.pet.veterinarianName!,
              ),
            if (widget.pet.veterinarianContact != null)
              _buildInfoRow(
                l10n.veterinarianContact,
                widget.pet.veterinarianContact!,
              ),
            if (widget.pet.lastVetVisit != null)
              _buildInfoRow(
                l10n.lastVetVisit,
                DateFormat('dd/MM/yyyy').format(widget.pet.lastVetVisit!),
              ),
            if (widget.pet.nextAppointment != null)
              _buildInfoRow(
                l10n.nextAppointment,
                DateFormat('dd/MM/yyyy').format(widget.pet.nextAppointment!),
              ),
            if (widget.pet.medicalHistory != null)
              _buildInfoRow(l10n.medicalHistory, widget.pet.medicalHistory!),
            if (widget.pet.allergies != null)
              _buildInfoRow(l10n.allergies, widget.pet.allergies!),
            if (widget.pet.currentMedications != null)
              _buildInfoRow(
                l10n.currentMedications,
                widget.pet.currentMedications!,
              ),
          ]),

          const SizedBox(height: 16),

          _buildInfoCard(l10n.behaviorAndTraining, [
            if (widget.pet.trainingLevel != null)
              _buildInfoRow(
                l10n.trainingLevel,
                _getTrainingLevelTranslation(
                  context,
                  widget.pet.trainingLevel!,
                ),
              ),
            if (widget.pet.activityLevel != null)
              _buildInfoRow(
                l10n.activityLevel,
                _getActivityLevelTranslation(
                  context,
                  widget.pet.activityLevel!,
                ),
              ),
            if (widget.pet.favoriteToys != null)
              _buildInfoRow(l10n.favoriteToys, widget.pet.favoriteToys!),
            if (widget.pet.behavioralNotes != null)
              _buildInfoRow(l10n.behavioralNotes, widget.pet.behavioralNotes!),
          ]),

          const SizedBox(height: 16),

          _buildInfoCard(l10n.dietAndCare, [
            if (widget.pet.dietaryRequirements != null)
              _buildInfoRow(
                l10n.dietaryRequirements,
                widget.pet.dietaryRequirements!,
              ),
          ]),

          const SizedBox(height: 16),

          _buildInfoCard(l10n.additionalInfo, [
            if (widget.pet.nationalId != null)
              _buildInfoRow(l10n.nationalId, widget.pet.nationalId!),
            if (widget.pet.passportNumber != null)
              _buildInfoRow(l10n.passportNumber, widget.pet.passportNumber!),
            if (widget.pet.microchipId != null)
              _buildInfoRow(l10n.microchipId, widget.pet.microchipId!),
            if (widget.pet.insurance != null)
              _buildInfoRow(l10n.insurance, widget.pet.insurance!),
            if (widget.pet.emergencyContact != null)
              _buildInfoRow(
                l10n.emergencyContact,
                widget.pet.emergencyContact!,
              ),
            if (widget.pet.notes != null)
              _buildInfoRow(l10n.notes, getLocalizedContent(context, widget.pet.notes!)),
          ]),

          const SizedBox(height: 16),

          _buildInfoCard(l10n.ownerInfo, [
            if (widget.pet.ownerName != null)
              _buildInfoRow(l10n.ownerName, widget.pet.ownerName!),
            if (widget.pet.ownerContact != null)
              _buildInfoRow(l10n.ownerContact, widget.pet.ownerContact!),
          ]),
        ],
      ),
    );
  }

  String _getTrainingLevelTranslation(BuildContext context, String level) {
    final l10n = AppLocalizations.of(context)!;
    switch (level.toLowerCase()) {
      case 'beginner':
        return l10n.beginner;
      case 'intermediate':
        return l10n.intermediate;
      case 'advanced':
        return l10n.advanced;
      default:
        return level;
    }
  }

  String _getActivityLevelTranslation(BuildContext context, String level) {
    final l10n = AppLocalizations.of(context)!;
    switch (level.toLowerCase()) {
      case 'low':
        return l10n.low;
      case 'moderate':
        return l10n.moderate;
      case 'high':
        return l10n.high;
      default:
        return level;
    }
  }

  Widget _buildActivitiesTab() {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<PetData>(
      builder: (BuildContext context, PetData petData, Widget? child) {
        final activities = petData.getActivitiesForPet(widget.pet.id, null);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          AddEditActivityScreen(petId: widget.pet.id),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.addActivity),
              ),
            ),
            Expanded(
              child: activities.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_note,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noActivitiesFound,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: activities.length,
                      itemBuilder: (BuildContext context, int index) {
                        final activity = activities[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            leading: _getActivityIcon(activity.category),
                            title: Text(
                              _getCategoryTranslation(
                                context,
                                activity.category,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getLocalizedContent(context, activity.description)),
                                Text(
                                  DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(activity.date),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            trailing: activity.cost != null
                                ? Text('${l10n.currencySymbol}${activity.cost!.toStringAsFixed(2)}')
                                : null,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      AddEditActivityScreen(
                                        petId: widget.pet.id,
                                        activity: activity,
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVaccinationsTab() {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<PetData>(
      builder: (BuildContext context, PetData petData, Widget? child) {
        final vaccinations = petData.getVaccinationsForPet(widget.pet.id);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          AddEditVaccinationScreen(petId: widget.pet.id),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.addVaccination),
              ),
            ),
            Expanded(
              child: vaccinations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.vaccines,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noVaccinationsFound,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: vaccinations.length,
                      itemBuilder: (BuildContext context, int index) {
                        final vaccination = vaccinations[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            leading: const Icon(
                              Icons.vaccines,
                              color: Colors.green,
                            ),
                            title: Text(vaccination.vaccineName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${l10n.vaccineDate}: ${DateFormat('dd/MM/yyyy').format(vaccination.vaccineDate)}',
                                ),
                                if (vaccination.nextDueDate != null)
                                  Text(
                                    '${l10n.nextDueDate}: ${DateFormat('dd/MM/yyyy').format(vaccination.nextDueDate!)}',
                                  ),
                                if (vaccination.veterinarian != null)
                                  Text(
                                    '${l10n.veterinarian}: ${vaccination.veterinarian}',
                                  ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      AddEditVaccinationScreen(
                                        petId: widget.pet.id,
                                        vaccination: vaccination,
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRemindersTab() {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<PetData>(
      builder: (BuildContext context, PetData petData, Widget? child) {
        final reminders = petData.getRemindersForPet(widget.pet.id);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          AddEditReminderScreen(petId: widget.pet.id),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.addReminder),
              ),
            ),
            Expanded(
              child: reminders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noRemindersFound,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: reminders.length,
                      itemBuilder: (BuildContext context, int index) {
                        final reminder = reminders[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            leading: Icon(
                              reminder.isActive
                                  ? Icons.notifications_active
                                  : Icons.notifications_off,
                              color: reminder.isActive
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            title: Text(reminder.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${DateFormat('dd/MM/yyyy').format(reminder.reminderDate)} ${reminder.reminderTime.format(context)}',
                                ),
                                Text(
                                  '${l10n.repeatReminder}: ${_getRepeatTypeTranslation(context, reminder.repeatType)}',
                                ),
                              ],
                            ),
                            trailing: Switch(
                              value: reminder.isActive,
                              onChanged: (bool value) {
                                final updatedReminder = HealthReminder(
                                  id: reminder.id,
                                  petId: reminder.petId,
                                  title: reminder.title,
                                  reminderDate: reminder.reminderDate,
                                  reminderTime: reminder.reminderTime,
                                  repeatType: reminder.repeatType,
                                  isActive: value,
                                );
                                petData.updateReminder(updatedReminder);
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      AddEditReminderScreen(
                                        petId: widget.pet.id,
                                        reminder: reminder,
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExpensesTab() {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<PetData>(
      builder: (BuildContext context, PetData petData, Widget? child) {
        final expenses = petData.getExpensesForPet(widget.pet.id);
        final totalExpenses = petData.getTotalExpensesForPet(widget.pet.id);

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.totalExpenses,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${l10n.currencySymbol}${totalExpenses.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              AddEditExpenseScreen(petId: widget.pet.id),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addExpense),
                  ),
                ],
              ),
            ),
            Expanded(
              child: expenses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noExpensesFound,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: expenses.length,
                      itemBuilder: (BuildContext context, int index) {
                        final expense = expenses[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            leading: _getExpenseCategoryIcon(expense.category),
                            title: Text(getLocalizedContent(context, expense.description)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getExpenseCategoryTranslation(
                                    context,
                                    expense.category,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(expense.date),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            trailing: Text(
                              '${l10n.currencySymbol}${expense.amount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      AddEditExpenseScreen(
                                        petId: widget.pet.id,
                                        expense: expense,
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSimulationTab() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSimulationCard(
            context,
            l10n.humanAge,
            widget.pet.humanAge,
            Icons.person,
            Colors.blue,
            l10n.years,
          ),
          const SizedBox(height: 12),
          _buildSimulationCard(
            context,
            l10n.dailyCalories,
            widget.pet.dailyCalories,
            Icons.restaurant,
            Colors.orange,
            'kcal',
          ),
          const SizedBox(height: 12),
          _buildSimulationCard(
            context,
            l10n.waterRequirement,
            widget.pet.waterRequirement,
            Icons.water_drop,
            Colors.lightBlue,
            'ml',
          ),
          const SizedBox(height: 24),
          Card(
            color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.simulationDisclaimer,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulationCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String unit,
  ) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(unit, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  }

  String _getGenderTranslation(BuildContext context, String gender) {
    final l10n = AppLocalizations.of(context)!;
    switch (gender) {
      case 'male':
        return l10n.male;
      case 'female':
        return l10n.female;
      default:
        return l10n.unknown;
    }
  }

  String _getHealthStatusTranslation(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case 'excellent':
        return l10n.excellent;
      case 'good':
        return l10n.good;
      case 'fair':
        return l10n.fair;
      case 'poor':
        return l10n.poor;
      default:
        return l10n.unknown;
    }
  }

  String _getCategoryTranslation(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'veterinaryVisit':
        return l10n.veterinaryVisit;
      case 'feeding':
        return l10n.feeding;
      case 'vaccination':
        return l10n.vaccination;
      case 'grooming':
        return l10n.grooming;
      case 'walk':
        return l10n.walk;
      case 'cageCleaning':
        return l10n.cageCleaning;
      case 'training':
        return l10n.training;
      case 'medication':
        return l10n.medication;
      default:
        return category;
    }
  }

  String _getRepeatTypeTranslation(BuildContext context, String repeatType) {
    final l10n = AppLocalizations.of(context)!;
    switch (repeatType) {
      case 'daily':
        return l10n.daily;
      case 'weekly':
        return l10n.weekly;
      case 'monthly':
        return l10n.monthly;
      case 'yearly':
        return l10n.yearly;
      default:
        return l10n.never;
    }
  }

  String _getExpenseCategoryTranslation(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'food':
        return l10n.food;
      case 'medical':
        return l10n.medical;
      case 'toys':
        return l10n.toys;
      case 'accessories':
        return l10n.accessories;
      default:
        return category;
    }
  }

  Widget _getActivityIcon(String category) {
    switch (category) {
      case 'veterinaryVisit':
        return const Icon(Icons.local_hospital, color: Colors.red);
      case 'feeding':
        return const Icon(Icons.restaurant, color: Colors.orange);
      case 'vaccination':
        return const Icon(Icons.vaccines, color: Colors.green);
      case 'grooming':
        return const Icon(Icons.content_cut, color: Colors.blue);
      case 'walk':
        return const Icon(Icons.directions_walk, color: Colors.purple);
      case 'cageCleaning':
        return const Icon(Icons.cleaning_services, color: Colors.teal);
      case 'training':
        return const Icon(Icons.school, color: Colors.indigo);
      case 'medication':
        return const Icon(Icons.medication, color: Colors.pink);
      default:
        return const Icon(Icons.event, color: Colors.grey);
    }
  }

  Widget _getExpenseCategoryIcon(String category) {
    switch (category) {
      case 'food':
        return const Icon(Icons.restaurant, color: Colors.orange);
      case 'medical':
        return const Icon(Icons.local_hospital, color: Colors.red);
      case 'toys':
        return const Icon(Icons.toys, color: Colors.blue);
      case 'accessories':
        return const Icon(Icons.shopping_bag, color: Colors.green);
      default:
        return const Icon(Icons.attach_money, color: Colors.grey);
    }
  }
}

/// ADD/EDIT ACTIVITY SCREEN
class AddEditActivityScreen extends StatefulWidget {
  final String petId;
  final PetActivity? activity;

  const AddEditActivityScreen({super.key, required this.petId, this.activity});

  @override
  State<AddEditActivityScreen> createState() => _AddEditActivityScreenState();
}

class _AddEditActivityScreenState extends State<AddEditActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedCategory;
  late TextEditingController _descriptionController;
  late TextEditingController _costController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.activity?.category ?? 'walk';
    _descriptionController = TextEditingController(
      text: widget.activity?.description ?? '',
    );
    _costController = TextEditingController(
      text: widget.activity?.cost?.toString() ?? '',
    );
    _selectedDate = widget.activity?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final petData = Provider.of<PetData>(context, listen: false);
    final isEditing = widget.activity != null;

    final categories = {
      'walk': l10n.walk,
      'feeding': l10n.feeding,
      'grooming': l10n.grooming,
      'veterinaryVisit': l10n.veterinaryVisit,
      'training': l10n.training,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editActivity : l10n.addActivity),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: l10n.category,
                        prefixIcon: const Icon(Icons.category),
                      ),
                      items: categories.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        prefixIcon: const Icon(Icons.description),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.pleaseEnterDescription;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _costController,
                      decoration: InputDecoration(
                        labelText: getLocalizedAmountLabel(context),
                        prefixIcon: const Icon(Icons.payments),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(l10n.date),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                      ),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final activity = PetActivity(
                    id:
                        widget.activity?.id ??
                        'act_${DateTime.now().millisecondsSinceEpoch}',
                    petId: widget.petId,
                    category: _selectedCategory,
                    description: _descriptionController.text,
                    date: _selectedDate,
                    cost: double.tryParse(_costController.text),
                  );

                  if (isEditing) {
                    petData.updateActivity(activity);
                  } else {
                    petData.addActivity(activity);
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.saveSuccess)));
                  Navigator.pop(context);
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}

/// ADD/EDIT VACCINATION SCREEN
class AddEditVaccinationScreen extends StatefulWidget {
  final String petId;
  final Vaccination? vaccination;

  const AddEditVaccinationScreen({
    super.key,
    required this.petId,
    this.vaccination,
  });

  @override
  State<AddEditVaccinationScreen> createState() =>
      _AddEditVaccinationScreenState();
}

class _AddEditVaccinationScreenState extends State<AddEditVaccinationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _vetController;
  late TextEditingController _notesController;
  late DateTime _vaccineDate;
  DateTime? _nextDueDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.vaccination?.vaccineName ?? '',
    );
    _vetController = TextEditingController(
      text: widget.vaccination?.veterinarian ?? '',
    );
    _notesController = TextEditingController(
      text: widget.vaccination?.notes ?? '',
    );
    _vaccineDate = widget.vaccination?.vaccineDate ?? DateTime.now();
    _nextDueDate = widget.vaccination?.nextDueDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _vetController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final petData = Provider.of<PetData>(context, listen: false);
    final isEditing = widget.vaccination != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editVaccination : l10n.addVaccination),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.vaccineName,
                        prefixIcon: const Icon(Icons.vaccines),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.pleaseEnterVaccineName;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _vetController,
                      decoration: InputDecoration(
                        labelText: l10n.veterinarian,
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(l10n.vaccineDate),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(_vaccineDate),
                      ),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _vaccineDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _vaccineDate = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.event_repeat),
                      title: Text(l10n.nextDueDate),
                      subtitle: Text(
                        _nextDueDate != null
                            ? DateFormat('dd/MM/yyyy').format(_nextDueDate!)
                            : l10n.selectDate,
                      ),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate:
                              _nextDueDate ??
                              DateTime.now().add(const Duration(days: 365)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 1095),
                          ),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _nextDueDate = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: l10n.notes,
                        prefixIcon: const Icon(Icons.note),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final vaccination = Vaccination(
                    id:
                        widget.vaccination?.id ??
                        'vac_${DateTime.now().millisecondsSinceEpoch}',
                    petId: widget.petId,
                    vaccineName: _nameController.text,
                    vaccineDate: _vaccineDate,
                    nextDueDate: _nextDueDate,
                    veterinarian: _vetController.text.isEmpty
                        ? null
                        : _vetController.text,
                    notes: _notesController.text.isEmpty
                        ? null
                        : _notesController.text,
                  );

                  if (isEditing) {
                    petData.updateVaccination(vaccination);
                  } else {
                    petData.addVaccination(vaccination);
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.saveSuccess)));
                  Navigator.pop(context);
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}

/// ADD/EDIT REMINDER SCREEN
class AddEditReminderScreen extends StatefulWidget {
  final String petId;
  final HealthReminder? reminder;

  const AddEditReminderScreen({super.key, required this.petId, this.reminder});

  @override
  State<AddEditReminderScreen> createState() => _AddEditReminderScreenState();
}

class _AddEditReminderScreenState extends State<AddEditReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String _selectedRepeat;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.reminder?.title ?? '',
    );
    _selectedDate = widget.reminder?.reminderDate ?? DateTime.now();
    _selectedTime = widget.reminder?.reminderTime ?? TimeOfDay.now();
    _selectedRepeat = widget.reminder?.repeatType ?? 'never';
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final petData = Provider.of<PetData>(context, listen: false);
    final isEditing = widget.reminder != null;

    final repeatOptions = {
      'never': l10n.never,
      'daily': l10n.daily,
      'weekly': l10n.weekly,
      'monthly': l10n.monthly,
      'yearly': l10n.yearly,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editReminder : l10n.addReminder),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: l10n.reminderTitle,
                        prefixIcon: const Icon(Icons.title),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.enterDescription;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(l10n.date),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                      ),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(l10n.reminderTime),
                      subtitle: Text(_selectedTime.format(context)),
                      onTap: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _selectedTime = pickedTime;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedRepeat,
                      decoration: InputDecoration(
                        labelText: l10n.repeatReminder,
                        prefixIcon: const Icon(Icons.repeat),
                      ),
                      items: repeatOptions.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRepeat = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final reminder = HealthReminder(
                    id:
                        widget.reminder?.id ??
                        'rem_${DateTime.now().millisecondsSinceEpoch}',
                    petId: widget.petId,
                    title: _titleController.text,
                    reminderDate: _selectedDate,
                    reminderTime: _selectedTime,
                    repeatType: _selectedRepeat,
                  );

                  if (isEditing) {
                    petData.updateReminder(reminder);
                  } else {
                    petData.addReminder(reminder);
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.saveSuccess)));
                  Navigator.pop(context);
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}

/// ADD/EDIT EXPENSE SCREEN
class AddEditExpenseScreen extends StatefulWidget {
  final String petId;
  final Expense? expense;

  const AddEditExpenseScreen({super.key, required this.petId, this.expense});

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.expense?.amount.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.expense?.description ?? '',
    );
    _selectedCategory = widget.expense?.category ?? 'food';
    _selectedDate = widget.expense?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final petData = Provider.of<PetData>(context, listen: false);
    final isEditing = widget.expense != null;

    final categories = {
      'food': l10n.food,
      'medical': l10n.medical,
      'toys': l10n.toys,
      'accessories': l10n.accessories,
      'other': l10n.other,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editExpense : l10n.addExpense),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: l10n.amount,
                        prefixIcon: const Icon(Icons.payments),
                        prefixText: '${l10n.currencySymbol} ',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.pleaseEnterAmount;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: l10n.category,
                        prefixIcon: const Icon(Icons.category),
                      ),
                      items: categories.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        prefixIcon: const Icon(Icons.description),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(l10n.date),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                      ),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final expense = Expense(
                    id:
                        widget.expense?.id ??
                        'exp_${DateTime.now().millisecondsSinceEpoch}',
                    petId: widget.petId,
                    amount: double.parse(_amountController.text),
                    category: _selectedCategory,
                    date: _selectedDate,
                    description: _descriptionController.text,
                  );

                  if (isEditing) {
                    petData.updateExpense(expense);
                  } else {
                    petData.addExpense(expense);
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.saveSuccess)));
                  Navigator.pop(context);
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}

/// EXPLORE SCREEN
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final ScrollController _categoryScrollController = ScrollController();
  bool _showRightArrow = true;

  @override
  void initState() {
    super.initState();
    _categoryScrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_categoryScrollController.position.pixels >=
        _categoryScrollController.position.maxScrollExtent - 20) {
      if (_showRightArrow) setState(() => _showRightArrow = false);
    } else {
      if (!_showRightArrow) setState(() => _showRightArrow = true);
    }
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  Color _getCategoryColor(String categoryKey) {
    switch (categoryKey) {
      case 'dogCare':
        return Colors.brown;
      case 'catCare':
        return Colors.purple;
      case 'birdCare':
        return Colors.teal;
      case 'fishCare':
        return Colors.blue;
      case 'rabbitCare':
        return Colors.green;
      case 'hamsterCare':
        return Colors.orange;
      case 'exoticCare':
        return Colors.deepOrange;
      case 'health':
        return Colors.red;
      case 'lifestyle':
        return Colors.amber;
      case 'behavior':
        return Colors.indigo;
      case 'generalCare':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.explore),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(115),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l10n.search,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  SizedBox(
                    height: 55,
                    child: ListView(
                      controller: _categoryScrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        _buildCategoryChip('all', l10n.all, '📚'),
                        _buildCategoryChip('dogCare', l10n.dogCare, '🐕'),
                        _buildCategoryChip('catCare', l10n.catCare, '🐈'),
                        _buildCategoryChip('birdCare', l10n.birdCare, '🦜'),
                        _buildCategoryChip('fishCare', l10n.fishCare, '🐠'),
                        _buildCategoryChip('rabbitCare', l10n.rabbitCare, '🐰'),
                        _buildCategoryChip(
                          'hamsterCare',
                          l10n.hamsterCare,
                          '🐹',
                        ),
                        _buildCategoryChip('exoticCare', l10n.exoticCare, '🐢'),
                        _buildCategoryChip('health', l10n.health, '⚕️'),
                        _buildCategoryChip('lifestyle', l10n.lifestyle, '🏡'),
                        _buildCategoryChip('behavior', l10n.behavior, '🧠'),
                        _buildCategoryChip(
                          'generalCare',
                          l10n.generalCare,
                          '🐾',
                        ),
                      ],
                    ),
                  ),
                  if (_showRightArrow)
                    IgnorePointer(
                      child: Container(
                        width: 40,
                        height: 55,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Theme.of(
                                context,
                              ).colorScheme.surface.withOpacity(0),
                              Theme.of(context).colorScheme.surface,
                            ],
                          ),
                        ),
                        child: const Icon(Icons.chevron_right, size: 20),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
      body: Consumer<ExploreData>(
        builder:
            (BuildContext context, ExploreData exploreData, Widget? child) {
              if (exploreData.articles.isEmpty) {
                return Center(child: Text(l10n.noContentToExplore));
              }

              // Filter articles
              var filteredArticles = exploreData.articles.where((article) {
                bool categoryMatch =
                    _selectedCategory == 'all' ||
                    article.categoryKey == _selectedCategory;

                // Search in localized title and content
                String localizedTitle = getLocalizedTitle(
                  context,
                  article.titleKey,
                ).toLowerCase();
                String localizedContent = getLocalizedContent(
                  context,
                  article.contentKey,
                ).toLowerCase();

                bool searchMatch =
                    _searchQuery.isEmpty ||
                    localizedTitle.contains(_searchQuery) ||
                    localizedContent.contains(_searchQuery);

                return categoryMatch && searchMatch;
              }).toList();

              if (filteredArticles.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noResultsFound,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                );
              }

              // Build list with banner ads inserted
              List<Widget> listItems = [];

              // Add top banner
              listItems.add(
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: BannerAdWidget(adSize: AdSize.fullBanner),
                ),
              );

              for (int i = 0; i < filteredArticles.length; i++) {
                listItems.add(ExploreArticleCard(article: filteredArticles[i]));

                // Add banner every 2 articles
                if ((i + 1) % 2 == 0 && i != filteredArticles.length - 1) {
                  listItems.add(
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: BannerAdWidget(),
                    ),
                  );
                }
              }

              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: listItems,
              );
            },
      ),
    );
  }

  Widget _buildCategoryChip(String category, String label, String emoji) {
    final isSelected = _selectedCategory == category;
    final color = _getCategoryColor(category);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        avatar: Text(emoji),
        selectedColor: color.withOpacity(0.2),
        checkmarkColor: color,
        labelStyle: TextStyle(
          color: isSelected ? color : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );
  }
}

class ExploreArticleCard extends StatelessWidget {
  final ExploreArticle article;

  const ExploreArticleCard({super.key, required this.article});

  Widget _buildPlaceholder(Color categoryColor, String emoji) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            categoryColor.withValues(alpha: 0.3),
            categoryColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            scaleEmoji(emoji, size: 60),
            const SizedBox(height: 8),
            Icon(
              Icons.image_not_supported_outlined,
              color: categoryColor.withValues(alpha: 0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget scaleEmoji(String emoji, {required double size}) {
    return Text(emoji, style: TextStyle(fontSize: size));
  }

  Color _getCategoryColor(String categoryKey) {
    switch (categoryKey) {
      case 'dogCare':
        return Colors.brown;
      case 'catCare':
        return Colors.purple;
      case 'birdCare':
        return Colors.teal;
      case 'fishCare':
        return Colors.blue;
      case 'rabbitCare':
        return Colors.green;
      case 'hamsterCare':
        return Colors.orange;
      case 'exoticCare':
        return Colors.deepOrange;
      case 'health':
        return Colors.red;
      case 'lifestyle':
        return Colors.amber;
      case 'behavior':
        return Colors.indigo;
      case 'generalCare':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  String _getCategoryEmoji(String categoryKey) {
    switch (categoryKey) {
      case 'dogCare':
        return '🐕';
      case 'catCare':
        return '🐈';
      case 'birdCare':
        return '🦜';
      case 'fishCare':
        return '🐠';
      case 'rabbitCare':
        return '🐰';
      case 'hamsterCare':
        return '🐹';
      case 'exoticCare':
        return '🐢';
      case 'health':
        return '⚕️';
      case 'lifestyle':
        return '🏡';
      case 'behavior':
        return '🧠';
      case 'generalCare':
        return '🐾';
      default:
        return '📚';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categoryColor = _getCategoryColor(article.categoryKey);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  ExploreArticleDetailScreen(article: article),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16.0),
                  ),
                  child:
                      article.imageUrl.isEmpty ||
                          article.imageUrl.contains('placeholder')
                      ? _buildPlaceholder(
                          categoryColor,
                          _getCategoryEmoji(article.categoryKey),
                        )
                      : Image.network(
                          article.imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(
                                categoryColor,
                                _getCategoryEmoji(article.categoryKey),
                              ),
                        ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getCategoryEmoji(article.categoryKey),
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          getLocalizedCategory(context, article.categoryKey),
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getLocalizedTitle(context, article.titleKey),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    getLocalizedContent(context, article.contentKey),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  ExploreArticleDetailScreen(article: article),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward, size: 18),
                        label: Text(l10n.readMore),
                        style: TextButton.styleFrom(
                          foregroundColor: categoryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExploreArticleDetailScreen extends StatelessWidget {
  final ExploreArticle article;

  const ExploreArticleDetailScreen({super.key, required this.article});

  Widget _buildPlaceholder(Color categoryColor, String emoji) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            categoryColor.withValues(alpha: 0.3),
            categoryColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 100))),
    );
  }

  Color _getCategoryColor(String categoryKey) {
    switch (categoryKey) {
      case 'dogCare':
        return Colors.brown;
      case 'catCare':
        return Colors.purple;
      case 'birdCare':
        return Colors.teal;
      case 'fishCare':
        return Colors.blue;
      case 'rabbitCare':
        return Colors.green;
      case 'hamsterCare':
        return Colors.orange;
      case 'exoticCare':
        return Colors.deepOrange;
      case 'health':
        return Colors.red;
      case 'lifestyle':
        return Colors.amber;
      case 'behavior':
        return Colors.indigo;
      case 'generalCare':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  String _getCategoryEmoji(String categoryKey) {
    switch (categoryKey) {
      case 'dogCare':
        return '🐕';
      case 'catCare':
        return '🐈';
      case 'birdCare':
        return '🦜';
      case 'fishCare':
        return '🐠';
      case 'rabbitCare':
        return '🐰';
      case 'hamsterCare':
        return '🐹';
      case 'exoticCare':
        return '🐢';
      case 'health':
        return '⚕️';
      case 'lifestyle':
        return '🏡';
      case 'behavior':
        return '🧠';
      case 'generalCare':
        return '🐾';
      default:
        return '📚';
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(article.categoryKey);
    final emoji = _getCategoryEmoji(article.categoryKey);

    return Scaffold(
      appBar: AppBar(
        title: Text(getLocalizedTitle(context, article.titleKey)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child:
                  article.imageUrl.isEmpty ||
                      article.imageUrl.contains('placeholder')
                  ? _buildPlaceholder(categoryColor, emoji)
                  : Image.network(
                      article.imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(categoryColor, emoji),
                    ),
            ),
            const SizedBox(height: 20.0),
            Text(
              getLocalizedCategory(context, article.categoryKey),
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              getLocalizedTitle(context, article.titleKey),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              getLocalizedFullContent(context, article.contentKey),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

/// STATISTICS SCREEN
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.statistics)),
      body: Consumer<PetData>(
        builder: (BuildContext context, PetData petData, Widget? child) {
          if (petData.pets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bar_chart, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(l10n.noContentToExplore),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildOverviewCard(context, petData, l10n),
              const SizedBox(height: 16),
              _buildPetTypeChart(context, petData, l10n),
              const SizedBox(height: 16),
              _buildExpensesSummaryCard(context, petData, l10n),
              const SizedBox(height: 16),
              _buildExpenseChart(context, petData, l10n),
              const SizedBox(height: 16),
              _buildHealthStatusCard(context, petData, l10n),
              const SizedBox(height: 16),
              _buildUpcomingRemindersCard(context, petData, l10n),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDataScreen()),
          );
        },
        tooltip: l10n.add,
        icon: const Icon(Icons.add),
        label: Text(l10n.addInfo),
      ),
    );
  }

  Widget _buildOverviewCard(
    BuildContext context,
    PetData petData,
    AppLocalizations l10n,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.overview,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    l10n.totalPets,
                    petData.pets.length.toString(),
                    Icons.pets,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    l10n.activitiesThisMonth,
                    petData.activities
                        .where(
                          (activity) =>
                              activity.date.month == DateTime.now().month &&
                              activity.date.year == DateTime.now().year,
                        )
                        .length
                        .toString(),
                    Icons.event,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetTypeChart(
    BuildContext context,
    PetData petData,
    AppLocalizations l10n,
  ) {
    final typeCounts = <String, int>{};
    for (final pet in petData.pets) {
      typeCounts[pet.type] = (typeCounts[pet.type] ?? 0) + 1;
    }

    final List<PieChartSectionData> sections = [];
    int index = 0;
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
    ];

    typeCounts.forEach((type, count) {
      sections.add(
        PieChartSectionData(
          color: colors[index % colors.length],
          value: count.toDouble(),
          title: '$count',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      index++;
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.petType,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: typeCounts.keys.mapIndexed((i, type) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              color: colors[i % colors.length],
                            ),
                            const SizedBox(width: 8),
                            Text(_getLocalizedPetType(context, type, l10n)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedPetType(
    BuildContext context,
    String type,
    AppLocalizations l10n,
  ) {
    switch (type.toLowerCase()) {
      case 'dog':
        return l10n.dog;
      case 'cat':
        return l10n.cat;
      case 'bird':
        return l10n.bird;
      case 'rabbit':
        return l10n.rabbit;
      case 'hamster':
        return l10n.hamster;
      case 'fish':
        return l10n.fish;
      case 'turtle':
        return l10n.turtle;
      default:
        return l10n.other;
    }
  }

  Widget _buildExpensesSummaryCard(
    BuildContext context,
    PetData petData,
    AppLocalizations l10n,
  ) {
    final totalExpenses = petData.expenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
    final thisMonthExpenses = petData.expenses
        .where(
          (expense) =>
              expense.date.month == DateTime.now().month &&
              expense.date.year == DateTime.now().year,
        )
        .fold(0.0, (sum, expense) => sum + expense.amount);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.expenseSummary,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    l10n.totalExpenses,
                    '${l10n.currencySymbol}${totalExpenses.toStringAsFixed(2)}',
                    Icons.attach_money,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    l10n.thisMonth,
                    '${l10n.currencySymbol}${thisMonthExpenses.toStringAsFixed(2)}',
                    Icons.calendar_month,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseChart(
    BuildContext context,
    PetData petData,
    AppLocalizations l10n,
  ) {
    final categoryExpenses = <String, double>{};
    for (final expense in petData.expenses) {
      categoryExpenses[expense.category] =
          (categoryExpenses[expense.category] ?? 0.0) + expense.amount;
    }

    if (categoryExpenses.isEmpty) return const SizedBox.shrink();

    final List<BarChartGroupData> barGroups = [];
    int index = 0;
    final categories = categoryExpenses.keys.toList();

    for (final category in categories) {
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: categoryExpenses[category]!,
              color: Colors.blue,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
      index++;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.expenseChart,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < categories.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _getLocalizedExpenseCategory(
                                  categories[value.toInt()],
                                  l10n,
                                ),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedExpenseCategory(String category, AppLocalizations l10n) {
    switch (category.toLowerCase()) {
      case 'food':
        return l10n.food;
      case 'medical':
        return l10n.medical;
      case 'toys':
        return l10n.toys;
      case 'accessories':
        return l10n.accessories;
      default:
        return l10n.other;
    }
  }

  Widget _buildHealthStatusCard(
    BuildContext context,
    PetData petData,
    AppLocalizations l10n,
  ) {
    final healthCounts = <String, int>{};
    for (final pet in petData.pets) {
      healthCounts[pet.healthStatus] =
          (healthCounts[pet.healthStatus] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.healthStatus,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...healthCounts.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_getHealthStatusText(context, entry.key, l10n)),
                    Chip(
                      label: Text(entry.value.toString()),
                      backgroundColor: _getHealthStatusColor(entry.key),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHealthStatusText(
    BuildContext context,
    String status,
    AppLocalizations l10n,
  ) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return l10n.excellent;
      case 'good':
        return l10n.good;
      case 'fair':
        return l10n.fair;
      case 'poor':
        return l10n.poor;
      default:
        return status;
    }
  }

  Widget _buildUpcomingRemindersCard(
    BuildContext context,
    PetData petData,
    AppLocalizations l10n,
  ) {
    final upcomingReminders = petData.reminders
        .where(
          (reminder) =>
              reminder.isActive &&
              reminder.reminderDate.isAfter(DateTime.now()) &&
              reminder.reminderDate.isBefore(
                DateTime.now().add(const Duration(days: 7)),
              ),
        )
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.upcomingReminders7Days,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (upcomingReminders.isEmpty)
              Text(l10n.noUpcomingReminders)
            else
              ...upcomingReminders.map((reminder) {
                final pet = petData.pets.firstWhereOrNull(
                  (p) => p.id == reminder.petId,
                );
                return ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.blue),
                  title: Text(reminder.title),
                  subtitle: Text(
                    '${pet?.name ?? l10n.unknown} - ${DateFormat('dd/MM/yyyy').format(reminder.reminderDate)}',
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getHealthStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.blue;
      case 'fair':
        return Colors.orange;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
*/
