import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import '../models/pet_models.dart';
import '../providers/pet_provider.dart';

class AddEditVaccinationScreen extends StatefulWidget {
  final String petId;
  final Vaccination? vaccination;

  const AddEditVaccinationScreen({
    super.key,
    required this.petId,
    this.vaccination,
  });

  @override
  State<AddEditVaccinationScreen> createState() =>
      _AddEditVaccinationScreenState();
}

class _AddEditVaccinationScreenState extends State<AddEditVaccinationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _vetController;
  late TextEditingController _notesController;
  late DateTime _vaccineDate;
  DateTime? _nextDueDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.vaccination?.vaccineName ?? '',
    );
    _vetController = TextEditingController(
      text: widget.vaccination?.veterinarian ?? '',
    );
    _notesController = TextEditingController(
      text: widget.vaccination?.notes ?? '',
    );
    _vaccineDate = widget.vaccination?.vaccineDate ?? DateTime.now();
    _nextDueDate = widget.vaccination?.nextDueDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _vetController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final petData = Provider.of<PetData>(context, listen: false);
    final isEditing = widget.vaccination != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editVaccination : l10n.addVaccination),
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.vaccineName,
                        prefixIcon: const Icon(Icons.vaccines),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.pleaseEnterVaccineName;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _vetController,
                      decoration: InputDecoration(
                        labelText: l10n.veterinarian,
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(l10n.vaccineDate),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(_vaccineDate),
                      ),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _vaccineDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _vaccineDate = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.event_repeat),
                      title: Text(l10n.nextDueDate),
                      subtitle: Text(
                        _nextDueDate != null
                            ? DateFormat('dd/MM/yyyy').format(_nextDueDate!)
                            : l10n.selectDate,
                      ),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate:
                              _nextDueDate ??
                              DateTime.now().add(const Duration(days: 365)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 1095),
                          ),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _nextDueDate = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: l10n.notes,
                        prefixIcon: const Icon(Icons.note),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final vaccination = Vaccination(
                    id:
                        widget.vaccination?.id ??
                        'vac_${DateTime.now().millisecondsSinceEpoch}',
                    petId: widget.petId,
                    vaccineName: _nameController.text,
                    vaccineDate: _vaccineDate,
                    nextDueDate: _nextDueDate,
                    veterinarian: _vetController.text.isEmpty
                        ? null
                        : _vetController.text,
                    notes: _notesController.text.isEmpty
                        ? null
                        : _notesController.text,
                  );

                  if (isEditing) {
                    petData.updateVaccination(vaccination);
                  } else {
                    petData.addVaccination(vaccination);
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
