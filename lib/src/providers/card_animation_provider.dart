import 'package:flutter/material.dart';

class CardAnimationProvider {
  CardAnimationProvider({required this.translateDuration, required this.scaleDuration});

  /// The duration that the translation animation should take.
  final Duration translateDuration;

  /// The duration that the scale animation should take.
  final Duration scaleDuration;

  /* TRANSLATION */

  Tween<Offset> translateTween(double width) => Tween<Offset>(begin: Offset(-width, 0.0), end: Offset.zero);

  Animation<Offset> translateAnimation(Animation<double> controller, double width) =>
      translateTween(width).animate(controller);

  /// Staggers the [translateTween] animation based on the [staggerFraction].
  ///
  /// The [staggerFraction] is a number between 0.0 and 1.0 that is used to generate the interval.
  Animation<Offset> staggeredTranslateAnimationBuilder(
      Animation<double> controller, double width, double staggerFraction) {
    return translateTween(width).animate(
      CurvedAnimation(
        parent: controller,
        curve: _getInterval(staggerFraction),
      ),
    );
  }

  /* SCALE */

  Tween<double> get scaleTween => Tween<double>(begin: 0.0, end: 1.0);

  Animation<double> scaleAnimation(Animation<double> controller) => scaleTween.animate(controller);

  /// Staggers the [scaleTween] animation based on the [staggerFraction].
  ///
  /// The [staggerFraction] is a number between 0.0 and 1.0 that is used to generate the interval.
  Animation<double> staggeredScaleAnimationBuilder(Animation<double> controller, double staggerFraction) {
    return scaleTween.animate(
      CurvedAnimation(
        parent: controller,
        curve: _getInterval(staggerFraction),
      ),
    );
  }

  Interval _getInterval(double proportion, [Curve curve = Curves.easeOut]) {
    double animationTime = 1.0 - 0.4;
    double staggerLeeway = 1.0 - animationTime;
    double begin = staggerLeeway * proportion;
    double end = begin + animationTime;

    return Interval(begin, end, curve: curve);
  }
}
