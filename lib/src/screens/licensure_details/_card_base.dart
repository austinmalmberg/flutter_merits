import 'package:flutter/material.dart';

class LicensureDetailsCard extends StatelessWidget {
  final ListTile header;
  final Widget body;
  final EdgeInsets? padding;
  final double? elevation;

  const LicensureDetailsCard({
    super.key,
    required this.header,
    required this.body,
    this.padding,
    this.elevation,
  });

  factory LicensureDetailsCard.primary({
    Key? key,
    required ListTile header,
    required Widget body,
    double? elevation,
  }) =>
      LicensureDetailsCard(
        key: key,
        header: header,
        body: body,
        elevation: elevation,
        padding: const EdgeInsets.all(8.0),
      );

  factory LicensureDetailsCard.flat({
    Key? key,
    required ListTile header,
    required Widget body,
  }) =>
      LicensureDetailsCard(
        key: key,
        header: header,
        body: body,
        elevation: 0.0,
        padding: const EdgeInsets.all(4.0),
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      child: Container(
        padding: padding,
        child: Column(
          children: [
            header,
            const Divider(),
            body,
          ],
        ),
      ),
    );
  }
}

class AddDetailsButton extends StatelessWidget {
  final IconData iconData;
  final Widget label;
  final VoidCallback onPressed;

  const AddDetailsButton({Key? key, required this.label, required this.onPressed, this.iconData = Icons.add})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 200.0,
        child: TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryTextTheme.bodyText1?.color,
          ),
          onPressed: onPressed,
          icon: const Icon(
            Icons.add,
            size: 40.0,
          ),
          label: label,
        ),
      ),
    );
  }
}
