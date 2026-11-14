import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool get _usesCupertinoDialogs => Platform.isIOS;

/// Shows a confirmation dialog using the platform's native look: an iOS alert
/// on iPhone/iPad, a Material dialog elsewhere.
Future<bool> showAdaptiveConfirm({
  required BuildContext context,
  required String title,
  required String message,
  required String cancelLabel,
  required String confirmLabel,
  bool destructive = false,
}) async {
  if (_usesCupertinoDialogs) {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelLabel),
          ),
          CupertinoDialogAction(
            isDefaultAction: !destructive,
            isDestructiveAction: destructive,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(
            confirmLabel,
            style: destructive ? const TextStyle(color: Colors.red) : null,
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// One option in an [showAdaptiveChoiceSheet] list.
class AdaptiveChoice<T> {
  final T value;
  final String label;
  final Widget? leading;
  final bool selected;

  const AdaptiveChoice({
    required this.value,
    required this.label,
    this.leading,
    this.selected = false,
  });
}

/// Lets the user pick one option. iOS gets the native action sheet, other
/// platforms a bottom sheet with tappable rows.
Future<T?> showAdaptiveChoiceSheet<T>({
  required BuildContext context,
  required String title,
  required List<AdaptiveChoice<T>> choices,
  required String cancelLabel,
}) {
  if (_usesCupertinoDialogs) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: Text(title),
        actions: [
          for (final choice in choices)
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(sheetContext).pop(choice.value),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (choice.leading != null) ...[
                    choice.leading!,
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      choice.label,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (choice.selected) ...[
                    const SizedBox(width: 8),
                    const Icon(CupertinoIcons.check_mark, size: 18),
                  ],
                ],
              ),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(sheetContext).pop(),
          child: Text(cancelLabel),
        ),
      ),
    );
  }

  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final choice in choices)
                  ListTile(
                    leading: choice.leading,
                    title: Text(choice.label),
                    trailing: choice.selected
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () =>
                        Navigator.of(sheetContext).pop(choice.value),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

/// Shows an informational dialog with a single dismiss button.
Future<void> showAdaptiveMessage({
  required BuildContext context,
  required String title,
  required String message,
  required String buttonLabel,
}) async {
  if (_usesCupertinoDialogs) {
    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
    return;
  }

  await showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(buttonLabel),
        ),
      ],
    ),
  );
}
