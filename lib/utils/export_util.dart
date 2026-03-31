import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../providers/pet_provider.dart';

class ExportResult {
  final File activitiesFile;
  final File expensesFile;
  ExportResult(this.activitiesFile, this.expensesFile);
}

class ExportUtil {
  static Future<ExportResult> exportActivitiesAndExpenses(PetData data) async {
    final dir = await getTemporaryDirectory();
    final activitiesPath = '${dir.path}/activities.csv';
    final expensesPath = '${dir.path}/expenses.csv';

    final activitiesCsv = StringBuffer();
    activitiesCsv.writeln('id,petName,category,description,date');
    for (final a in data.activities) {
      final petName = data.getPetById(a.petId)?.name ?? '';
      activitiesCsv.writeln(
        '${a.id},"$petName",${_esc(a.category)},"${_esc(a.description)}",${a.date.toIso8601String()}',
      );
    }

    final expensesCsv = StringBuffer();
    expensesCsv.writeln('id,petName,category,amount,date,description');
    for (final e in data.expenses) {
      final petName = data.getPetById(e.petId)?.name ?? '';
      expensesCsv.writeln(
        '${e.id},"$petName",${_esc(e.category)},${e.amount.toStringAsFixed(2)},${e.date.toIso8601String()},"${_esc(e.description)}"',
      );
    }

    final activitiesFile = await File(
      activitiesPath,
    ).writeAsString(activitiesCsv.toString());
    final expensesFile = await File(
      expensesPath,
    ).writeAsString(expensesCsv.toString());

    return ExportResult(activitiesFile, expensesFile);
  }

  static String _esc(String input) {
    if (input.contains('"')) {
      return '"${input.replaceAll('"', '""')}"';
    }
    if (input.contains(',') || input.contains('\n')) {
      return '"$input"';
    }
    return input;
  }
}
