import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:my_pets/l10n/app_localizations.dart';
import 'package:my_pets/utils/localization_utils.dart';
import 'dart:io';
import '../widgets/banner_ad_widget.dart';
import '../models/pet_models.dart';
import '../providers/pet_provider.dart';
import 'add_edit_pet_screen.dart' as pet_screen;
import 'add_activity_screen.dart';
import 'add_edit_vaccination_screen.dart';
import 'add_edit_reminder_screen.dart';
import 'add_edit_expense_screen.dart';
import 'add_edit_feeding_schedule_screen.dart';
import 'add_edit_feeding_log_screen.dart';
import 'add_edit_food_preference_screen.dart';
import 'pet_qr_screen.dart';

class PetDetailScreen extends StatefulWidget {
  final Pet pet;

  const PetDetailScreen({super.key, required this.pet});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      pet_screen.AddEditPetScreen(pet: widget.pet),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmation(context);
              } else if (value == 'qr_code') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetQRScreen(pet: widget.pet),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'qr_code',
                child: Row(
                  children: [
                    const Icon(Icons.qr_code),
                    const SizedBox(width: 8),
                    Text(l10n.qrCode),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(l10n.delete),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: l10n.petDetails),
            Tab(text: l10n.activities),
            Tab(text: l10n.health),
            Tab(text: l10n.expenses),
            Tab(text: l10n.nutritionTab),
          ],
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: BannerAdWidget(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDetailsTab(context),
                _buildActivitiesTab(context),
                _buildHealthTab(context),
                _buildExpensesTab(context),
                _buildNutritionTab(context),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildDetailsTab(BuildContext context) {
    // final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      children: [
        _buildPhotoCard(context),
        const SizedBox(height: 16),
        _buildBasicInfoCard(context),
        const SizedBox(height: 16),
        _buildHealthInfoCard(context),
        const SizedBox(height: 16),
        _buildVeterinarianCard(context),
        const SizedBox(height: 16),
        _buildAdditionalInfoCard(context),
      ],
    );
  }

  Widget _buildPhotoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: _getPetImageProvider(widget.pet.photoUrl),
              onBackgroundImageError: (exception, stackTrace) {},
              child: _getPetImageProvider(widget.pet.photoUrl) == null
                  ? Icon(Icons.pets, size: 40, color: Colors.grey[600])
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              widget.pet.name,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              getPetTypeTranslation(context, widget.pet.type),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.basicInfo,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (widget.pet.breed != null)
              _buildInfoRow(l10n.breed, widget.pet.breed!),
            if (widget.pet.gender != null)
              _buildInfoRow(
                l10n.gender,
                _getGenderText(context, widget.pet.gender!),
              ),
            if (widget.pet.birthDate != null) ...[
              _buildInfoRow(
                l10n.birthDate,
                DateFormat('dd/MM/yyyy').format(widget.pet.birthDate!),
              ),
              _buildInfoRow(
                l10n.age,
                '${widget.pet.ageInYears} ${l10n.years}, ${widget.pet.ageInMonths % 12} ${l10n.months}',
              ),
            ],
            if (widget.pet.weight != null)
              _buildInfoRow(l10n.weight, '${widget.pet.weight} ${l10n.kg}'),
            if (widget.pet.nationalId != null)
              _buildInfoRow(l10n.nationalId, widget.pet.nationalId!),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthInfoCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.healthInfo,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              l10n.healthStatus,
              _getHealthStatusText(context, widget.pet.healthStatus),
            ),
            if (widget.pet.microchipId != null)
              _buildInfoRow(l10n.microchipId, widget.pet.microchipId!),
            if (widget.pet.allergies != null)
              _buildInfoRow(l10n.allergies, widget.pet.allergies!),
            if (widget.pet.currentMedications != null)
              _buildInfoRow(
                l10n.currentMedications,
                widget.pet.currentMedications!,
              ),
            if (widget.pet.nextAppointment != null)
              _buildInfoRow(
                l10n.nextAppointment,
                DateFormat(
                  'dd/MM/yyyy HH:mm',
                ).format(widget.pet.nextAppointment!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVeterinarianCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.pet.veterinarianName == null &&
        widget.pet.veterinarianContact == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.veterinarianInfo,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (widget.pet.veterinarianName != null)
              _buildInfoRow(
                l10n.veterinarianName,
                widget.pet.veterinarianName!,
              ),
            if (widget.pet.veterinarianContact != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.phone),
                title: Text(widget.pet.veterinarianContact!),
                trailing: IconButton(
                  icon: const Icon(Icons.call),
                  onPressed: () =>
                      _makePhoneCall(widget.pet.veterinarianContact!),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.additionalInfoCard,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (widget.pet.insurance != null)
              _buildInfoRow(l10n.insurance, widget.pet.insurance!),
            if (widget.pet.emergencyContact != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.emergency),
                title: Text(widget.pet.emergencyContact!),
                trailing: IconButton(
                  icon: const Icon(Icons.call),
                  onPressed: () => _makePhoneCall(widget.pet.emergencyContact!),
                ),
              ),
            if (widget.pet.medicalHistory != null)
              _buildInfoRow(l10n.medicalHistory, widget.pet.medicalHistory!),
            if (widget.pet.notes != null)
              _buildInfoRow(
                l10n.notes,
                getLocalizedContent(context, widget.pet.notes!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesTab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<PetData>(
      builder: (context, petData, child) {
        final activities = petData.getActivitiesForPet(widget.pet.id, null);

        if (activities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_note, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  l10n.noActivitiesFound,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _addActivity(context),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addActivity),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getCategoryColor(activity.category),
                  child: Icon(
                    _getCategoryIcon(activity.category),
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  _getCategoryTranslation(context, activity.category),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(getLocalizedContent(context, activity.description)),
                    Text(
                      DateFormat('dd/MM/yyyy').format(activity.date),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                trailing: activity.cost != null
                    ? Text(
                        '${l10n.currencySymbol}${activity.cost!.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHealthTab(BuildContext context) {
    return Consumer<PetData>(
      builder: (context, petData, child) {
        final vaccinations = petData.getVaccinationsForPet(widget.pet.id);
        final reminders = petData.getRemindersForPet(widget.pet.id);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          children: [
            _buildVaccinationsSection(context, vaccinations),
            const SizedBox(height: 16),
            _buildRemindersSection(context, reminders),
          ],
        );
      },
    );
  }

  Widget _buildVaccinationsSection(
    BuildContext context,
    List<Vaccination> vaccinations,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.vaccinationRecord,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addVaccination(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (vaccinations.isEmpty)
              Text(l10n.noVaccinationRecord)
            else
              ...vaccinations.map(
                (vaccination) => ListTile(
                  leading: const Icon(Icons.vaccines, color: Colors.green),
                  title: Text(
                    getLocalizedContent(context, vaccination.vaccineName),
                  ),
                  subtitle: Text(
                    '${l10n.dateLabel}: ${DateFormat('dd/MM/yyyy').format(vaccination.vaccineDate)}',
                  ),
                  trailing: vaccination.nextDueDate != null
                      ? Text(
                          '${l10n.nextLabel}: ${DateFormat('dd/MM/yyyy').format(vaccination.nextDueDate!)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemindersSection(
    BuildContext context,
    List<HealthReminder> reminders,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.healthReminders,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addReminder(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (reminders.isEmpty)
              Text(l10n.noRemindersFound)
            else
              ...reminders.map(
                (reminder) => ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: reminder.isActive ? Colors.blue : Colors.grey,
                  ),
                  title: Text(reminder.title),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(
                      DateTime(
                        reminder.reminderDate.year,
                        reminder.reminderDate.month,
                        reminder.reminderDate.day,
                        reminder.reminderTime.hour,
                        reminder.reminderTime.minute,
                      ),
                    ),
                  ),
                  trailing: Switch(
                    value: reminder.isActive,
                    onChanged: (value) {
                      final updatedReminder = HealthReminder(
                        id: reminder.id,
                        petId: reminder.petId,
                        title: reminder.title,
                        reminderDate: reminder.reminderDate,
                        reminderTime: reminder.reminderTime,
                        repeatType: reminder.repeatType,
                        isActive: value,
                      );
                      Provider.of<PetData>(
                        context,
                        listen: false,
                      ).updateReminder(updatedReminder);
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesTab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<PetData>(
      builder: (context, petData, child) {
        final expenses = petData.getExpensesForPet(widget.pet.id);
        final totalExpenses = petData.getTotalExpensesForPet(widget.pet.id);

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.totalExpenses,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${l10n.currencySymbol}${totalExpenses.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: expenses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noExpensesFound,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => _addExpense(context),
                            icon: const Icon(Icons.add),
                            label: Text(l10n.addExpense),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getExpenseCategoryColor(
                                expense.category,
                              ),
                              child: Icon(
                                _getExpenseCategoryIcon(expense.category),
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              getLocalizedContent(context, expense.description),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getExpenseCategoryText(
                                    context,
                                    expense.category,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(expense.date),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            trailing: Text(
                              '${l10n.currencySymbol}${expense.amount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String label;
    VoidCallback action;

    switch (_tabController.index) {
      case 1:
        label = l10n.addActivity;
        action = () => _addActivity(context);
        break;
      case 2:
        label = l10n.addInfo;
        action = () => _showHealthOptions(context);
        break;
      case 3:
        label = l10n.addExpense;
        action = () => _addExpense(context);
        break;
      case 4:
        label = l10n.addFeedingLog;
        action = () => _addFeedingLog(context);
        break;
      default:
        label = l10n.addInfo;
        action = () => _addActivity(context);
    }

    return FloatingActionButton.extended(
      onPressed: action,
      icon: const Icon(Icons.add),
      label: Text(label),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final labelWidth = (constraints.maxWidth * 0.38).clamp(90.0, 140.0);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: labelWidth,
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(child: Text(value)),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.delete),
          content: Text(l10n.deletePetConfirmation(widget.pet.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Provider.of<PetData>(
                  context,
                  listen: false,
                ).deletePet(widget.pet.id);
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close pet detail screen
              },
              child: Text(
                l10n.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addActivity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddActivityScreen(petId: widget.pet.id),
      ),
    );
  }

  void _addVaccination(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditVaccinationScreen(petId: widget.pet.id),
      ),
    );
  }

  void _addReminder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditReminderScreen(petId: widget.pet.id),
      ),
    );
  }

  void _addExpense(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditExpenseScreen(petId: widget.pet.id),
      ),
    );
  }

  void _addFeedingLog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditFeedingLogScreen(petId: widget.pet.id),
      ),
    );
  }

  void _addFoodPreference(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditFoodPreferenceScreen(petId: widget.pet.id),
      ),
    );
  }

  // ── Nutrition tab ──────────────────────────────────────────────────────
  Widget _buildNutritionTab(BuildContext context) {
    return Consumer<PetData>(
      builder: (context, petData, _) {
        final schedule = petData.getFeedingScheduleForPet(widget.pet.id);
        final logs = petData.getFeedingLogsForPet(widget.pet.id);
        final preferences = petData.getFoodPreferencesForPet(widget.pet.id);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          children: [
            _buildFeedingScheduleCard(context, schedule),
            const SizedBox(height: 16),
            _buildCalcCard(context, schedule),
            const SizedBox(height: 16),
            _buildFoodPreferencesCard(context, preferences),
            const SizedBox(height: 16),
            _buildFeedingLogSection(context, logs),
          ],
        );
      },
    );
  }

  Widget _buildFoodPreferencesCard(
    BuildContext context,
    List<FoodPreference> preferences,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star_rate_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.foodPreferences,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  tooltip: l10n.addFoodPreference,
                  onPressed: () => _addFoodPreference(context),
                ),
              ],
            ),
            if (preferences.isEmpty) ...[
              const SizedBox(height: 12),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.noFoodPreferences,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _addFoodPreference(context),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addFoodPreference),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 8),
              ...preferences.map(
                (pref) => _FoodPreferenceTile(
                  preference: pref,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditFoodPreferenceScreen(
                          petId: widget.pet.id,
                          preference: pref,
                        ),
                      ),
                    );
                  },
                  onDelete: () {
                    Provider.of<PetData>(
                      context,
                      listen: false,
                    ).deleteFoodPreference(pref.id);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeedingScheduleCard(
    BuildContext context,
    FeedingSchedule? schedule,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.restaurant,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.feedingProfile,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    schedule == null ? Icons.add : Icons.edit,
                    size: 20,
                  ),
                  tooltip: schedule == null
                      ? l10n.addFeedingProfile
                      : l10n.editFeedingProfile,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditFeedingScheduleScreen(
                          petId: widget.pet.id,
                          schedule: schedule,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            if (schedule == null) ...[
              const SizedBox(height: 12),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.no_meals, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      l10n.noFeedingProfile,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEditFeedingScheduleScreen(
                              petId: widget.pet.id,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addFeedingProfile),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 4),
              if (schedule.foodBrand != null)
                _buildInfoRow(l10n.foodBrand, schedule.foodBrand!),
              _buildInfoRow(
                l10n.mealsPerDay,
                '${schedule.mealsPerDay}x / ${l10n.daily}',
              ),
              if (schedule.portionSizeGram != null)
                _buildInfoRow(
                  l10n.portionSize,
                  '${schedule.portionSizeGram!.toStringAsFixed(0)} '
                  '${_unitLabel(context, schedule.portionUnit)}',
                ),
              if (schedule.dailyWaterMl != null)
                _buildInfoRow(l10n.dailyWaterMl, '${schedule.dailyWaterMl} ml'),
              if (schedule.mealTimes.isNotEmpty) ...[
                const SizedBox(height: 4),
                _buildInfoRow(l10n.mealTimes, schedule.mealTimes.join('  •  ')),
              ],
              if (schedule.favoriteFoods.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.favoriteFoods,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: schedule.favoriteFoods
                      .map(
                        (f) => Chip(
                          label: Text(f),
                          avatar: const Icon(
                            Icons.favorite,
                            size: 14,
                            color: Colors.red,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
              ],
              if (schedule.dislikedFoods.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.dislikedFoods,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: schedule.dislikedFoods
                      .map(
                        (f) => Chip(
                          label: Text(f),
                          avatar: const Icon(
                            Icons.thumb_down,
                            size: 14,
                            color: Colors.orange,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
              ],
              if (schedule.notes != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow(l10n.notes, schedule.notes!),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCalcCard(BuildContext context, FeedingSchedule? schedule) {
    final l10n = AppLocalizations.of(context)!;
    final pet = widget.pet;
    if (pet.weight == null) return const SizedBox.shrink();

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.feedingStats,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                    label: l10n.dailyCalories,
                    value: '${pet.dailyCalories} kcal',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatTile(
                    icon: Icons.water_drop,
                    color: Colors.blue,
                    label: l10n.waterRequirement,
                    value: '${pet.waterRequirement} ml',
                  ),
                ),
              ],
            ),
            if (schedule != null && schedule.portionSizeGram != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: Icons.restaurant,
                      color: Colors.green,
                      label: l10n.portionSize,
                      value:
                          '${schedule.portionSizeGram!.toStringAsFixed(0)} '
                          '${_unitLabel(context, schedule.portionUnit)}',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.format_list_numbered,
                      color: Colors.purple,
                      label: l10n.mealsPerDay,
                      value: '${schedule.mealsPerDay}x',
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeedingLogSection(BuildContext context, List<FeedingLog> logs) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.feedingLog,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  tooltip: l10n.addFeedingLog,
                  onPressed: () => _addFeedingLog(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (logs.isEmpty)
              Center(
                child: Text(
                  l10n.noFeedingLogFound,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              )
            else
              ...logs.map(
                (log) => _FeedingLogTile(
                  log: log,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditFeedingLogScreen(
                          petId: widget.pet.id,
                          log: log,
                        ),
                      ),
                    );
                  },
                  onDelete: () {
                    Provider.of<PetData>(
                      context,
                      listen: false,
                    ).deleteFeedingLog(log.id);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showHealthOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.vaccines),
                title: Text(l10n.addVaccination),
                onTap: () {
                  Navigator.pop(context);
                  _addVaccination(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(l10n.addReminder),
                onTap: () {
                  Navigator.pop(context);
                  _addReminder(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Phone call functionality disabled
    // final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    // await launchUrl(launchUri);
  }

  String _getGenderText(BuildContext context, String gender) {
    final l10n = AppLocalizations.of(context)!;
    switch (gender) {
      case 'male':
        return l10n.male;
      case 'female':
        return l10n.female;
      default:
        return l10n.unknown;
    }
  }

  String _getHealthStatusText(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case 'excellent':
        return l10n.excellentStatus;
      case 'good':
        return l10n.goodStatus;
      case 'fair':
        return l10n.fairStatus;
      case 'poor':
        return l10n.poorStatus;
      default:
        return l10n.unknown;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'veterinaryVisit':
        return Colors.red;
      case 'feeding':
        return Colors.orange;
      case 'vaccination':
        return Colors.green;
      case 'grooming':
        return Colors.blue;
      case 'walk':
        return Colors.purple;
      case 'cageCleaning':
        return Colors.brown;
      case 'training':
        return Colors.indigo;
      case 'medication':
        return Colors.pink;
      default:
        return Colors.grey;
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

  Color _getExpenseCategoryColor(String category) {
    switch (category) {
      case 'food':
        return Colors.orange;
      case 'medical':
        return Colors.red;
      case 'toys':
        return Colors.blue;
      case 'accessories':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getExpenseCategoryIcon(String category) {
    switch (category) {
      case 'food':
        return Icons.restaurant;
      case 'medical':
        return Icons.medical_services;
      case 'toys':
        return Icons.toys;
      case 'accessories':
        return Icons.shopping_bag;
      default:
        return Icons.attach_money;
    }
  }

  String _getExpenseCategoryText(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'food':
        return l10n.foodCategory;
      case 'medical':
        return l10n.medicalCategory;
      case 'toys':
        return l10n.toysCategory;
      case 'accessories':
        return l10n.accessoriesCategory;
      default:
        return category;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getCategoryTranslation(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'veterinaryVisit':
        return l10n.veterinaryVisit;
      case 'feeding':
        return l10n.feeding;
      case 'vaccination':
        return l10n.vaccination;
      case 'grooming':
        return l10n.grooming;
      case 'walk':
        return l10n.walk;
      case 'cageCleaning':
        return l10n.cageCleaning;
      case 'training':
        return l10n.training;
      case 'medication':
        return l10n.medication;
      default:
        return l10n.other;
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

  ImageProvider? _getPetImageProvider(String photoUrl) {
    if (photoUrl.contains('placeholder')) return null;
    if (photoUrl.startsWith('http://') || photoUrl.startsWith('https://')) {
      return NetworkImage(photoUrl);
    }
    return FileImage(File(photoUrl));
  }
}

// ── Private helper widgets ────────────────────────────────────────────────────

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _FeedingLogTile extends StatelessWidget {
  final FeedingLog log;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FeedingLogTile({
    required this.log,
    required this.onEdit,
    required this.onDelete,
  });

  Color _mealColor(String m) {
    switch (m) {
      case 'breakfast':
        return Colors.orange;
      case 'lunch':
        return Colors.amber;
      case 'dinner':
        return Colors.indigo;
      case 'snack':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  IconData _mealIcon(String m) {
    switch (m) {
      case 'breakfast':
        return Icons.wb_sunny;
      case 'lunch':
        return Icons.light_mode;
      case 'dinner':
        return Icons.nightlight_round;
      case 'snack':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = _mealColor(log.mealType);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.15),
        child: Icon(_mealIcon(log.mealType), color: color, size: 20),
      ),
      title: Text(log.foodName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_mealLabel(context, log.mealType)} • '
            '${DateFormat('dd/MM/yyyy').format(log.date)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (log.portionGiven != null)
            Text(
              '${log.portionGiven!.toStringAsFixed(0)} ${log.portionUnit}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            log.isEaten ? Icons.check_circle : Icons.cancel,
            color: log.isEaten ? Colors.green : Colors.red,
            size: 20,
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'edit') onEdit();
              if (v == 'delete') onDelete();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit, size: 16),
                    const SizedBox(width: 8),
                    Text(l10n.edit),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      l10n.delete,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Food Preference Tile ──────────────────────────────────────────────────────

class _FoodPreferenceTile extends StatelessWidget {
  final FoodPreference preference;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FoodPreferenceTile({
    required this.preference,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: _ratingIconWidget(preference.rating),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  preference.foodName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _categoryLabel(context, preference.category),
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _ratingLabel(context, preference.rating),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _ratingColor(preference.rating),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (preference.notes != null &&
                    preference.notes!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    preference.notes!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'edit') onEdit();
              if (v == 'delete') {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.deleteFoodPreference),
                    content: Text(preference.foodName),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(l10n.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          onDelete();
                        },
                        child: Text(
                          l10n.delete,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit, size: 16),
                    const SizedBox(width: 8),
                    Text(l10n.edit),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      l10n.delete,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ratingIconWidget(String rating) {
    switch (rating) {
      case 'loves':
        return const Icon(Icons.favorite, color: Colors.red, size: 22);
      case 'likes':
        return const Icon(Icons.thumb_up, color: Colors.green, size: 22);
      case 'neutral':
        return Icon(Icons.sentiment_neutral, color: Colors.grey[600], size: 22);
      case 'dislikes':
        return const Icon(Icons.thumb_down, color: Colors.orange, size: 22);
      case 'allergic':
        return Icon(
          Icons.warning_amber_rounded,
          color: Colors.red[800],
          size: 22,
        );
      default:
        return const Icon(Icons.restaurant, size: 22);
    }
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
