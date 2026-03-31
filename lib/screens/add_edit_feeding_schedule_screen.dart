import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import '../models/pet_models.dart';
import '../providers/pet_provider.dart';

class AddEditFeedingScheduleScreen extends StatefulWidget {
  final String petId;
  final FeedingSchedule? schedule;

  const AddEditFeedingScheduleScreen({
    super.key,
    required this.petId,
    this.schedule,
  });

  @override
  State<AddEditFeedingScheduleScreen> createState() =>
      _AddEditFeedingScheduleScreenState();
}

class _AddEditFeedingScheduleScreenState
    extends State<AddEditFeedingScheduleScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _foodBrandCtrl;
  late TextEditingController _mealsPerDayCtrl;
  late TextEditingController _portionSizeCtrl;
  late TextEditingController _waterCtrl;
  late TextEditingController _notesCtrl;
  late TextEditingController _mealTimeCtrl;
  late TextEditingController _favFoodCtrl;
  late TextEditingController _dislikedFoodCtrl;

  late String _portionUnit;
  late List<String> _mealTimes;
  late List<String> _favoriteFoods;
  late List<String> _dislikedFoods;

  @override
  void initState() {
    super.initState();
    final s = widget.schedule;
    _foodBrandCtrl = TextEditingController(text: s?.foodBrand ?? '');
    _mealsPerDayCtrl = TextEditingController(
      text: s != null ? s.mealsPerDay.toString() : '2',
    );
    _portionSizeCtrl = TextEditingController(
      text: s?.portionSizeGram != null
          ? s!.portionSizeGram!.toStringAsFixed(0)
          : '',
    );
    _waterCtrl = TextEditingController(
      text: s?.dailyWaterMl != null ? s!.dailyWaterMl.toString() : '',
    );
    _notesCtrl = TextEditingController(text: s?.notes ?? '');
    _mealTimeCtrl = TextEditingController();
    _favFoodCtrl = TextEditingController();
    _dislikedFoodCtrl = TextEditingController();
    _portionUnit = s?.portionUnit ?? 'gram';
    _mealTimes = List<String>.from(s?.mealTimes ?? []);
    _favoriteFoods = List<String>.from(s?.favoriteFoods ?? []);
    _dislikedFoods = List<String>.from(s?.dislikedFoods ?? []);
  }

  @override
  void dispose() {
    _foodBrandCtrl.dispose();
    _mealsPerDayCtrl.dispose();
    _portionSizeCtrl.dispose();
    _waterCtrl.dispose();
    _notesCtrl.dispose();
    _mealTimeCtrl.dispose();
    _favFoodCtrl.dispose();
    _dislikedFoodCtrl.dispose();
    super.dispose();
  }

  void _addMealTime() {
    final t = _mealTimeCtrl.text.trim();
    if (t.isNotEmpty &&
        RegExp(r'^\d{1,2}:\d{2}$').hasMatch(t) &&
        !_mealTimes.contains(t)) {
      setState(() => _mealTimes.add(t));
      _mealTimeCtrl.clear();
    }
  }

  void _addFavoriteFood() {
    final f = _favFoodCtrl.text.trim();
    if (f.isNotEmpty && !_favoriteFoods.contains(f)) {
      setState(() => _favoriteFoods.add(f));
      _favFoodCtrl.clear();
    }
  }

  void _addDislikedFood() {
    final f = _dislikedFoodCtrl.text.trim();
    if (f.isNotEmpty && !_dislikedFoods.contains(f)) {
      setState(() => _dislikedFoods.add(f));
      _dislikedFoodCtrl.clear();
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final schedule = FeedingSchedule(
      petId: widget.petId,
      foodBrand: _foodBrandCtrl.text.trim().isEmpty
          ? null
          : _foodBrandCtrl.text.trim(),
      mealsPerDay: int.tryParse(_mealsPerDayCtrl.text) ?? 2,
      mealTimes: List.from(_mealTimes),
      portionSizeGram: double.tryParse(_portionSizeCtrl.text),
      portionUnit: _portionUnit,
      favoriteFoods: List.from(_favoriteFoods),
      dislikedFoods: List.from(_dislikedFoods),
      dailyWaterMl: int.tryParse(_waterCtrl.text),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );

    Provider.of<PetData>(
      context,
      listen: false,
    ).upsertFeedingSchedule(schedule);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isEditing = widget.schedule != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? l10n.editFeedingProfile : l10n.addFeedingProfile,
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
              // ── Food Brand ──────────────────────────────────────────────
              _SectionHeader(title: l10n.feedingSchedule),
              const SizedBox(height: 8),
              TextFormField(
                controller: _foodBrandCtrl,
                decoration: InputDecoration(
                  labelText: l10n.foodBrand,
                  prefixIcon: const Icon(Icons.restaurant),
                  border: const OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),

              // ── Meals per day ────────────────────────────────────────────
              TextFormField(
                controller: _mealsPerDayCtrl,
                decoration: InputDecoration(
                  labelText: l10n.mealsPerDay,
                  prefixIcon: const Icon(Icons.format_list_numbered),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _RangeInputFormatter(1, 10),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return l10n.pleaseEnterMealsPerDay;
                  }
                  final n = int.tryParse(v);
                  if (n == null || n < 1 || n > 10) {
                    return l10n.pleaseEnterValidNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // ── Portion size + unit ──────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _portionSizeCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.portionSize,
                        prefixIcon: const Icon(Icons.scale),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      initialValue: _portionUnit,
                      decoration: InputDecoration(
                        labelText: l10n.portionUnit,
                        border: const OutlineInputBorder(),
                      ),
                      items: ['gram', 'ml', 'scoop']
                          .map(
                            (u) => DropdownMenuItem(
                              value: u,
                              child: Text(_unitLabel(context, u)),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _portionUnit = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Daily water ──────────────────────────────────────────────
              TextFormField(
                controller: _waterCtrl,
                decoration: InputDecoration(
                  labelText: l10n.dailyWaterMl,
                  prefixIcon: const Icon(Icons.water_drop),
                  suffixText: 'ml',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 20),

              // ── Meal times ───────────────────────────────────────────────
              _SectionHeader(title: l10n.mealTimes),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _mealTimeCtrl,
                      decoration: InputDecoration(
                        hintText: l10n.mealTimesHint,
                        prefixIcon: const Icon(Icons.access_time),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addMealTime,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _mealTimes
                    .map(
                      (t) => Chip(
                        label: Text(t),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => setState(() => _mealTimes.remove(t)),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),

              // ── Favorite foods ───────────────────────────────────────────
              _SectionHeader(title: l10n.favoriteFoods),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _favFoodCtrl,
                      decoration: InputDecoration(
                        hintText: l10n.addFavoriteFood,
                        prefixIcon: const Icon(Icons.favorite),
                        border: const OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                      onFieldSubmitted: (_) => _addFavoriteFood(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addFavoriteFood,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _favoriteFoods
                    .map(
                      (f) => Chip(
                        label: Text(f),
                        avatar: const Icon(Icons.favorite, size: 14),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () =>
                            setState(() => _favoriteFoods.remove(f)),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),

              // ── Disliked foods ───────────────────────────────────────────
              _SectionHeader(title: l10n.dislikedFoods),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dislikedFoodCtrl,
                      decoration: InputDecoration(
                        hintText: l10n.addDislikedFood,
                        prefixIcon: const Icon(Icons.thumb_down_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                      onFieldSubmitted: (_) => _addDislikedFood(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addDislikedFood,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _dislikedFoods
                    .map(
                      (f) => Chip(
                        label: Text(f),
                        avatar: const Icon(
                          Icons.thumb_down,
                          size: 14,
                          color: Colors.orange,
                        ),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () =>
                            setState(() => _dislikedFoods.remove(f)),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),

              // ── Notes ────────────────────────────────────────────────────
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

  String _unitLabel(BuildContext context, String unit) {
    final l10n = AppLocalizations.of(context)!;
    switch (unit) {
      case 'gram':
        return l10n.gram;
      case 'ml':
        return l10n.ml;
      case 'scoop':
        return l10n.scoop;
      default:
        return unit;
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

/// Limits numeric input to a range.
class _RangeInputFormatter extends TextInputFormatter {
  final int min;
  final int max;
  _RangeInputFormatter(this.min, this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final n = int.tryParse(newValue.text);
    if (n == null || n < min || n > max) return oldValue;
    return newValue;
  }
}
