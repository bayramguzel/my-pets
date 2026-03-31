import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import '../models/pet_models.dart';
import '../providers/pet_provider.dart';

class AddEditFoodPreferenceScreen extends StatefulWidget {
  final String petId;
  final FoodPreference? preference;

  const AddEditFoodPreferenceScreen({
    super.key,
    required this.petId,
    this.preference,
  });

  @override
  State<AddEditFoodPreferenceScreen> createState() =>
      _AddEditFoodPreferenceScreenState();
}

class _AddEditFoodPreferenceScreenState
    extends State<AddEditFoodPreferenceScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _foodNameCtrl;
  late TextEditingController _notesCtrl;
  late String _category;
  late String _rating;

  @override
  void initState() {
    super.initState();
    final p = widget.preference;
    _foodNameCtrl = TextEditingController(text: p?.foodName ?? '');
    _notesCtrl = TextEditingController(text: p?.notes ?? '');
    _category = p?.category ?? 'dryFood';
    _rating = p?.rating ?? 'likes';
  }

  @override
  void dispose() {
    _foodNameCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final petData = Provider.of<PetData>(context, listen: false);
    final isEditing = widget.preference != null;

    final preference = FoodPreference(
      id: isEditing
          ? widget.preference!.id
          : 'fp_${DateTime.now().millisecondsSinceEpoch}',
      petId: widget.petId,
      foodName: _foodNameCtrl.text.trim(),
      category: _category,
      rating: _rating,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      createdAt: isEditing ? widget.preference!.createdAt : DateTime.now(),
    );

    if (isEditing) {
      petData.updateFoodPreference(preference);
    } else {
      petData.addFoodPreference(preference);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isEditing = widget.preference != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? l10n.editFoodPreference : l10n.addFoodPreference,
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              l10n.save,
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Mama Adı ─────────────────────────────────────────────────
              TextFormField(
                controller: _foodNameCtrl,
                decoration: InputDecoration(
                  labelText: l10n.foodName,
                  prefixIcon: const Icon(Icons.restaurant),
                  border: const OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.pleaseEnterPreferenceName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Kategori ─────────────────────────────────────────────────
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: InputDecoration(
                  labelText: l10n.foodCategoryLabel,
                  prefixIcon: const Icon(Icons.category),
                  border: const OutlineInputBorder(),
                ),
                items:
                    [
                          'dryFood',
                          'wetFood',
                          'treat',
                          'homemade',
                          'supplement',
                          'other',
                        ]
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(_categoryLabel(context, c)),
                          ),
                        )
                        .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 20),

              // ── Değerlendirme ─────────────────────────────────────────────
              Text(
                l10n.ratingLabel,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['loves', 'likes', 'neutral', 'dislikes', 'allergic']
                    .map(
                      (r) => ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ratingIconWidget(r, selected: _rating == r),
                            const SizedBox(width: 4),
                            Text(_ratingLabel(context, r)),
                          ],
                        ),
                        selected: _rating == r,
                        selectedColor: _ratingColor(r).withOpacity(0.25),
                        onSelected: (_) => setState(() => _rating = r),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),

              // ── Notlar ───────────────────────────────────────────────────
              TextFormField(
                controller: _notesCtrl,
                decoration: InputDecoration(
                  labelText: l10n.notes,
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: Text(l10n.save),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _categoryLabel(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'dryFood':
        return l10n.catDryFood;
      case 'wetFood':
        return l10n.catWetFood;
      case 'treat':
        return l10n.catTreat;
      case 'homemade':
        return l10n.catHomemade;
      case 'supplement':
        return l10n.catSupplement;
      default:
        return l10n.other;
    }
  }

  String _ratingLabel(BuildContext context, String rating) {
    final l10n = AppLocalizations.of(context)!;
    switch (rating) {
      case 'loves':
        return l10n.ratingLoves;
      case 'likes':
        return l10n.ratingLikes;
      case 'neutral':
        return l10n.ratingNeutral;
      case 'dislikes':
        return l10n.ratingDislikes;
      case 'allergic':
        return l10n.ratingAllergic;
      default:
        return rating;
    }
  }

  Widget _ratingIconWidget(String rating, {bool selected = false}) {
    final color = selected ? _ratingColor(rating) : Colors.grey;
    switch (rating) {
      case 'loves':
        return Icon(Icons.favorite, size: 14, color: color);
      case 'likes':
        return Icon(Icons.thumb_up, size: 14, color: color);
      case 'neutral':
        return Icon(Icons.sentiment_neutral, size: 14, color: color);
      case 'dislikes':
        return Icon(Icons.thumb_down, size: 14, color: color);
      case 'allergic':
        return Icon(Icons.warning_amber_rounded, size: 14, color: color);
      default:
        return const SizedBox.shrink();
    }
  }

  Color _ratingColor(String rating) {
    switch (rating) {
      case 'loves':
        return Colors.red;
      case 'likes':
        return Colors.green;
      case 'neutral':
        return Colors.grey;
      case 'dislikes':
        return Colors.orange;
      case 'allergic':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }
}
