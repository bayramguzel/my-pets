import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import 'package:my_pets/utils/localization_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../models/pet_models.dart';
import '../utils/share_utils.dart';

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
            onPressed: () => _sharePetInfo(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildQrCard(context),
                    const SizedBox(height: 24),
                    _buildPetInfoCard(context),
                  ],
                ),
              ),
              const SizedBox(height: 12),
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
                      onPressed: () => _sharePetInfo(context),
                      icon: const Icon(Icons.share),
                      label: Text(l10n.share),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final imageProvider = _getPetImageProvider(pet.photoUrl);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: imageProvider,
              onBackgroundImageError: imageProvider == null
                  ? null
                  : (exception, stackTrace) {},
              child: imageProvider == null
                  ? Icon(Icons.pets, size: 40, color: Colors.grey[600])
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              pet.name,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              getPetTypeTranslation(context, pet.type),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 20),
            // A light background keeps the code scannable in dark mode too.
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: QrImageView(
                data: _generatePetInfoText(context),
                version: QrVersions.auto,
                size: 200,
                backgroundColor: Colors.white,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Colors.black,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black,
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
    );
  }

  Widget _buildPetInfoCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rows = <MapEntry<String, String>>[
      if (pet.veterinarianName != null)
        MapEntry(l10n.veterinarianName, pet.veterinarianName!),
      if (pet.veterinarianContact != null)
        MapEntry(l10n.veterinarianContact, pet.veterinarianContact!),
      if (pet.emergencyContact != null)
        MapEntry(l10n.emergencyContact, pet.emergencyContact!),
      if (pet.microchipId != null) MapEntry(l10n.microchipId, pet.microchipId!),
      if (pet.allergies != null) MapEntry(l10n.allergies, pet.allergies!),
      if (pet.currentMedications != null)
        MapEntry(l10n.currentMedications, pet.currentMedications!),
    ];

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
            if (rows.isEmpty)
              Text(
                l10n.noEmergencyInfo,
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              for (final row in rows) _buildInfoRow(row.key, row.value),
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

  Future<void> _copyToClipboard(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    await Clipboard.setData(ClipboardData(text: _generatePetInfoText(context)));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.copiedToClipboard)),
    );
  }

  Future<void> _sharePetInfo(BuildContext context) async {
    await SharePlus.instance.share(
      ShareParams(
        text: _generatePetInfoText(context),
        subject: pet.name,
        sharePositionOrigin: sharePositionOriginFor(context),
      ),
    );
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
    if (photoUrl.contains('placeholder') || photoUrl.isEmpty) return null;
    if (photoUrl.startsWith('http://') || photoUrl.startsWith('https://')) {
      return NetworkImage(photoUrl);
    }
    return FileImage(File(photoUrl));
  }
}
