// Radius
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verzo/ui/common/app_colors.dart';

OutlineInputBorder defaultFormBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(width: 1, color: kcFormBorderColor));

OutlineInputBorder defaultErrorFormBorder = OutlineInputBorder(
  // Highlighted border when focused
  borderRadius: BorderRadius.circular(8),
  borderSide: const BorderSide(
    width: 1, // Adjust the width to control the border thickness
    color: kcErrorColor,
  ),
);

OutlineInputBorder defaultFocusedFormBorder = OutlineInputBorder(
  // Highlighted border when focused
  borderRadius: BorderRadius.circular(8),
  borderSide: const BorderSide(
    width: 1, // Adjust the width to control the border thickness
    color: kcPrimaryColor,
  ),
);

OutlineInputBorder defaultFormBorderSmall = OutlineInputBorder(
    borderRadius: defaultBorderRadius,
    borderSide: BorderSide(
        width: 0.01, style: BorderStyle.solid, color: kcStrokeColor));
BorderRadius defaultBorderRadius = BorderRadius.circular(12);

BorderRadius defaultTagBorderRadius = BorderRadius.circular(20);

BorderRadius defaultCarouselBorderRadius = BorderRadius.circular(32);

// TextStyle
TextStyle ktsHeroText = GoogleFonts.plusJakartaSans(
  color: kcTextColor,
  fontSize: kHeroTextSize,
  fontWeight: FontWeight.bold,
);
TextStyle ktsHeroTextWhite = GoogleFonts.dmSans(
  color: kcButtonTextColor,
  fontSize: kHeroTextSize,
  fontWeight: FontWeight.bold,
);

TextStyle ktsTitleTextAuthentication = const TextStyle(
    fontFamily: 'Satoshi',
    letterSpacing: -0.3,
    height: 0,
    color: kcTextTitleColor,
    fontSize: 24,
    fontWeight: FontWeight.w500);

TextStyle ktsCardMetricsAmount = const TextStyle(
    fontFamily: 'Satoshi',
    letterSpacing: -0.3,
    height: 0,
    color: kcTextTitleColor,
    fontSize: 20,
    fontWeight: FontWeight.w700);

TextStyle ktsCardMetricsAmount2 = const TextStyle(
    fontFamily: 'Satoshi',
    letterSpacing: -0.3,
    height: 0,
    color: kcButtonTextColor,
    fontSize: 20,
    fontWeight: FontWeight.w700);

TextStyle ktsCardMetricsStats = const TextStyle(
  color: kcButtonTextColor,
  fontSize: 14,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w500,
  height: 0,
  letterSpacing: -0.30,
);

TextStyle ktsSubtitleTextAuthentication = const TextStyle(
    fontFamily: 'Satoshi',
    letterSpacing: -0.3,
    height: 0,
    color: kcTextSubTitleColor,
    fontSize: 16,
    fontWeight: FontWeight.w500);

TextStyle ktsSubtitleTextAuthentication2 = const TextStyle(
    fontFamily: 'Satoshi',
    letterSpacing: -0.3,
    height: 0,
    color: kcTextSubTitleColor,
    fontSize: 16,
    fontWeight: FontWeight.w700);

TextStyle ktsTextAuthentication = const TextStyle(
    fontFamily: 'Satoshi',
    letterSpacing: -0.3,
    height: 0,
    color: kcTextTitleColor,
    fontSize: 16,
    fontWeight: FontWeight.w500);

TextStyle ktsTextAuthentication2 = const TextStyle(
    fontFamily: 'Satoshi',
    letterSpacing: -0.3,
    height: 0,
    color: kcTextTitleColor,
    fontSize: 16,
    fontWeight: FontWeight.w700);

TextStyle ktsFormTitleText = const TextStyle(
  color: kcTextTitleColor,
  fontSize: 14,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w500,
  height: 0,
  letterSpacing: -0.30,
);

TextStyle ktsAddNewText = const TextStyle(
  color: kcPrimaryColor,
  fontSize: 14,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w500,
  height: 0,
  letterSpacing: -0.30,
);

TextStyle ktsAddNewText2 = const TextStyle(
  color: kcPrimaryColor,
  fontSize: 16,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w500,
  height: 0,
  letterSpacing: -0.30,
);

TextStyle ktsFormHintText = const TextStyle(
  color: kcTextSubTitleColor,
  fontSize: 14,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w500,
  height: 0,
  letterSpacing: -0.30,
);

TextStyle ktsButtonText = const TextStyle(
  color: kcButtonTextColor,
  fontSize: 16,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w500,
  height: 0,
  letterSpacing: -0.30,
);

TextStyle ktsButtonText2 = const TextStyle(
  color: kcButtonTextColor,
  fontSize: 14,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w700,
  height: 0,
  letterSpacing: -0.30,
);

TextStyle ktsBottomSheetHeaderText = const TextStyle(
  color: kcTextTitleColor,
  fontSize: 18,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w500,
  height: 0,
  letterSpacing: -0.30,
);

