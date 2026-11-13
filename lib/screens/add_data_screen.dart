import 'package:flutter/material.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../utils/adaptive_pickers.dart';
import '../models/pet_models.dart';
import '../providers/pet_provider.dart';

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({super.key});

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.add),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: l10n.activity),
            Tab(text: l10n.vaccination),
            Tab(text: l10n.healthReminder),
            Tab(text: l10n.expense),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AddActivityForm(),
          AddVaccinationForm(),
          AddReminderForm(),
          AddExpenseForm(),
        ],
      ),
    );
  }
}

// Base Form for common fields
abstract class BaseDataForm extends StatefulWidget {
  const BaseDataForm({super.key});
}

abstract class BaseDataFormState<T extends BaseDataForm> extends State<T> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPetId;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Widget buildPetSelector(BuildContext context, PetData petData) {
    final l10n = AppLocalizations.of(context)!;
    return DropdownButtonFormField<String>(
      initialValue: _selectedPetId,
      decoration: InputDecoration(
        labelText: l10n.pet,
        prefixIcon: const Icon(Icons.pets),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
      items: petData.pets.map((pet) {
        return DropdownMenuItem(value: pet.id, child: Text(pet.name));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedPetId = value;
        });
      },
      validator: (value) => value == null ? l10n.pleaseSelectPet : null,
    );
  }

  Widget buildDatePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () async {
        final pickedDate = await showAdaptiveDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.date,
          prefixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
        ),
        child: Text(
          _selectedDate != null
              ? DateFormat.yMd().format(_selectedDate!)
              : l10n.selectDate,
        ),
      ),
    );
  }

  Widget buildDescriptionField(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: l10n.description,
        prefixIcon: const Icon(Icons.description),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
      maxLines: 3,
      validator: (value) =>
          value == null || value.isEmpty ? l10n.pleaseEnterDescription : null,
    );
  }

  void saveForm(BuildContext context, VoidCallback onSave) {
    if (_formKey.currentState!.validate()) {
      onSave();
      Navigator.pop(context);
    }
  }
}

class AddActivityForm extends BaseDataForm {
  const AddActivityForm({super.key});

  @override
  State<AddActivityForm> createState() => _AddActivityFormState();
}

class _AddActivityFormState extends BaseDataFormState<AddActivityForm> {
  String _selectedCategory = 'walk';
  late TextEditingController _costController;

  @override
  void initState() {
    super.initState();
    _costController = TextEditingController();
  }

