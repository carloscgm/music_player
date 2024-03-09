import 'package:flutter/material.dart';

class NeuBox extends StatelessWidget {
  final Widget? child;
  const NeuBox({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    bool isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isLight ? Colors.grey.shade500 : Colors.black,
              blurRadius: isLight ? 15 : 6,
              offset: const Offset(4, 4),
            ),
            BoxShadow(
              color: isLight ? Colors.white : Colors.grey.shade800,
              blurRadius: isLight ? 15 : 6,
              offset: const Offset(-4, -4),
            ),
          ]),
      child: child,
    );
  }
}
