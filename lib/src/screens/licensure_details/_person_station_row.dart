import 'package:flutter/material.dart';

import '_data_tile.dart';

class PersonStationRow extends StatelessWidget {
  final String? area;
  final String? department;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsets? tilePadding;
  final TextStyle? textStyle;

  const PersonStationRow({
    Key? key,
    this.area,
    this.department,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.tilePadding,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Expanded(
          child: TextTile(
            label: 'Area',
            iconData: Icons.location_city,
            value: area,
            tilePadding: tilePadding,
            textStyle: textStyle,
          ),
        ),
        Expanded(
          child: TextTile(
            label: 'Department',
            iconData: Icons.business,
            value: department,
            tilePadding: tilePadding,
            textStyle: textStyle,
          ),
        ),
      ],
    );
  }
}
