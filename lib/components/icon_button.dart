import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget{

  final VoidCallback onPressed;
  final IconData icon;
  final double? size;
  final Color? backgroundColor, iconColor;
  const CustomIconButton(this.icon, {super.key, required this.onPressed, this.size,this.backgroundColor, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      fillColor: backgroundColor,
      constraints: const BoxConstraints(minWidth: 40.0, minHeight: 36.0),
      elevation: 0,
      child: Icon(icon, color: iconColor ?? Colors.black, size: size??17,)
    );
  }

}