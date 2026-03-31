import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import '../providers/pet_provider.dart';
import 'add_data_screen.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.statistics)),
      body: Consumer<PetData>(
        builder: (BuildContext context, PetData petData, Widget? child) {
          if (petData.pets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bar_chart, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(l10n.noContentToExplore),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildOverviewCard(context, petData, l10n),
              const SizedBox(height: 16),
              _buildPetTypeChart(context, petData, l10n),
              const SizedBox(height: 16),
              _buildExpensesSummaryCard(context, petData, l10n),
              const SizedBox(height: 16),
              _buildExpenseChart(context, petData, l10n),
              const SizedBox(height: 16),
              _buildHealthStatusCard(context, petData, l10n),
              const SizedBox(height: 16),
              _buildUpcomingRemindersCard(context, petData, l10n),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDataScreen()),
          );
        },
        tooltip: l10n.add,
        icon: const Icon(Icons.add),
        label: Text(l10n.addInfo),
      ),
    );
  }

  Widget _buildOverviewCard(
    BuildContext context,
    PetData petData,
    AppLocalizations l10n,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.overview,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    l10n.totalPets,
                    petData.pets.length.toString(),
                    Icons.pets,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    l10n.activitiesThisMonth,
                    petData.activities
                        .where(
                          (activity) =>
                              activity.date.month == DateTime.now().month &&
                              activity.date.year == DateTime.now().year,
                        )
                        .length
                        .toString(),
                    Icons.event,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetTypeChart(
    BuildContext context,
    PetData petData,
    AppLocalizations l10n,
  ) {
    final typeCounts = <String, int>{};
    for (final pet in petData.pets) {
      typeCounts[pet.type] = (typeCounts[pet.type] ?? 0) + 1;
    }

    final List<PieChartSectionData> sections = [];
    int index = 0;
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
    ];

    typeCounts.forEach((type, count) {
      sections.add(
        PieChartSectionData(
          color: colors[index % colors.length],
          value: count.toDouble(),
          title: '$count',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      index++;
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.petType,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: typeCounts.keys.mapIndexed((i, type) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              color: colors[i % colors.length],
                            ),
                            const SizedBox(width: 8),
                            Text(_getLocalizedPetType(context, type, l10n)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedPetType(
    BuildContext context,
    String type,
    AppLocalizations l10n,
  ) {
    switch (type.toLowerCase()) {
      case 'dog':
        return l10n.dog;
      case 'cat':
        return l10n.cat;
      case 'bird':
        return l10n.bird;
      case 'rabbit':
        return l10n.rabbit;
      case 'hamster':
        return l10n.hamster;
      case 'fish':
        return l10n.fish;
      case 'turtle':
        return l10n.turtle;
      default:
        return l10n.other;
    }
  }

  Widget _buildExpensesSummaryCard(
    BuildContext context,
    PetData petData,
    AppLocalizations l10n,
  ) {
    final totalExpenses = petData.expenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
    final thisMonthExpenses = petData.expenses
        .where(
          (expense) =>
              expense.date.month == DateTime.now().month &&
              expense.date.year == DateTime.now().year,
        )
        .fold(0.0, (sum, expense) => sum + expense.amount);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.expenseSummary,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    l10n.totalExpenses,
                    '${l10n.currencySymbol}${totalExpenses.toStringAsFixed(2)}',
                    Icons.attach_money,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    l10n.thisMonth,
                    '${l10n.currencySymbol}${thisMonthExpenses.toStringAsFixed(2)}',
                    Icons.calendar_month,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseChart(
    BuildContext context,
    PetData petData,
    AppLocalizations l10n,
  ) {
    final categoryExpenses = <String, double>{};
    for (final expense in petData.expenses) {
      categoryExpenses[expense.category] =
          (categoryExpenses[expense.category] ?? 0.0) + expense.amount;
    }

    if (categoryExpenses.isEmpty) return const SizedBox.shrink();

    final List<BarChartGroupData> barGroups = [];
    int index = 0;
    final categories = categoryExpenses.keys.toList();

    for (final category in categories) {
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: categoryExpenses[category]!,
              color: Colors.blue,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
      index++;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.expenseChart,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < categories.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _getLocalizedExpenseCategory(
                                  categories[value.toInt()],
                                  l10n,
                                ),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedExpenseCategory(String category, AppLocalizations l10n) {
    switch (category.toLowerCase()) {
      case 'food':
        return l10n.food;
      case 'medical':
        return l10n.medical;
      case 'toys':
        return l10n.toys;
      case 'accessories':
        return l10n.accessories;
      default:
        return l10n.other;
    }
  }

  Widget _buildHealthStatusCard(
    BuildContext context,
    PetData petData,
    AppLocalizations l10n,
  ) {
    final healthCounts = <String, int>{};
    for (final pet in petData.pets) {
      healthCounts[pet.healthStatus] =
          (healthCounts[pet.healthStatus] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.healthStatus,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...healthCounts.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_getHealthStatusText(context, entry.key, l10n)),
                    Chip(
                      label: Text(entry.value.toString()),
                      backgroundColor: _getHealthStatusColor(entry.key),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHealthStatusText(
    BuildContext context,
    String status,
    AppLocalizations l10n,
  ) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return l10n.excellent;
      case 'good':
        return l10n.good;
      case 'fair':
        return l10n.fair;
      case 'poor':
        return l10n.poor;
      default:
        return status;
    }
  }

  Widget _buildUpcomingRemindersCard(
    BuildContext context,
    PetData petData,
    AppLocalizations l10n,
  ) {
    final upcomingReminders = petData.reminders
        .where(
          (reminder) =>
              reminder.isActive &&
              reminder.reminderDate.isAfter(DateTime.now()) &&
              reminder.reminderDate.isBefore(
                DateTime.now().add(const Duration(days: 7)),
              ),
        )
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.upcomingReminders7Days,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (upcomingReminders.isEmpty)
              Text(l10n.noUpcomingReminders)
            else
              ...upcomingReminders.map((reminder) {
                final pet = petData.pets.firstWhereOrNull(
                  (p) => p.id == reminder.petId,
                );
                return ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.blue),
                  title: Text(reminder.title),
                  subtitle: Text(
                    '${pet?.name ?? l10n.unknown} - ${DateFormat('dd/MM/yyyy').format(reminder.reminderDate)}',
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getHealthStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.blue;
      case 'fair':
        return Colors.orange;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
