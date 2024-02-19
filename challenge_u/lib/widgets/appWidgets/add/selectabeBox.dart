import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SelectableBox extends StatelessWidget {
  SelectableBox(this.index, this.isSelected, this.handleBoxTap, {super.key});
  int index;
  bool isSelected;
  Function handleBoxTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleBoxTap(index),
      child: SizedBox(
        width: 85,
        height: 45,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              border: Border.all(),
              shape: BoxShape.circle,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.background,
            ),
          ),
        ),
      ),
    );
  }
}