  @override
  void dispose() {
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petData = Provider.of<PetData>(context);
    final l10n = AppLocalizations.of(context)!;

    final categories = {
      'walk': l10n.walk,
      'feeding': l10n.feeding,
      'grooming': l10n.grooming,
      'veterinaryVisit': l10n.veterinaryVisit,
      'training': l10n.training,
    };

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildPetSelector(context, petData),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: l10n.category,
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                    ),
                    items: categories.entries
                        .map(
                          (entry) => DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  buildDatePicker(context),
                  const SizedBox(height: 16),
                  buildDescriptionField(context),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _costController,
                    decoration: InputDecoration(
                      labelText: l10n.cost,
                      prefixIcon: const Icon(Icons.payments),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      prefixText: '${l10n.currencySymbol} ',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: () {
                saveForm(context, () {
                  final newActivity = PetActivity(
                    id: 'act_${DateTime.now().millisecondsSinceEpoch}',
                    petId: _selectedPetId!,
                    date: _selectedDate!,
                    category: _selectedCategory,
                    description: _descriptionController.text,
                    cost: double.tryParse(_costController.text),
                  );
                  petData.addActivity(newActivity);
                });
              },
              child: Text(
                l10n.save,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddVaccinationForm extends BaseDataForm {
  const AddVaccinationForm({super.key});

  @override
  State<AddVaccinationForm> createState() => _AddVaccinationFormState();
}

class _AddVaccinationFormState extends BaseDataFormState<AddVaccinationForm> {
  late TextEditingController _vaccineNameController;
  DateTime? _nextDueDate;

  @override
  void initState() {
    super.initState();
    _vaccineNameController = TextEditingController();
  }

  @override
  void dispose() {
    _vaccineNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petData = Provider.of<PetData>(context);
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildPetSelector(context, petData),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _vaccineNameController,
                    decoration: InputDecoration(
                      labelText: l10n.vaccineName,
                      prefixIcon: const Icon(Icons.vaccines),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? l10n.pleaseEnterVaccineName
                        : null,
                  ),
                  const SizedBox(height: 16),
                  buildDatePicker(context),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final pickedDate = await showAdaptiveDatePicker(
                        context: context,
                        initialDate:
                            _nextDueDate ??
                            DateTime.now().add(const Duration(days: 365)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365 * 5),
                        ),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _nextDueDate = pickedDate;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.nextDueDate,
                        prefixIcon: const Icon(Icons.event_repeat),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                      child: Text(
                        _nextDueDate != null
                            ? DateFormat.yMd().format(_nextDueDate!)
                            : l10n.selectDate,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: () {
                saveForm(context, () {
                  final newVaccination = Vaccination(
                    id: 'vac_${DateTime.now().millisecondsSinceEpoch}',
                    petId: _selectedPetId!,
                    vaccineName: _vaccineNameController.text,
                    vaccineDate: _selectedDate!,
                    nextDueDate: _nextDueDate,
                  );
                  petData.addVaccination(newVaccination);
                });
              },
              child: Text(
                l10n.save,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddReminderForm extends BaseDataForm {
  const AddReminderForm({super.key});

  @override
  State<AddReminderForm> createState() => _AddReminderFormState();
}

class _AddReminderFormState extends BaseDataFormState<AddReminderForm> {
  late TextEditingController _titleController;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petData = Provider.of<PetData>(context);
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildPetSelector(context, petData),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: l10n.title,
                      prefixIcon: const Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? l10n.pleaseEnterTitle
                        : null,
                  ),
                  const SizedBox(height: 16),
                  buildDatePicker(context),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final pickedTime = await showAdaptiveTimePicker(
                        context: context,
                        initialTime: _selectedTime ?? TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _selectedTime = pickedTime;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.time,
                        prefixIcon: const Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                      child: Text(
                        _selectedTime != null
                            ? _selectedTime!.format(context)
                            : l10n.selectTime,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: () {
                saveForm(context, () {
                  final newReminder = HealthReminder(
                    id: 'rem_${DateTime.now().millisecondsSinceEpoch}',
                    petId: _selectedPetId!,
                    title: _titleController.text,
                    reminderDate: _selectedDate!,
                    reminderTime: _selectedTime!,
                  );
                  petData.addReminder(newReminder);
                });
              },
              child: Text(
                l10n.save,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddExpenseForm extends BaseDataForm {
  const AddExpenseForm({super.key});

  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends BaseDataFormState<AddExpenseForm> {
  String _selectedCategory = 'food';
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petData = Provider.of<PetData>(context);
    final l10n = AppLocalizations.of(context)!;

    final categories = {
      'food': l10n.food,
      'medical': l10n.medical,
      'toys': l10n.toys,
      'accessories': l10n.accessories,
      'other': l10n.other,
    };

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildPetSelector(context, petData),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: l10n.category,
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                    ),
                    items: categories.entries
                        .map(
                          (entry) => DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: l10n.amount,
                      prefixIcon: const Icon(Icons.payments),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      prefixText: '${l10n.currencySymbol} ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseEnterAmount;
                      }
                      if (double.tryParse(value) == null) {
                        return l10n.pleaseEnterValidNumber;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  buildDatePicker(context),
                  const SizedBox(height: 16),
                  buildDescriptionField(context),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: () {
                saveForm(context, () {
                  final newExpense = Expense(
                    id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
                    petId: _selectedPetId!,
                    amount: double.parse(_amountController.text),
                    category: _selectedCategory,
                    date: _selectedDate!,
                    description: _descriptionController.text,
                  );
                  petData.addExpense(newExpense);
                });
              },
              child: Text(
                l10n.save,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
