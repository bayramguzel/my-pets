import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerAdWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final dynamic adSize;

  const BannerAdWidget({
    super.key,
    this.width,
    this.height,
    this.adSize,
  });

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse('https://41software.com');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        debugPrint('Could not launch $uri');
      }
    } catch (e) {
      debugPrint('Error launching $uri: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _launchUrl,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 468),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 468 / 76,
                child: Image.asset(
                  'assets/banner.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
