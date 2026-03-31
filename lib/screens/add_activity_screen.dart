import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:my_pets/l10n/app_localizations.dart';
import 'package:my_pets/utils/localization_utils.dart';
import '../models/pet_models.dart';
import '../providers/pet_provider.dart';

class AddActivityScreen extends StatefulWidget {
  final String petId;
  final PetActivity? activity;

  const AddActivityScreen({super.key, required this.petId, this.activity});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'veterinaryVisit';

  @override
  void initState() {
    super.initState();
    if (widget.activity != null) {
      _initializeWithActivityData();
    }
  }

  void _initializeWithActivityData() {
    final activity = widget.activity!;
    _selectedDate = activity.date;
    _selectedCategory = activity.category;
    _descriptionController.text = activity.description;
    _costController.text = activity.cost?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.activity != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editActivity : l10n.addActivity),
        actions: [TextButton(onPressed: _saveActivity, child: Text(l10n.save))],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildDateSection(context),
            const SizedBox(height: 24),
            _buildCategorySection(context),
            const SizedBox(height: 24),
            _buildDescriptionSection(context),
            const SizedBox(height: 24),
            _buildCostSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.activityDate,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
              subtitle: Text(l10n.selectDate),
              onTap: _selectDate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.category,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                labelText: l10n.selectCategory,
                prefixIcon: Icon(_getCategoryIcon(_selectedCategory)),
              ),
              items: [
                DropdownMenuItem(
                  value: 'veterinaryVisit',
                  child: Row(
                    children: [
                      Icon(_getCategoryIcon('veterinaryVisit'), size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.veterinaryVisit),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'feeding',
                  child: Row(
                    children: [
                      Icon(_getCategoryIcon('feeding'), size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.feeding),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'vaccination',
                  child: Row(
                    children: [
                      Icon(_getCategoryIcon('vaccination'), size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.vaccination),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'grooming',
                  child: Row(
                    children: [
                      Icon(_getCategoryIcon('grooming'), size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.grooming),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'walk',
                  child: Row(
                    children: [
                      Icon(_getCategoryIcon('walk'), size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.walk),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'cageCleaning',
                  child: Row(
                    children: [
                      Icon(_getCategoryIcon('cageCleaning'), size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.cageCleaning),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'training',
                  child: Row(
                    children: [
                      Icon(_getCategoryIcon('training'), size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.training),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'medication',
                  child: Row(
                    children: [
                      Icon(_getCategoryIcon('medication'), size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.medication),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.description,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.enterDescription,
                prefixIcon: const Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterDescription;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getLocalizedCostOptional(context),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _costController,
              decoration: InputDecoration(
                labelText: getLocalizedAmountLabel(context),
                prefixIcon: const Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveActivity() {
    if (_formKey.currentState!.validate()) {
      final petData = Provider.of<PetData>(context, listen: false);

      final activity = PetActivity(
        id: widget.activity?.id ?? 'activity_${Random().nextInt(100000)}',
        petId: widget.petId,
        date: _selectedDate,
        category: _selectedCategory,
        description: _descriptionController.text,
        cost: _costController.text.isEmpty
            ? null
            : double.tryParse(_costController.text),
      );

      if (widget.activity != null) {
        petData.updateActivity(activity);
      } else {
        petData.addActivity(activity);
      }

      Navigator.pop(context);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'veterinaryVisit':
        return Icons.local_hospital;
      case 'feeding':
        return Icons.restaurant;
      case 'vaccination':
        return Icons.vaccines;
      case 'grooming':
        return Icons.content_cut;
      case 'walk':
        return Icons.directions_walk;
      case 'cageCleaning':
        return Icons.cleaning_services;
      case 'training':
        return Icons.school;
      case 'medication':
        return Icons.medication;
      default:
        return Icons.event;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _costController.dispose();
    super.dispose();
  }
}
