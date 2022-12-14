import 'package:flutter/material.dart';

class Title extends StatelessWidget {
  const Title({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return DefaultTextStyle.merge(
      style: theme.displayLarge!.merge(
        const TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.w900,
          color: Color(0xFF000000),
          letterSpacing: -5,
          height: 0.9,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: child,
      ),
    );
  }
}

class SomeOsloPhoto extends StatelessWidget {
  const SomeOsloPhoto({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Image.asset(
        'assets/oslo${index % 8}.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}
