import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../utils/share_utils.dart';
import '../utils/export_util.dart';
import '../l10n/app_localizations.dart';
import '../models/pet_models.dart';
import '../providers/pet_provider.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  List<Map<String, dynamic>> _breeds = [];
  String _breedQuery = '';
  bool _loadingBreeds = false;

  @override
  void initState() {
    super.initState();
    _loadBreeds();
  }

  Future<void> _loadBreeds() async {
    setState(() => _loadingBreeds = true);
    try {
      final data = await rootBundle.loadString('assets/data/breeds.json');
      final list = jsonDecode(data) as List<dynamic>;
      _breeds = list.cast<Map<String, dynamic>>();
    } catch (_) {}
    if (mounted) setState(() => _loadingBreeds = false);
  }

  String _dailyTip(AppLocalizations l10n) {
    final tips = <String>[
      l10n.tip1,
      l10n.tip2,
      l10n.tip3,
      l10n.tip4,
      l10n.tip5,
      l10n.tip6,
      l10n.tip7,
      l10n.tip8,
      l10n.tip9,
      l10n.tip10,
    ];
    final dayOfYear = int.parse(
      DateTime.now()
          .difference(DateTime(DateTime.now().year))
          .inDays
          .toString(),
    );
    return tips[dayOfYear % tips.length];
  }

  Future<void> _export(
    BuildContext context,
    PetData petData,
    AppLocalizations l10n,
  ) async {
    try {
      final result = await ExportUtil.exportActivitiesAndExpenses(petData);
      if (!mounted) return;
      if (Platform.isIOS) {
        // iOS users cannot browse the app's temporary directory, so offer the
        // CSV files through the system share sheet (Files, Mail, AirDrop...).
        await SharePlus.instance.share(
          ShareParams(
            files: [
              XFile(result.activitiesFile.path),
              XFile(result.expensesFile.path),
            ],
            subject: l10n.exportData,
            sharePositionOrigin: sharePositionOriginFor(context),
          ),
        );
        return;
      }
      final dir = await getTemporaryDirectory();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.exportSuccess(dir.path))));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.exportFailed(e.toString()))));
    }
  }

  List<Map<String, dynamic>> _filteredBreeds() {
    if (_breedQuery.isEmpty) return _breeds.take(5).toList();
    return _breeds
        .where(
          (b) => b['breed'].toString().toLowerCase().contains(
            _breedQuery.toLowerCase(),
          ),
        )
        .take(10)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final petData = context.watch<PetData>();
    final theme = Theme.of(context);

    final upcomingVaccinations =
        petData.vaccinations
            .where(
              (v) =>
                  v.nextDueDate != null &&
                  v.nextDueDate!.isAfter(DateTime.now()),
            )
            .toList()
          ..sort((a, b) => a.nextDueDate!.compareTo(b.nextDueDate!));

    final pendingReminders =
        petData.reminders.where((r) {
          final date = DateTime(
            r.reminderDate.year,
            r.reminderDate.month,
            r.reminderDate.day,
            r.reminderTime.hour,
            r.reminderTime.minute,
          );
          return date.isAfter(DateTime.now());
        }).toList()..sort((a, b) {
          final da = DateTime(
            a.reminderDate.year,
            a.reminderDate.month,
            a.reminderDate.day,
            a.reminderTime.hour,
            a.reminderTime.minute,
          );
          final db = DateTime(
            b.reminderDate.year,
            b.reminderDate.month,
            b.reminderDate.day,
            b.reminderTime.hour,
            b.reminderTime.minute,
          );
          return da.compareTo(db);
        });

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthExpenses = petData.expenses
        .where((e) => e.date.isAfter(monthStart))
        .fold<double>(0, (sum, e) => sum + (e.amount));

    PetActivity? lastActivity;
    if (petData.activities.isNotEmpty) {
      final acts = List<PetActivity>.from(petData.activities);
      acts.sort((a, b) => b.date.compareTo(a.date));
      lastActivity = acts.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.insights),
        actions: [
          IconButton(
            tooltip: l10n.exportCSV,
            onPressed: () => _export(context, petData, l10n),
            icon: const Icon(Icons.file_download),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionHeader(
              title: l10n.upcomingVaccinations,
              icon: Icons.vaccines,
            ),
            if (upcomingVaccinations.isEmpty)
              _EmptyState(text: l10n.noVaccinations)
            else
              ...upcomingVaccinations
                  .take(3)
                  .map(
                    (v) => _Tile(
                      title: v.vaccineName,
                      subtitle:
                          '${l10n.nextDueDate}: ${_fmtDate(v.nextDueDate!)}',
                      leading: const Icon(Icons.medical_services),
                    ),
                  ),
            const SizedBox(height: 12),
            _SectionHeader(title: l10n.pendingReminders, icon: Icons.alarm),
            if (pendingReminders.isEmpty)
              _EmptyState(text: l10n.noReminders)
            else
              ...pendingReminders.take(3).map((r) {
                final dt = DateTime(
                  r.reminderDate.year,
                  r.reminderDate.month,
                  r.reminderDate.day,
                  r.reminderTime.hour,
                  r.reminderTime.minute,
                );
                return _Tile(
                  title: r.title,
                  subtitle: _fmtDateTime(dt),
                  leading: const Icon(Icons.alarm_on),
                );
              }),
            const SizedBox(height: 12),
            _SectionHeader(
              title: l10n.monthlyExpenseTotal,
              icon: Icons.payments,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.attach_money),
                title: Text(monthExpenses.toStringAsFixed(2)),
                subtitle: Text(l10n.monthlyExpenses),
              ),
            ),
            const SizedBox(height: 12),
            _SectionHeader(title: l10n.lastActivity, icon: Icons.history),
            if (lastActivity == null)
              _EmptyState(text: l10n.noActivity)
            else
              Card(
                child: ListTile(
                  leading: const Icon(Icons.event_note),
                  title: Text(
                    lastActivity.description.isEmpty
                        ? lastActivity.category
                        : lastActivity.description,
                  ),
                  subtitle: Text(_fmtDate(lastActivity.date)),
                ),
              ),
            const SizedBox(height: 12),
            _SectionHeader(title: l10n.dailyTip, icon: Icons.lightbulb),
            Card(
              color: theme.colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_dailyTip(l10n)),
              ),
            ),
            const SizedBox(height: 12),
            _SectionHeader(title: l10n.breeds, icon: Icons.pets),
            TextField(
              decoration: InputDecoration(
                hintText: l10n.searchBreed,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _breedQuery = v),
            ),
            const SizedBox(height: 8),
            if (_loadingBreeds)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              ..._filteredBreeds().map(
                (b) => Card(
                  child: ListTile(
                    title: Text(b['breed']),
                    subtitle: Text(
                      '${b['species']} • ${b['size']} • ${b['temperament']}',
                    ),
                    trailing: Text('~${b['lifeExpectancy']}y'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  String _fmtDateTime(DateTime d) =>
      '${_fmtDate(d)} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget leading;
  const _Tile({
    required this.title,
    required this.subtitle,
    required this.leading,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: leading,
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
