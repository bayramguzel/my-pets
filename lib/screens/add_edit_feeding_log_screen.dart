import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import '../utils/adaptive_pickers.dart';
import '../models/pet_models.dart';
import '../providers/pet_provider.dart';

class AddEditFeedingLogScreen extends StatefulWidget {
  final String petId;
  final FeedingLog? log;

  const AddEditFeedingLogScreen({super.key, required this.petId, this.log});

  @override
  State<AddEditFeedingLogScreen> createState() =>
      _AddEditFeedingLogScreenState();
}

class _AddEditFeedingLogScreenState extends State<AddEditFeedingLogScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _foodNameCtrl;
  late TextEditingController _portionCtrl;
  late TextEditingController _notesCtrl;

  late String _mealType;
  late String _portionUnit;
  late bool _isEaten;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final l = widget.log;
    _foodNameCtrl = TextEditingController(text: l?.foodName ?? '');
    _portionCtrl = TextEditingController(
      text: l?.portionGiven != null ? l!.portionGiven!.toStringAsFixed(0) : '',
    );
    _notesCtrl = TextEditingController(text: l?.notes ?? '');
    _mealType = l?.mealType ?? 'breakfast';
    _portionUnit = l?.portionUnit ?? 'gram';
    _isEaten = l?.isEaten ?? true;
    _selectedDate = l?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _foodNameCtrl.dispose();
    _portionCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showAdaptiveDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final petData = Provider.of<PetData>(context, listen: false);
    final isEditing = widget.log != null;

    final log = FeedingLog(
      id: isEditing
          ? widget.log!.id
          : 'fl_${DateTime.now().millisecondsSinceEpoch}',
      petId: widget.petId,
      date: _selectedDate,
      mealType: _mealType,
      foodName: _foodNameCtrl.text.trim(),
      portionGiven: double.tryParse(_portionCtrl.text),
      portionUnit: _portionUnit,
      isEaten: _isEaten,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );

    if (isEditing) {
      petData.updateFeedingLog(log);
    } else {
      petData.addFeedingLog(log);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isEditing = widget.log != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editFeedingLog : l10n.addFeedingLog),
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
              // ── Date ────────────────────────────────────────────────────
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: Text(l10n.date),
                subtitle: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                trailing: TextButton(
                  onPressed: _pickDate,
                  child: Text(l10n.selectDate),
                ),
              ),
              const Divider(),
              const SizedBox(height: 8),

              // ── Meal type ────────────────────────────────────────────────
              DropdownButtonFormField<String>(
                initialValue: _mealType,
                decoration: InputDecoration(
                  labelText: l10n.mealType,
                  prefixIcon: const Icon(Icons.restaurant_menu),
                  border: const OutlineInputBorder(),
                ),
                items: ['breakfast', 'lunch', 'dinner', 'snack']
                    .map(
                      (m) => DropdownMenuItem(
                        value: m,
                        child: Row(
                          children: [
                            _mealIcon(m),
                            const SizedBox(width: 8),
                            Text(_mealLabel(context, m)),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _mealType = v!),
              ),
              const SizedBox(height: 12),

              // ── Food name ────────────────────────────────────────────────
              TextFormField(
                controller: _foodNameCtrl,
                decoration: InputDecoration(
                  labelText: l10n.foodName,
                  prefixIcon: const Icon(Icons.set_meal),
                  border: const OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.pleaseEnterFoodName
                    : null,
              ),
              const SizedBox(height: 12),

              // ── Portion given + unit ─────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _portionCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.portionGiven,
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

              // ── Eaten switch ─────────────────────────────────────────────
              Card(
                child: SwitchListTile(
                  title: Text(l10n.eaten),
                  value: _isEaten,
                  secondary: Icon(
                    _isEaten ? Icons.check_circle : Icons.cancel,
                    color: _isEaten ? Colors.green : Colors.red,
                  ),
                  onChanged: (v) => setState(() => _isEaten = v),
                ),
              ),
              const SizedBox(height: 12),

              // ── Notes ────────────────────────────────────────────────────
              TextFormField(
                controller: _notesCtrl,
                decoration: InputDecoration(
                  labelText: l10n.notes,
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
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

  String _mealLabel(BuildContext context, String m) {
    final l10n = AppLocalizations.of(context)!;
    switch (m) {
      case 'breakfast':
        return l10n.breakfast;
      case 'lunch':
        return l10n.lunch;
      case 'dinner':
        return l10n.dinner;
      case 'snack':
        return l10n.snack;
      default:
        return m;
    }
  }

  Icon _mealIcon(String m) {
    switch (m) {
      case 'breakfast':
        return const Icon(Icons.wb_sunny, size: 18, color: Colors.orange);
      case 'lunch':
        return const Icon(Icons.light_mode, size: 18, color: Colors.amber);
      case 'dinner':
        return const Icon(
          Icons.nightlight_round,
          size: 18,
          color: Colors.indigo,
        );
      case 'snack':
        return const Icon(Icons.cookie, size: 18, color: Colors.brown);
      default:
        return const Icon(Icons.restaurant, size: 18);
    }
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
