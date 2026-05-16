import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studyboard_mobile/core/theme/app_colors.dart';

class TaskCompletionAnimation extends StatefulWidget {
  const TaskCompletionAnimation({required this.child, super.key});

  final Widget child;

  @override
  State<TaskCompletionAnimation> createState() =>
      _TaskCompletionAnimationState();
}

class _TaskCompletionAnimationState extends State<TaskCompletionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<Color?> _borderColor;
  bool _hapticFired = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1.04)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.04, end: 1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _borderColor = ColorTween(
      begin: AppColors.goldenYellow,
      end: AppColors.sagGreen,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        // 200ms out of 300ms total = first 2/3 of animation
        curve: const Interval(0, 2 / 3),
      ),
    );

    _controller.addListener(() {
      if (!_hapticFired && _controller.value >= 0.5) {
        _hapticFired = true;
        unawaited(HapticFeedback.mediumImpact());
      }
    });
    unawaited(_controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _scale.value,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: _borderColor.value ?? AppColors.sagGreen,
                width: 4,
              ),
            ),
          ),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}
