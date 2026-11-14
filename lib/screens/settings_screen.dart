import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import 'package:my_pets/utils/pastel_colors.dart';
import '../utils/adaptive_dialogs.dart';
import '../providers/pet_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = Provider.of<AppSettings>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          // 1. Appearance / Theme Category Card
          _buildCategoryCard(
            context: context,
            isDark: isDark,
            backgroundColor: PastelColors.themeCategoryColor(isDark),
            borderColor: PastelColors.themeCategoryBorder(isDark),
            icon: Icons.palette_outlined,
            iconColor: Colors.deepPurple,
            title: l10n.themeSettings,
            children: [
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(l10n.darkMode),
                value: settings.isDarkMode,
                onChanged: (value) => settings.toggleDarkMode(value),
                secondary: const Icon(Icons.dark_mode_outlined),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
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
                          ? Colors.white24
                          : Colors.black12,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _getThemeColor(settings.selectedColorScheme)
                            .withValues(alpha: 0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                leading: const Icon(Icons.color_lens_outlined),
                onTap: () => _showThemePicker(context, settings),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. General / Preferences Category Card
          _buildCategoryCard(
            context: context,
            isDark: isDark,
            backgroundColor: PastelColors.generalCategoryColor(isDark),
            borderColor: PastelColors.generalCategoryBorder(isDark),
            icon: Icons.tune_outlined,
            iconColor: Colors.blue,
            title: l10n.generalSettings,
            children: [
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(l10n.notifications),
                value: settings.notificationsEnabled,
                onChanged: (value) =>
                    _handleNotificationToggle(context, settings, value, l10n),
                secondary: const Icon(Icons.notifications_outlined),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(l10n.sound),
                value: settings.soundEnabled,
                onChanged: (value) => settings.toggleSound(value),
                secondary: const Icon(Icons.volume_up_outlined),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                title: Text(l10n.language),
                subtitle: Text(
                  _getLanguageSubtitle(context, settings.selectedLanguage),
                ),
                leading: const Icon(Icons.language_outlined),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguagePicker(context, settings),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. About & Support Category Card
          _buildCategoryCard(
            context: context,
            isDark: isDark,
            backgroundColor: PastelColors.aboutCategoryColor(isDark),
            borderColor: PastelColors.aboutCategoryBorder(isDark),
            icon: Icons.info_outline,
            iconColor: Colors.teal,
            title: l10n.about,
            children: [
              ListTile(
                title: Text(l10n.aboutTheApp),
                leading: const Icon(Icons.apps_outlined),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showAboutAppDialog(context, l10n),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                title: Text(l10n.contactUs),
                subtitle: const Text('info@41software.com'),
                leading: const Icon(Icons.email_outlined),
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () => _launchUrl('mailto:info@41software.com'),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                title: Text(l10n.privacyPolicy),
                leading: const Icon(Icons.privacy_tip_outlined),
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () => _launchUrl(
                  'https://www.41software.com/privacy/privacy_mypets.php',
                ),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                title: Text(l10n.visitWebsite),
                subtitle: const Text('www.41software.com'),
                leading: const Icon(Icons.public_outlined),
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () => _launchUrl('https://41software.com'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4. Data Management Category Card
          _buildCategoryCard(
            context: context,
            isDark: isDark,
            backgroundColor: PastelColors.dataCategoryColor(isDark),
            borderColor: PastelColors.dataCategoryBorder(isDark),
            icon: Icons.storage_outlined,
            iconColor: Colors.redAccent,
            title: l10n.dataManagement,
            children: [
              ListTile(
                title: Text(
                  l10n.deleteAllData,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(l10n.deleteAllDataWarning),
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                onTap: () => _showDeleteAllDataConfirm(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required bool isDark,
    required Color backgroundColor,
    required Color borderColor,
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<Widget> children,
  }) {
    // The card uses a Material surface (not a decorated Container) so the
    // ListTile ink splashes inside it stay visible.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: backgroundColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: borderColor, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
            ...children,
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  /// iOS shows the notification permission prompt only once. If the user has
  /// denied it, the switch has to send them to the system settings instead of
  /// pretending that reminders will arrive.
  Future<void> _handleNotificationToggle(
    BuildContext context,
    AppSettings settings,
    bool value,
    AppLocalizations l10n,
  ) async {
    if (!value) {
      settings.toggleNotifications(false);
      return;
    }

    final status = await Permission.notification.request();
    if (!context.mounted) return;

    if (status.isGranted) {
      settings.toggleNotifications(true);
      return;
    }

    settings.toggleNotifications(false);
    final shouldOpenSettings = await showAdaptiveConfirm(
      context: context,
      title: l10n.notifications,
      message: l10n.notificationsDisabled,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.settings,
    );

    if (shouldOpenSettings) {
      await openAppSettings();
    }
  }

  String _getLanguageSubtitle(BuildContext context, String selectedLanguage) {
    final l10n = AppLocalizations.of(context)!;
    switch (selectedLanguage) {
      case 'tr':
        return 'Türkçe';
      case 'de':
        return 'Deutsch';
      case 'en':
        return 'English';
      case 'system':
      default:
        return l10n.deviceLanguage;
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri uri = Uri.parse(urlString);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        debugPrint('Could not launch $uri');
      }
    } catch (e) {
      debugPrint('Error launching $uri: $e');
    }
  }

  Future<void> _showAboutAppDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (!context.mounted) return;
    showAboutDialog(
      context: context,
      applicationName: 'My Pets',
      applicationVersion:
          '${packageInfo.version} (${packageInfo.buildNumber})',
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('assets/logo.png', width: 52, height: 52),
      ),
      children: [
        Text(l10n.appDescription),
        const SizedBox(height: 16),
        const Text(
          '41 Software',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text('Web: www.41software.com'),
        const Text('Email: info@41software.com'),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            _launchUrl('https://www.41software.com/privacy/privacy_mypets.php');
          },
          child: Text(l10n.privacyPolicy),
        ),
      ],
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
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? themeColor
                            : Colors.grey.withValues(alpha: 0.3),
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: isSelected
                          ? themeColor.withValues(alpha: 0.12)
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
        return AlertDialog(
          title: Text(l10n.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context: context,
                code: 'system',
                title: l10n.deviceLanguage,
                flag: '📱',
                currentSelection: settings.selectedLanguage,
                onSelected: () {
                  settings.setSelectedLanguage('system');
                  Navigator.of(dialogContext).pop();
                },
              ),
              const Divider(height: 1),
              _buildLanguageOption(
                context: context,
                code: 'en',
                title: 'English',
                flag: '🇬🇧',
                currentSelection: settings.selectedLanguage,
                onSelected: () {
                  settings.setSelectedLanguage('en');
                  Navigator.of(dialogContext).pop();
                },
              ),
              const Divider(height: 1),
              _buildLanguageOption(
                context: context,
                code: 'tr',
                title: 'Türkçe',
                flag: '🇹🇷',
                currentSelection: settings.selectedLanguage,
                onSelected: () {
                  settings.setSelectedLanguage('tr');
                  Navigator.of(dialogContext).pop();
                },
              ),
              const Divider(height: 1),
              _buildLanguageOption(
                context: context,
                code: 'de',
                title: 'Deutsch',
                flag: '🇩🇪',
                currentSelection: settings.selectedLanguage,
                onSelected: () {
                  settings.setSelectedLanguage('de');
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String code,
    required String title,
    required String flag,
    required String currentSelection,
    required VoidCallback onSelected,
  }) {
    final isSelected = currentSelection == code;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 22)),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? primaryColor : null,
        ),
      ),
      trailing: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected ? primaryColor : null,
      ),
      onTap: onSelected,
    );
  }

  Future<void> _showDeleteAllDataConfirm(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showAdaptiveConfirm(
      context: context,
      title: l10n.deleteAllData,
      message: '${l10n.deleteAllDataConfirm}\n\n${l10n.deleteAllDataWarning}',
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.delete,
      destructive: true,
    );

    if (!confirmed || !context.mounted) return;
    await Provider.of<PetData>(context, listen: false).clearAll();
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.deleteSuccess)));
  }
}
