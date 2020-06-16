import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';
import 'package:flutter_shared/src/themes/color_params.dart';

class AppTheme {
  AppTheme({
    this.darkMode,
    this.integratedAppBar,
    this.transparentAppBar,
    this.googleFont,
  });

  bool integratedAppBar;
  bool darkMode;
  bool transparentAppBar;
  String googleFont;

  ThemeData get theme {
    ColorParams params;

    params = ColorParams(
        integratedAppBar: integratedAppBar,
        transparentAppBar: transparentAppBar);

    final Color appColor = params.appColor;

    final sliderTheme = SliderThemeData(
      activeTrackColor: appColor,
      disabledActiveTrackColor: appColor,
      disabledInactiveTrackColor: appColor,
      disabledThumbColor: appColor,
      inactiveTrackColor: appColor,
      thumbColor: appColor,
    );

    const floatingActionButtonTheme = FloatingActionButtonThemeData(
      // white on floatingAction button
      foregroundColor: Colors.white,
    );

    final iconTheme =
        IconThemeData(color: ThemeSetManager().currentTheme.textColor);

    final popupMenuTheme = PopupMenuThemeData(
      color: ThemeSetManager().currentTheme.backgroundColor,
    );

    final baseTheme = ThemeData(
      scaffoldBackgroundColor: ThemeSetManager().currentTheme.backgroundColor,
      popupMenuTheme: popupMenuTheme,
      primaryColorBrightness: Brightness.dark,
      bottomAppBarTheme: _bottomBarTheme(darkMode),
      textTheme: _textTheme(darkMode),
      iconTheme: iconTheme,
      accentColor: params.accentColor,
      dividerColor: params.accentColor.withOpacity(.5),
      primaryColor: appColor,
      toggleableActiveColor: appColor,
      dialogBackgroundColor: ThemeSetManager().currentTheme.backgroundColor,
      sliderTheme: sliderTheme,
      floatingActionButtonTheme: floatingActionButtonTheme,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle:
            TextStyle(color: ThemeSetManager().currentTheme.textAccentColor),
      ),
    );

    if (darkMode) {
      return baseTheme.copyWith(
        brightness: Brightness.dark,
        appBarTheme: _appBarTheme(true, params),
        buttonTheme: _buttonTheme(true),
      );
    }
    return baseTheme.copyWith(
      brightness: Brightness.light,
      appBarTheme: _appBarTheme(params.darkModeAppBarText, params),
      buttonTheme: _buttonTheme(params.darkModeForButtonText),
    );
  }

  // change the global font here
  TextTheme _fontChange(TextTheme theme) {
    // don't do it if Roboto or blank
    if (Utils.isEmpty(googleFont) ||
        googleFont == ThemeSetManager.defaultFont) {
      return theme;
    }

    return themeWithGoogleFont(googleFont, theme);
  }

  TextTheme _textTheme(bool darkMode) {
    Color textColor = Colors.black;

    if (darkMode) {
      textColor = Colors.white;
    }

    Color subtitleColor = Utils.darken(textColor, .2);
    Color headerTextColor = Colors.grey;
    Color buttonContentColor = Colors.white;

    final ThemeSet themeSet = ThemeSetManager().currentTheme;

    if (themeSet != null) {
      textColor = themeSet.textColor;
      subtitleColor = themeSet.textAccentColor;
      headerTextColor = themeSet.headerTextColor;
      buttonContentColor = themeSet.buttonContentColor;
    }

    TextTheme startTheme = ThemeData.light().textTheme;

    if (darkMode) {
      startTheme = ThemeData.dark().textTheme;
    }

    final result = startTheme.copyWith(
      button: TextStyle(
        fontWeight: FontWeight.bold,
        color: buttonContentColor,
      ),

      // used for ListTile title in drawer
      bodyText1: startTheme.bodyText1.copyWith(
        fontSize: 17.0,
        color: textColor,
      ),

      // used for ListTile subtitle in non-drawer list
      bodyText2: startTheme.bodyText2.copyWith(
        color: textColor,
        fontSize: 16.0,
      ),

      // used for control text
      subtitle1: startTheme.bodyText1.copyWith(
        fontSize: 16.0,
        color: textColor,
      ),

      // used for header title
      headline4: TextStyle(
        color: headerTextColor,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),

      // Google fonts list and others
      headline6: startTheme.headline6.copyWith(
        color: textColor,
      ),

      // used for listTile subtitle
      caption: startTheme.bodyText1.copyWith(
        fontSize: 14.0,
        color: subtitleColor,
      ),
    );

    return _fontChange(result);
  }

  TextTheme _appBarTextTheme(bool darkMode, ColorParams params) {
    final result = _textTheme(darkMode).copyWith(
      headline6: TextStyle(
        color: params.getBarTextColor(darkMode: darkMode),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );

    return _fontChange(result);
  }

  ButtonThemeData _buttonTheme(bool darkMode) {
    ButtonThemeData startTheme = ThemeData.light().buttonTheme;
    if (darkMode) {
      startTheme = ThemeData.dark().buttonTheme;
    }

    final result = startTheme.copyWith(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return result;
  }

  AppBarTheme _appBarTheme(bool darkMode, ColorParams params) {
    return AppBarTheme(
      color: darkMode ? params.barColorDark : params.barColor,
      elevation: params.barElevation,
      iconTheme:
          IconThemeData(color: params.getBarTextColor(darkMode: darkMode)),
      actionsIconTheme: IconThemeData(
        color: params.getBarTextColor(darkMode: darkMode),
      ),
      textTheme: _appBarTextTheme(darkMode, params),
      brightness: darkMode ? Brightness.dark : Brightness.light,
    );
  }

  BottomAppBarTheme _bottomBarTheme(bool darkMode) {
    return BottomAppBarTheme(
      color: darkMode ? Colors.white : Colors.black,
    );
  }
}
