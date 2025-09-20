import 'package:flutter/material.dart';

class ScanOverlay extends StatelessWidget {
  const ScanOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double boxSize = constraints.biggest.shortestSide * 0.7;
          return Center(
            child: Container(
              width: boxSize,
              height: boxSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 4,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
