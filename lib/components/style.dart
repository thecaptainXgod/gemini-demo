import 'package:flutter/material.dart';
import 'package:moonbase_explore/app_constants/extensions.dart';

import '../utils/colors.dart';
import '../utils/size_constants.dart';


class MStyles {
  static const tempoDefaultFontFamily = fontRoboto;

  static const fontRoboto = 'Roboto';
  static const fontPacifico = 'Pacifico';

  static TextStyle text16(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.w400, fontFamily: fontRoboto);
  }

  static TextStyle appTitleTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontFamily: fontRoboto);
  }

  static ThemeData dateTimePickerTheme(BuildContext context) =>
      Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: LightColorTheme.primaryDarkColor,
          onPrimary: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: LightColorTheme.primaryDarkColor,
          ),
        ),
      );

  static const floatingLabelTextStyle = TextStyle(
    color: LightColorTheme.primaryDarkColor,
    fontWeight: FontWeight.w400,
    fontSize: MSizeConstants.fontSize16,
    fontFamily: fontRoboto,
    height: 1,
    letterSpacing: 0.0,
  );

  static Decoration? authBoxDecoration() {
    return const BoxDecoration(
      color: LightColorTheme.primaryColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(MSizeConstants.avatarRadius30),
        topRight: Radius.circular(MSizeConstants.avatarRadius30),
      ),
    );
  }

  static const borderRadius30 = BorderRadius.only(
    topLeft: Radius.circular(30),
    topRight: Radius.circular(30),
  );

  static final bottomNavBarBoxShadows = [
    BoxShadow(
      color: LightColorTheme.greyColor.withOpacity(0.2),
      offset: const Offset(0, -2),
      blurRadius: 1.0,
      spreadRadius: 1.0,
    ),
  ];

  //Chat BNB
  static const chatBnbPadding =
      EdgeInsets.only(bottom: 20, top: 0, left: 10, right: 10);
  static final chatBnbDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: LightColorTheme.primaryColor),
    borderRadius: BorderRadius.circular(25),
  );

  static final chatBnbBorderDecoration = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: const BorderSide(color: LightColorTheme.primaryColor));

  static const chatTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.2,
    fontFamily: 'Roboto',
  );

  static InputDecoration chatRoomSearchFieldDecoration = InputDecoration(
    hintText: 'Search....',
    hintStyle: hintTextStyle.copyWith(
        fontSize: 14, color: LightColorTheme.secondaryColor),
    labelStyle: labelTextStyle,
    border: InputBorder.none,
  );

  static Theme dtTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: LightColorTheme.primaryColor,
          onPrimary: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: LightColorTheme.primaryDarkColor,
          ),
        ),
      ),
      child: child!,
    );
  }

  static InputBorder textFieldBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(MSizeConstants.textFieldBorderRadius),
    borderSide: const BorderSide(
      color: LightColorTheme.primaryDarkColor,
      width: MSizeConstants.borderSideWidth,
    ),
  );

  static BoxShadow imageShadow = BoxShadow(
      blurRadius: 1.0,
      color: LightColorTheme.greyShaded300.withOpacity(0.7),
      spreadRadius: 1.0,
      offset: const Offset(0.1, 1.0));
}

const appTitleTextStyle = TextStyle(
  fontSize: MSizeConstants.fontSize16,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

const appSubTitleTextStyle = TextStyle(
  fontSize: MSizeConstants.fontSize14,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);
const summaryTextStyle = TextStyle(
  fontSize: MSizeConstants.fontSize18,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);

const prefixTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w600,
  color: Colors.grey,
);

const suffixTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

const hintTextStyle = TextStyle(
  fontSize: MSizeConstants.fontSize14,
  color: LightColorTheme.greyColor,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w400,
);

const titleTextStyle = TextStyle(
  color: LightColorTheme.lightBlack,
  fontWeight: FontWeight.w700,
  fontSize: MSizeConstants.fontSize24,
  fontFamily: 'Roboto',
  height: 1,
  letterSpacing: 0.0,
);

const labelTextStyle = TextStyle(
  color: LightColorTheme.secondaryColor,
  fontWeight: FontWeight.w400,
  fontSize: MSizeConstants.fontSize16,
  fontFamily: 'Roboto',
  height: 1,
  letterSpacing: 0.0,
);

InputDecoration textFieldInputDecoration = InputDecoration(
  floatingLabelBehavior: FloatingLabelBehavior.auto,
  labelStyle: labelTextStyle,
  floatingLabelStyle: MStyles.floatingLabelTextStyle,
  fillColor: Colors.white.withOpacity(MSizeConstants.backgroundOpacity),
  hintStyle: hintTextStyle,
  filled: true,
  contentPadding: const EdgeInsets.symmetric(
      horizontal: MSizeConstants.padding20, vertical: MSizeConstants.padding20),
  border: MStyles.textFieldBorderStyle,
  focusedBorder: MStyles.textFieldBorderStyle.copyWith(
    borderSide: const BorderSide(
      color: LightColorTheme.primaryDarkColor,
      width: MSizeConstants.borderFocusedWidth,
    ),
  ),
  enabledBorder: MStyles.textFieldBorderStyle,
);

InputDecoration searchLocationInputDecoration(String formattedText,
        bool isSearchTextEmpty, TextEditingController controller) =>
    InputDecoration(
      hintText: formattedText.isNotEmpty ? formattedText : 'Search address',
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(MSizeConstants.textFieldBorderRadius),
        borderSide: const BorderSide(
          color: LightColorTheme.primaryDarkColor,
          width: MSizeConstants.borderFocusedWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(MSizeConstants.textFieldBorderRadius),
        borderSide: const BorderSide(
          color: LightColorTheme.primaryDarkColor,
          width: MSizeConstants.borderFocusedWidth,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(MSizeConstants.textFieldBorderRadius),
        borderSide: const BorderSide(
          color: LightColorTheme.primaryDarkColor,
          width: MSizeConstants.borderFocusedWidth,
        ),
      ),
      hintStyle: hintTextStyle,
      contentPadding: const EdgeInsets.only(left: 15, top: 15.0),
      suffixIcon: Container(
        height: 35,
        width: 35,
        margin: const EdgeInsets.only(top: 6.0),
        child: GestureDetector(
          child: isSearchTextEmpty
              ? const Icon(
                  Icons.search,
                  color: LightColorTheme.primaryDarkColor,
                )
              : const Icon(
                  Icons.clear,
                  color: LightColorTheme.primaryDarkColor,
                ).onUserTap(
                  () {
                    controller.clear();
                  },
                ),
        ),
      ),
    );

TextStyle get greyText14 => const TextStyle(
      color: LightColorTheme.greyColor,
      fontWeight: FontWeight.w600,
      fontSize: 14,
      height: 1.2,
      fontFamily: MStyles.tempoDefaultFontFamily,
    );

TextStyle get titleText20 => const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 20,
      height: 1.2,
      fontFamily: MStyles.tempoDefaultFontFamily,
    );
