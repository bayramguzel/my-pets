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
