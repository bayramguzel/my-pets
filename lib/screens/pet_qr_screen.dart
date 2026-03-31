import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import 'package:my_pets/utils/localization_utils.dart';
import 'dart:io';

import '../models/pet_models.dart';

class PetQRScreen extends StatelessWidget {
  final Pet pet;

  const PetQRScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${pet.name} - ${l10n.qrCode}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareQRCode(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: _getPetImageProvider(pet.photoUrl),
                      onBackgroundImageError: (exception, stackTrace) {},
                      child: _getPetImageProvider(pet.photoUrl) == null
                          ? Icon(Icons.pets, size: 40, color: Colors.grey[600])
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      pet.name,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      getPetTypeTranslation(context, pet.type),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code,
                              size: 120,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.qrCode,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.scanQRMsg(pet.name),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildPetInfoCard(context),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _copyToClipboard(context),
                    icon: const Icon(Icons.copy),
                    label: Text(l10n.copyInfo),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _shareQRCode(context),
                    icon: const Icon(Icons.share),
                    label: Text(l10n.share),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetInfoCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.emergencyInfo,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (pet.veterinarianName != null)
              _buildInfoRow(l10n.veterinarianName, pet.veterinarianName!),
            if (pet.veterinarianContact != null)
              _buildInfoRow(l10n.veterinarianContact, pet.veterinarianContact!),
            if (pet.emergencyContact != null)
              _buildInfoRow(l10n.emergencyContact, pet.emergencyContact!),
            if (pet.microchipId != null)
              _buildInfoRow(l10n.microchipId, pet.microchipId!),
            if (pet.allergies != null)
              _buildInfoRow(l10n.allergies, pet.allergies!),
            if (pet.currentMedications != null)
              _buildInfoRow(l10n.currentMedications, pet.currentMedications!),
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
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final petInfo = _generatePetInfoText(context);
    Clipboard.setData(ClipboardData(text: petInfo));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.saveSuccess)));
  }

  void _shareQRCode(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.languageSettingsComingSoon)));
  }

  String _generatePetInfoText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final buffer = StringBuffer();
    buffer.writeln('🐾 ${pet.name}');
    buffer.writeln(
      '${l10n.petType}: ${getPetTypeTranslation(context, pet.type)}',
    );

    if (pet.breed != null) buffer.writeln('${l10n.breed}: ${pet.breed}');
    if (pet.veterinarianName != null) {
      buffer.writeln('${l10n.veterinarianName}: ${pet.veterinarianName}');
    }
    if (pet.veterinarianContact != null) {
      buffer.writeln('${l10n.veterinarianContact}: ${pet.veterinarianContact}');
    }
    if (pet.emergencyContact != null) {
      buffer.writeln('${l10n.emergencyContact}: ${pet.emergencyContact}');
    }
    if (pet.microchipId != null) {
      buffer.writeln('${l10n.microchipId}: ${pet.microchipId}');
    }
    if (pet.allergies != null) {
      buffer.writeln('${l10n.allergies}: ${pet.allergies}');
    }
    if (pet.currentMedications != null) {
      buffer.writeln('${l10n.currentMedications}: ${pet.currentMedications}');
    }

    return buffer.toString();
  }

  ImageProvider? _getPetImageProvider(String photoUrl) {
    if (photoUrl.contains('placeholder')) return null;
    if (photoUrl.startsWith('http://') || photoUrl.startsWith('https://')) {
      return NetworkImage(photoUrl);
    }
    return FileImage(File(photoUrl));
  }
}
