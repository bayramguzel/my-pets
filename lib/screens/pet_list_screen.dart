import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import 'package:my_pets/utils/localization_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../models/pet_models.dart';
import '../providers/pet_provider.dart';
import '../widgets/banner_ad_widget.dart';
import 'add_edit_pet_screen.dart';
import 'pet_detail_screen.dart';

class PetListScreen extends StatelessWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final petData = Provider.of<PetData>(context);
    final settings = Provider.of<AppSettings>(context);
    final locale = Localizations.localeOf(context).languageCode;
    final isTurkish = locale == 'tr';
    final titleText = isTurkish ? 'Can Dostlarım' : l10n.myPets;
    final addPetFriendLabel = isTurkish ? 'Can Dost Ekle' : 'Add Pet Friend';

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        actions: [
          IconButton(
            tooltip: isTurkish ? 'Uygulamayı Paylaş' : 'Share App',
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              const url =
                  'https://play.google.com/store/apps/details?id=com.vbt.my_pets';
              final message = isTurkish
                  ? 'Can dostlarımızın bakımını takip etmek için bu harika uygulamayı denemelisin! \n\n$url'
                  : 'You should try this great app to keep track of our pet friends\' care! \n\n$url';
              Share.share(message);
            },
          ),
          IconButton(
            tooltip: settings.isDarkMode ? 'Light Mode' : 'Dark Mode',
            icon: Icon(
              settings.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            onPressed: () {
              settings.toggleDarkMode(!settings.isDarkMode);
            },
          ),
          IconButton(
            tooltip: petData.viewMode == 'list'
                ? l10n.viewModeGrid
                : l10n.viewModeList,
            icon: Icon(
              petData.viewMode == 'list'
                  ? Icons.grid_view_rounded
                  : Icons.view_list_rounded,
            ),
            onPressed: () {
              petData.setViewMode(petData.viewMode == 'list' ? 'grid' : 'list');
            },
          ),
        ],
      ),
      body: petData.pets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noPetsYet,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddEditPetScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.favorite),
                    label: Text(addPetFriendLabel),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : petData.viewMode == 'grid'
          ? GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.95,
              ),
              itemCount: petData.pets.length,
              itemBuilder: (context, index) {
                final pet = petData.pets[index];
                return PetCard(pet: pet, isGrid: true);
              },
            )
          : Builder(
              builder: (context) {
                final items = <Widget>[];
                for (int i = 0; i < petData.pets.length; i++) {
                  items.add(PetCard(pet: petData.pets[i]));
                  if ((i + 1) % 3 == 0 && i != petData.pets.length - 1) {
                    items.add(const _AdPetCard());
                  }
                }
                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: items,
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditPetScreen()),
          );
        },
        icon: const Icon(Icons.favorite_rounded, color: Colors.white),
        label: Text(
          addPetFriendLabel,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  final Pet pet;
  final bool isGrid;

  const PetCard({super.key, required this.pet, this.isGrid = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final gradient = _getTypeGradient(pet.type);
    final emoji = _getTypeEmoji(pet.type);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PetDetailScreen(pet: pet)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isGrid ? 0 : 16.0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.black.withOpacity(0.08)),
        ),
        child: isGrid
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAvatar(context, emoji, size: 64),
                  const SizedBox(height: 12),
                  Text(
                    pet.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${getPetTypeTranslation(context, pet.type)}${pet.breed != null ? ' • ${pet.breed}' : ''}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                  ),
                  const Spacer(),
                  Text(
                    '${pet.ageInYears} ${l10n.years}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                  ),
                ],
              )
            : Row(
                children: [
                  _buildAvatar(context, emoji, size: 64),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${getPetTypeTranslation(context, pet.type)}${pet.breed != null ? ' • ${pet.breed}' : ''}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${pet.ageInYears} ${l10n.years}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.black45),
                ],
              ),
      ),
    );
  }

  LinearGradient _getTypeGradient(String type) {
    switch (type) {
      case 'dog':
        return const LinearGradient(
          colors: [Color(0xFFF6E8DA), Color(0xFFE9D3C0)],
        );
      case 'cat':
        return const LinearGradient(
          colors: [Color(0xFFF1E5FF), Color(0xFFE0C8FF)],
        );
      case 'bird':
        return const LinearGradient(
          colors: [Color(0xFFE6F7FF), Color(0xFFCCE9FF)],
        );
      case 'rabbit':
        return const LinearGradient(
          colors: [Color(0xFFE9FFF2), Color(0xFFCCF5DC)],
        );
      case 'hamster':
        return const LinearGradient(
          colors: [Color(0xFFFFF2E0), Color(0xFFFFE1B8)],
        );
      case 'fish':
        return const LinearGradient(
          colors: [Color(0xFFE7F3FF), Color(0xFFD2E6FF)],
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFFF3F4F6), Color(0xFFE5E7EB)],
        );
    }
  }

  String _getTypeEmoji(String type) {
    switch (type) {
      case 'dog':
        return '🐶';
      case 'cat':
        return '🐱';
      case 'bird':
        return '🐦';
      case 'rabbit':
        return '🐰';
      case 'hamster':
        return '🐹';
      case 'fish':
        return '🐠';
      default:
        return '🐾';
    }
  }

  Widget _buildAvatar(BuildContext context, String emoji, {double size = 64}) {
    final imageProvider = _getPetImageProvider(pet.photoUrl);
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.7),
            border: Border.all(color: Colors.white, width: 2),
            image: imageProvider == null
                ? null
                : DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {},
                  ),
          ),
          child: imageProvider == null
              ? Center(
                  child: Text(emoji, style: TextStyle(fontSize: size * 0.45)),
                )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: size * 0.32,
            height: size * 0.32,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(emoji, style: TextStyle(fontSize: size * 0.2)),
            ),
          ),
        ),
      ],
    );
  }

  ImageProvider? _getPetImageProvider(String photoUrl) {
    if (photoUrl.contains('placeholder')) return null;
    if (photoUrl.startsWith('http://') || photoUrl.startsWith('https://')) {
      return NetworkImage(photoUrl);
    }
    return FileImage(File(photoUrl));
  }
}

class _AdPetCard extends StatelessWidget {
  const _AdPetCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: const Center(child: BannerAdWidget(adSize: AdSize.fullBanner)),
    );
  }
}
