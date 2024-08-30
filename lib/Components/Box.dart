import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class neo_box extends StatelessWidget {
  final Widget? child;

  const neo_box({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 15,
          )
        ],
        borderRadius: BorderRadius.circular(10), // Optional: add rounded corners
      ),
      child: child, // This is where you need to include the child
    );
  }
}
