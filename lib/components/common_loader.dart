import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'base_widget.dart';

class MLoader extends BaseStatelessWidget {
  const MLoader({
    Key? key,
    this.color,
    this.size = 40
  }) : super(key: key);

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.threeArchedCircle(
        color: color ?? Theme.of(context).primaryColor,
        size: size,
    ));
  }
}
