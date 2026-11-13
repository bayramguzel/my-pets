import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import '../utils/adaptive_pickers.dart';
import '../models/pet_models.dart';
import '../providers/pet_provider.dart';

class AddEditExpenseScreen extends StatefulWidget {
  final String petId;
  final Expense? expense;

  const AddEditExpenseScreen({super.key, required this.petId, this.expense});

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.expense?.amount.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.expense?.description ?? '',
    );
    _selectedCategory = widget.expense?.category ?? 'food';
    _selectedDate = widget.expense?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final petData = Provider.of<PetData>(context, listen: false);
    final isEditing = widget.expense != null;

    final categories = {
      'food': l10n.food,
      'medical': l10n.medical,
      'toys': l10n.toys,
      'accessories': l10n.accessories,
      'other': l10n.other,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editExpense : l10n.addExpense),
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
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: l10n.amount,
                        prefixIcon: const Icon(Icons.payments),
                        prefixText: '${l10n.currencySymbol} ',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.pleaseEnterAmount;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: l10n.category,
                        prefixIcon: const Icon(Icons.category),
                      ),
                      items: categories.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        prefixIcon: const Icon(Icons.description),
                      ),
                      maxLines: 3,
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
                          firstDate: DateTime(2000),
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final expense = Expense(
                    id:
                        widget.expense?.id ??
                        'exp_${DateTime.now().millisecondsSinceEpoch}',
                    petId: widget.petId,
                    amount: double.parse(_amountController.text),
                    category: _selectedCategory,
                    date: _selectedDate,
                    description: _descriptionController.text,
                  );

                  if (isEditing) {
                    petData.updateExpense(expense);
                  } else {
                    petData.addExpense(expense);
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