TextStyle ktsHeaderText = const TextStyle(
  color: kcTextTitleColor,
  fontSize: 20,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w700,
  height: 0,
  letterSpacing: -0.30,
);
TextStyle ktsQuantityText = const TextStyle(
  color: kcTextTitleColor,
  fontSize: 14,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w700,
  height: 0,
  letterSpacing: -0.30,
);

TextStyle ktsBorderText = const TextStyle(
  color: kcBorderTextColor,
  fontSize: 14,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w500,
  height: 0,
  letterSpacing: -0.30,
);

TextStyle ktsBorderText2 = const TextStyle(
  color: kcBorderTextColor,
  fontSize: 14,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w700,
  height: 0,
  letterSpacing: -0.30,
);

TextStyle ktsBorderText3 = const TextStyle(
  color: Colors.green,
  fontSize: 14,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w700,
  height: 0,
  letterSpacing: -0.30,
);
TextStyle ktsSubtitleTileText = const TextStyle(
  color: kcTextSubTitleColor,
  fontSize: 12,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w500,
  height: 0,
  letterSpacing: -0.30,
);

TextStyle ktsSubtitleTileText2 = const TextStyle(
  color: kcButtonTextColor,
  fontSize: 12,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w500,
  height: 0,
  letterSpacing: -0.30,
);

TextStyle ktsSubtitleTileText3 = const TextStyle(
  color: kcTextTitleColor,
  fontSize: 12,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w500,
  height: 0,
  letterSpacing: -0.30,
);

TextStyle ktsErrorText = TextStyle(
  color: kcErrorColor.withOpacity(0.9),
  fontSize: 12,
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.w500,
  height: 0,
  letterSpacing: -0.30,
);
TextStyle ktsHeaderTextWhite = const TextStyle(
    // color: kcButtonTextColor,
    // fontSize: 16,
    // fontFamily: 'Satoshi',
    // fontWeight: FontWeight.w500,
    // height: 0,
    // letterSpacing: -0.30,
    );

TextStyle ktsTitleText = GoogleFonts.dmSans(
  color: kcTextColor, //1
  fontSize: kTitleTextSize,
  fontWeight: FontWeight.bold,
);

TextStyle ktsParagraphText = GoogleFonts.dmSans(
  color: kcTextColorLight, //1
  fontSize: kParagraphTextSize,
  fontWeight: FontWeight.normal,
);
// TextStyle ktsButtonText = GoogleFonts.dmSans(
//   color: kcButtonTextColor,
//   fontSize: kParagraphTextSize,
//   fontWeight: FontWeight.normal,
// );
TextStyle ktsButtonTextBlue = GoogleFonts.dmSans(
  color: kcPrimaryColor,
  fontSize: kParagraphTextSize,
  fontWeight: FontWeight.normal,
);
TextStyle ktsButtonTextSmall = GoogleFonts.dmSans(
  color: kcButtonTextColor,
  fontSize: kBodyTextSize,
  fontWeight: FontWeight.normal,
);

TextStyle ktsBodyText = GoogleFonts.dmSans(
  color: kcTextColor,
  fontSize: 12,
  fontWeight: FontWeight.normal,
);
TextStyle ktsBodyTextWhite = GoogleFonts.dmSans(
  color: kcButtonTextColor,
  fontSize: 12,
  fontWeight: FontWeight.normal,
);
TextStyle ktsBodyTextx = GoogleFonts.dmSans(
  color: kcTextColor,
  fontSize: kBodyTextSize,
  fontWeight: FontWeight.w400,
);

TextStyle ktsBodyTextBold = GoogleFonts.dmSans(
  color: kcTextColor,
  fontSize: kBodyTextSize,
  fontWeight: FontWeight.bold,
);
TextStyle ktsBodyTextBoldOpaque = GoogleFonts.dmSans(
  color: kcTextColor.withOpacity(0.8),
  fontSize: kBodyTextSize,
  fontWeight: FontWeight.bold,
);

TextStyle ktsBodyText2 = GoogleFonts.dmSans(
  color: kcTextColor,
  fontSize: kParagraphTextSize,
  fontWeight: FontWeight.normal,
);

TextStyle ktsFormText = GoogleFonts.dmSans(
  color: kcTextFormColor, //2
  fontSize: kParagraphTextSize,
  fontWeight: FontWeight.normal,
);

TextStyle ktsBodyTextLight = GoogleFonts.dmSans(
  color: kcTextColorLight, //3
  fontSize: kBodyTextSize,
  fontWeight: FontWeight.normal,
);
TextStyle ktsSmallBodyText = GoogleFonts.dmSans(
  color: kcTextColorLight, //4
  fontSize: kSmallBodyTextSize,
  fontWeight: FontWeight.normal,
);
TextStyle ktsforgotpasswordText = GoogleFonts.dmSans(
  color: kcPrimaryColor, //4
  fontSize: kSmallBodyTextSize,
  fontWeight: FontWeight.normal,
);
// Font Sizing
const double kSmallBodyTextSize = 12;
const double kBodyTextSize = 14;
const double kParagraphTextSize = 16;
const double kTitleTextSize = 18;
const double kHeaderTextSize = 20;
const double kHeroTextSize = 32;
