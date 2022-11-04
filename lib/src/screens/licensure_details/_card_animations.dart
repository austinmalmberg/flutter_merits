import 'package:flutter/material.dart';

class GrowAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Animation<double> Function(Animation<double> controller) scaleBuilder;

  const GrowAnimation({
    Key? key,
    required this.child,
    required this.duration,
    required this.scaleBuilder,
  }) : super(key: key);

  @override
  State<GrowAnimation> createState() => _GrowAnimationState();
}

class _GrowAnimationState extends State<GrowAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animationController.addListener(() {
      if (mounted) setState(() {});
    });

    _scaleAnimation = widget.scaleBuilder(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scaleAnimation.value,
      child: widget.child,
    );
  }
}

class SlideAnimation extends StatefulWidget {
  final Duration duration;
  final Animation<Offset> Function(Animation<double>) slideBuilder;
  final Widget child;

  const SlideAnimation({
    super.key,
    required this.duration,
    required this.slideBuilder,
    required this.child,
  });

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _translateAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animationController.addListener(() {
      if (mounted) setState(() {});
    });

    _translateAnimation = widget.slideBuilder(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: _translateAnimation.value,
      child: widget.child,
    );
  }
}
