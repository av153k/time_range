import 'package:flutter/material.dart';

class ArrowButton extends StatelessWidget {
  final void Function()? onTap;
  final ArrowDirection direction;
  final Color? backgroundColor;
  final Color? borderColor;
  const ArrowButton({
    Key? key,
    this.onTap,
    this.direction = ArrowDirection.left,
    this.backgroundColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 45,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: borderColor ?? Theme.of(context).primaryColor,
          ),
        ),
        child: Icon(
          direction == ArrowDirection.left
              ? Icons.keyboard_arrow_left_sharp
              : Icons.keyboard_arrow_right_sharp,
          color: borderColor ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

enum ArrowDirection {
  left,
  right,
}
