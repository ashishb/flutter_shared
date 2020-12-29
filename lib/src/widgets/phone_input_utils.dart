import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_shared/flutter_shared.dart';

class PhoneInputUtils {
  static List inputFormatters() {
    return <TextInputFormatter>[
      // forces the first character to be 1 for country code
      TextInputFormatter.withFunction(
          (TextEditingValue oldValue, TextEditingValue newValue) {
        String newText = newValue.text;

        if (Utils.isNotEmpty(newText) && newText.length == 1) {
          if (newText[0] != '1' && newText[0] != '+') {
            newText = '1$newText';
          }
        }
        return newValue.copyWith(text: newText);
      }),
      PhoneInputFormatter(
        onCountrySelected: (PhoneCountryData countryData) =>
            print(countryData?.country),
      ),
    ];
  }

  static String validator(String value) {
    if (!isPhoneValid(value)) {
      return 'Phone is invalid';
    }
    return null;
  }
}
