import 'package:flutter/material.dart';

class TextTile extends StatelessWidget {
  const TextTile({
    super.key,
    required this.label,
    required this.iconData,
    this.value,
    this.tilePadding,
    this.backgroundColor,
    this.textStyle,
    this.overflow = TextOverflow.ellipsis,
  });

  final String label;
  final IconData? iconData;
  final String? value;
  final EdgeInsets? tilePadding;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      waitDuration: const Duration(milliseconds: 400),
      child: Container(
        padding: tilePadding,
        child: Row(
          children: [
            if (iconData != null) Icon(iconData, semanticLabel: label),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  value ?? '',
                  style: textStyle,
                  overflow: overflow,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
