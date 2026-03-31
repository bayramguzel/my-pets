import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import '../providers/pet_provider.dart';

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
              settings.selectedLanguage == 'tr'
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
                applicationVersion: '1.2.0+3',
                applicationIcon: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('assets/logo.png', width: 48, height: 48),
                ),
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
