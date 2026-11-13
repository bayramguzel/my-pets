import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// True on platforms where the native wheel pickers should be used.
bool get usesCupertinoPickers => Platform.isIOS;

/// Shows a date picker that follows the platform conventions: an iOS wheel
/// picker in a bottom sheet on iPhone/iPad, the Material calendar elsewhere.
Future<DateTime?> showAdaptiveDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  if (!usesCupertinoPickers) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  final theme = Theme.of(context);
  final materialL10n = MaterialLocalizations.of(context);
  DateTime selected = _clampDate(initialDate, firstDate, lastDate);

  final DateTime? picked = await showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (sheetContext) {
      return _PickerSheet(
        theme: theme,
        cancelLabel: materialL10n.cancelButtonLabel,
        doneLabel: materialL10n.okButtonLabel,
        onCancel: () => Navigator.of(sheetContext).pop(),
        onDone: () => Navigator.of(sheetContext).pop(selected),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: selected,
          minimumDate: firstDate,
          maximumDate: lastDate,
          onDateTimeChanged: (value) => selected = value,
        ),
      );
    },
  );

  if (picked == null) return null;
  // Match the Material picker, which returns a date at midnight.
  return DateTime(picked.year, picked.month, picked.day);
}

/// Shows a time picker that follows the platform conventions.
Future<TimeOfDay?> showAdaptiveTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
}) async {
  if (!usesCupertinoPickers) {
    return showTimePicker(context: context, initialTime: initialTime);
  }

  final theme = Theme.of(context);
  final materialL10n = MaterialLocalizations.of(context);
  final now = DateTime.now();
  DateTime selected = DateTime(
    now.year,
    now.month,
    now.day,
    initialTime.hour,
    initialTime.minute,
  );

  final DateTime? picked = await showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (sheetContext) {
      return _PickerSheet(
        theme: theme,
        cancelLabel: materialL10n.cancelButtonLabel,
        doneLabel: materialL10n.okButtonLabel,
        onCancel: () => Navigator.of(sheetContext).pop(),
        onDone: () => Navigator.of(sheetContext).pop(selected),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          use24hFormat: MediaQuery.alwaysUse24HourFormatOf(sheetContext),
          initialDateTime: selected,
          onDateTimeChanged: (value) => selected = value,
        ),
      );
    },
  );

  if (picked == null) return null;
  return TimeOfDay(hour: picked.hour, minute: picked.minute);
}

DateTime _clampDate(DateTime value, DateTime first, DateTime last) {
  if (value.isBefore(first)) return first;
  if (value.isAfter(last)) return last;
  return value;
}

class _PickerSheet extends StatelessWidget {
  final ThemeData theme;
  final String cancelLabel;
  final String doneLabel;
  final VoidCallback onCancel;
  final VoidCallback onDone;
  final Widget child;

  const _PickerSheet({
    required this.theme,
    required this.cancelLabel,
    required this.doneLabel,
    required this.onCancel,
    required this.onDone,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: theme.brightness,
        primaryColor: theme.colorScheme.primary,
        barBackgroundColor: theme.colorScheme.surface,
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyle(
            fontSize: 21,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      child: Container(
        height: 320,
        color: theme.colorScheme.surface,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              SizedBox(
                height: 44,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: onCancel,
                        child: Text(cancelLabel),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: onDone,
                        child: Text(
                          doneLabel,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 0.5, color: theme.dividerColor),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
