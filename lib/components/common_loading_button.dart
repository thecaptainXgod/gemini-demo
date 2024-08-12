import 'package:flutter/material.dart';
import 'package:moonbase_explore/app_constants/app_text_style.dart';
import 'package:moonbase_widgets/moonbase_widgets.dart';
import '../utils/colors.dart';
import '../utils/size_constants.dart';
import 'base_widget.dart';

class MLoadingButton extends BaseStatelessWidget {
  const MLoadingButton({
    Key? key,
    this.loadingController,
    this.isLoading = false,
    this.onPressed,
    this.height,
    this.width,
    this.color = LightColorTheme.primaryDarkColor,
    required this.text,
  }) : super(key: key);

  final RoundedLoadingButtonController? loadingController;
  final bool isLoading;
  final Function? onPressed;
  final double? height;
  final double? width;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      borderRadius: 12,
      color: color,
      animateOnTap: false,
      width: width ?? MediaQuery.of(context).size.width,
      height: height ?? MSizeConstants.height50,
      successIcon: Icons.verified,
      failedIcon: Icons.error,
      controller: loadingController ?? RoundedLoadingButtonController(),
      onPressed: isLoading
          ? () {}
          : ()=>onPressed?.call(),
      child: Text(text,
          style: titleTextStyle.copyWith(color: Colors.white, fontSize: 16)),
    );
  }
}
