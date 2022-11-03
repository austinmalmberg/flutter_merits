import 'package:flutter/material.dart';

abstract class _SharedThemeData {
  static const ListTileThemeData listTileTheme = ListTileThemeData(
    minVerticalPadding: 6.0,
  );

  static const CardTheme cardTheme = CardTheme(
    margin: EdgeInsets.all(12.0),
  );
}

ThemeData _defaultLightTheme = ThemeData.light();
ThemeData _defaultDarkTheme = ThemeData.dark();

final ThemeData lightTheme = _defaultLightTheme.copyWith(
  listTileTheme: _defaultLightTheme.listTileTheme.copyWith(
    minVerticalPadding: _SharedThemeData.listTileTheme.minVerticalPadding,
  ),
  primaryTextTheme: _defaultLightTheme.primaryTextTheme.copyWith(
    headline5: _defaultLightTheme.primaryTextTheme.headline5?.copyWith(
      color: Colors.black,
    ),
    headline6: _defaultLightTheme.primaryTextTheme.headline6?.copyWith(
      color: Colors.black,
    ),
    bodyText1: _defaultLightTheme.primaryTextTheme.bodyText1?.copyWith(
      color: Colors.black,
    ),
    subtitle1: _defaultLightTheme.primaryTextTheme.subtitle1?.copyWith(
      color: Colors.grey.shade600,
    ),
  ),
  cardTheme: _defaultLightTheme.cardTheme.copyWith(
    elevation: _SharedThemeData.cardTheme.elevation,
    margin: _SharedThemeData.cardTheme.margin,
  ),
);

final ThemeData darkTheme = _defaultDarkTheme.copyWith(
  listTileTheme: _defaultDarkTheme.listTileTheme.copyWith(
    minVerticalPadding: _SharedThemeData.listTileTheme.minVerticalPadding,
  ),
  cardTheme: _defaultDarkTheme.cardTheme.copyWith(
    elevation: _SharedThemeData.cardTheme.elevation,
    margin: _SharedThemeData.cardTheme.margin,
  ),
  primaryTextTheme: _defaultDarkTheme.primaryTextTheme.copyWith(
    headline5: _defaultLightTheme.primaryTextTheme.headline5?.copyWith(),
    headline6: _defaultLightTheme.primaryTextTheme.headline6?.copyWith(),
    bodyText1: _defaultLightTheme.primaryTextTheme.bodyText1?.copyWith(),
    subtitle1: _defaultLightTheme.primaryTextTheme.subtitle1?.copyWith(
      color: Colors.grey.shade600,
    ),
  ),
);

List<Shadow> iconShadows(BuildContext context) => <Shadow>[
      Shadow(
        color: Theme.of(context).cardTheme.shadowColor ?? Theme.of(context).shadowColor.withOpacity(0.4),
        offset: Offset(
          Theme.of(context).cardTheme.elevation ?? 2.0,
          Theme.of(context).cardTheme.elevation ?? 4.0,
        ),
        blurRadius: 4.0,
      ),
    ];
