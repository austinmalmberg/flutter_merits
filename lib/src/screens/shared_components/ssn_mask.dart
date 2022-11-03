import 'package:flutter/material.dart';

class MaskedSsnText extends StatelessWidget {
  final String ssn;
  final double opacity;
  final TextStyle? style;

  const MaskedSsnText({Key? key, required this.ssn, this.style, this.opacity = 0.4})
      : assert(ssn.length == 4),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle? runtimeStyle = style ?? Theme.of(context).primaryTextTheme.bodyText1;

    return FittedBox(
      child: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: 'XXX-XX-',
              style: runtimeStyle?.copyWith(
                color: runtimeStyle.color?.withOpacity(opacity),
              ),
            ),
            TextSpan(
              text: ssn,
              style: runtimeStyle?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        textScaleFactor: 1.2,
      ),
    );
  }
}
