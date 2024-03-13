import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class NeuBox extends StatelessWidget {
  final Widget? child;
  final double padding;
  final bool isPressed;
  const NeuBox(
      {super.key, this.child, this.padding = 12, this.isPressed = false});

  @override
  Widget build(BuildContext context) {
    bool isLight = Theme.of(context).brightness == Brightness.light;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: isLight ? Colors.grey.shade500 : Colors.black,
                blurRadius: isLight ? 15 : 6,
                offset: const Offset(4, 4),
                inset: isPressed),
            BoxShadow(
                color: isLight ? Colors.white : Colors.grey.shade800,
                blurRadius: isLight ? 15 : 6,
                offset: const Offset(-4, -4),
                inset: isPressed),
          ]),
      child: child,
    );
  }
}
