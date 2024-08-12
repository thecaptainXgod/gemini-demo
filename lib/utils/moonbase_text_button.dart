import 'package:flutter/material.dart';
import 'package:moonbase_explore/widgets/common_text.dart';
import 'package:tempo_x/utils/size_constants.dart';


import 'colors.dart';


class MoonbaseTextButton extends StatelessWidget {
  const MoonbaseTextButton({
    super.key,
    required this.text,
    this.textStyle,
    this.onPressed,
    this.radius = 15,
    this.enabledBackgroundColor = LightColorTheme.primaryDarkColor,
    this.disabledBackgroundColor = LightColorTheme.greyColor,
    this.isButtonEnabled = true,
    this.height = MSizeConstants.collabButtonsHeight,
    this.width,
  });

  final void Function()? onPressed;
  final Color disabledBackgroundColor;
  final Color enabledBackgroundColor;
  final double height;
  final bool isButtonEnabled;
  final double radius;
  final String text;
  final TextStyle? textStyle;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) =>
            isButtonEnabled ? enabledBackgroundColor : disabledBackgroundColor),
        shape: MaterialStateProperty.resolveWith((states) =>
            RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius)))),
        minimumSize: MaterialStateProperty.resolveWith((states) =>
            Size(width ?? MediaQuery.of(context).size.width, height)),
      ),
      onPressed: isButtonEnabled ? onPressed : null,
      child: TText(
        text,
        variant: TypographyVariant.h1,
        style: const TextStyle(color: Colors.white).merge(textStyle),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
