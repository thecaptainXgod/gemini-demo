import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as provider;
import 'package:shimmer/shimmer.dart';

class CardImage extends StatelessWidget {
  CardImage({
    super.key,
    required this.imageString,
    required this.size,
    this.radius = 0,
    this.borderSpread = 3,
    this.child,
    this.showBorder = false,
    this.loading = false,
    this.borderColor,
    this.padding,
    this.margin,
  });

  Size size;
  double radius;
  double borderSpread;
  String imageString;
  Widget? child;
  bool showBorder = false;
  bool loading = false;
  Color? borderColor;
  EdgeInsets? padding, margin;

  @override
  build(BuildContext context) {
    final loadingWidget = Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          boxShadow: [
            BoxShadow(
                color: borderColor ?? Colors.white,
                spreadRadius: borderSpread)
          ],
          color: Colors.grey,
        ),
        child: Center(child: child),
      ),
    );
    if(loading){
      return loadingWidget;
    }
    return CachedNetworkImage(
      imageUrl: imageString,
      fit: BoxFit.fill,
      errorWidget: (context, error, something) {
        return Image.asset('assets/images/image_not_found.png',
            height: size.height, width: size.width);
      },
      placeholder: (context, url) {
        return loadingWidget;
      },
      imageBuilder: (context, imageProvider) => Container(
          padding: padding,
          margin: margin,
          width: size.width,
          height: (size.height),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            boxShadow: [
              BoxShadow(
                  color: borderColor ?? Colors.white,
                  spreadRadius: borderSpread)
            ],
            color: const Color.fromARGB(0, 0, 0, 0),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
          child: Center(child: child)),
    );
  }
}

class CardMemoryImage extends StatelessWidget {
  CardMemoryImage({
    super.key,
    required this.imageData,
    required this.size,
    this.radius = 0,
    this.borderSpread = 3,
    this.child,
    this.showBorder = false,
    this.loading = false,
    this.borderColor,
    this.padding,
    this.margin,
  });

  Size size;
  double radius;
  double borderSpread;
  Uint8List imageData;
  Widget? child;
  bool showBorder = false;
  bool loading = false;
  Color? borderColor;
  EdgeInsets? padding, margin;

  @override
  build(BuildContext context) {
    final loadingWidget = Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          boxShadow: [
            BoxShadow(
                color: borderColor ?? Colors.white,
                spreadRadius: borderSpread)
          ],
          color: Colors.grey,
        ),
        child: Center(child: child),
      ),
    );
    if(loading){
      return loadingWidget;
    }
    return Container(
        padding: padding,
        margin: margin,
        width: size.width,
        height: (size.height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          boxShadow: [
            BoxShadow(
                color: borderColor ?? Colors.white,
                spreadRadius: borderSpread)
          ],
          color: const Color.fromARGB(0, 0, 0, 0),
          image: DecorationImage(image: Image.memory(imageData).image, fit: BoxFit.cover),
        ),
        child: Center(child: child));
  }
}

class CardAssetImage extends StatelessWidget {
  CardAssetImage(
      {super.key,
      required this.imageString,
      required this.size,
      this.radius = 0,
      this.child,
      this.showBorder = false,
      this.borderColor,
      this.padding});

  Size size;
  double radius = 5;
  String imageString;
  Widget? child;
  bool showBorder = false;
  Color? borderColor;
  EdgeInsets? padding;

  @override
  build(BuildContext context) {
    return Container(
        padding: padding,
        width: size.width,
        height: (size.height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          boxShadow: [
            BoxShadow(color: borderColor ?? Colors.white, spreadRadius: 3)
          ],
          color: const Color.fromARGB(0, 0, 0, 0),
          image: DecorationImage(
              image: Image.asset(imageString).image, fit: BoxFit.cover),
        ),
        child: Center(child: child));
  }
}

class CardAssetSvgImage extends StatelessWidget {
  CardAssetSvgImage(
      {super.key,
      required this.imageString,
      required this.size,
      this.radius = 0,
      this.child,
      this.showBorder = false,
      this.borderColor,
      this.padding});

  Size size;
  double radius = 5;
  String imageString;
  Widget? child;
  bool showBorder = false;
  Color? borderColor;
  EdgeInsets? padding;

  @override
  build(BuildContext context) {
    return Container(
        padding: padding,
        width: size.width,
        height: (size.height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          boxShadow: [
            BoxShadow(color: borderColor ?? Colors.white, spreadRadius: 3)
          ],
          color: const Color.fromARGB(0, 0, 0, 0),
          image: DecorationImage(
              image:
                  provider.Svg(imageString, source: provider.SvgSource.asset),
              fit: BoxFit.cover),
        ),
        child: Center(child: child));
  }
}

class CardFileImage extends StatelessWidget {
  CardFileImage(
      {super.key,
      required this.imageString,
      required this.size,
      this.radius = 0,
      this.child,
      this.showBorder = false,
      this.borderColor,
      this.padding});

  Size size;
  double radius = 5;
  String imageString;
  Widget? child;
  bool showBorder = false;
  Color? borderColor;
  EdgeInsets? padding;

  @override
  build(BuildContext context) {
    return Container(
        padding: padding,
        width: size.width,
        height: (size.height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          boxShadow: [
            BoxShadow(color: borderColor ?? Colors.white, spreadRadius: 3)
          ],
          color: const Color.fromARGB(0, 0, 0, 0),
          image: DecorationImage(
              image: Image.file(File(imageString)).image, fit: BoxFit.cover),
        ),
        child: Center(child: child));
  }
}

Widget textBadge(BuildContext context, String text,
    {Color backgroundColor = Colors.white, Color fontColor = Colors.black}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
    decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(20))),
    child: Text(text,
        style:
            Theme.of(context).textTheme.titleSmall?.copyWith(color: fontColor)),
  );
}
