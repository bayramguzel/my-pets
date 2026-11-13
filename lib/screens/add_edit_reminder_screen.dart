import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import '../utils/adaptive_pickers.dart';
import '../models/pet_models.dart';
import '../providers/pet_provider.dart';

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
                        final pickedDate = await showAdaptiveDatePicker(
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
                        final pickedTime = await showAdaptiveTimePicker(
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
