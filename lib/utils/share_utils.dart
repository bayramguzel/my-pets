import 'package:flutter/material.dart';

/// iPadOS presents the share sheet in a popover and needs a source rectangle.
/// Using the tapped widget's box keeps the popover anchored to the button.
Rect sharePositionOriginFor(BuildContext context) {
  final RenderObject? renderObject = context.findRenderObject();
  if (renderObject is RenderBox && renderObject.hasSize) {
    return renderObject.localToGlobal(Offset.zero) & renderObject.size;
  }
  final screen = MediaQuery.sizeOf(context);
  return Rect.fromCenter(
    center: Offset(screen.width / 2, screen.height / 2),
    width: 1,
    height: 1,
  );
}
