import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';
import 'package:flutter_shared/src/widgets/form_builder/form_params.dart';

class FieldBuilder {
  static List<Widget> fields({
    @required FormBuilderParams builderParams,
    @required bool autovalidate,
    bool outlinedBorders = false,
  }) {
    final List<Widget> result = [];

    builderParams.map.keys.forEach((mapKey) {
      final formParams = builderParams.formParams;

      if (!formParams[mapKey].hide) {
        if (formParams[mapKey].type == String) {
          final formParam = formParams[mapKey];

          if (formParam.separateLabel) {
            result.add(Text(formParam.label()));
          }

          result.add(stringField(
            mapKey: mapKey,
            formParam: formParam,
            autovalidate: autovalidate,
            outlinedBorders: outlinedBorders,
          ));
        } else {
          final Widget customWidget = formParams[mapKey].createWidget();
          if (customWidget != null) {
            result.add(customWidget);
          }
        }
      }
    });

    return result;
  }

  static Widget stringField({
    @required String mapKey,
    @required FormParam formParam,
    @required bool autovalidate,
    bool outlinedBorders = false,
  }) {
    final border = outlinedBorders
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.white10))
        : null;

    final focusedBorder = outlinedBorders
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.white54))
        : null;

    final errorBorder = outlinedBorders
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.red[300]))
        : null;

    return Container(
      margin: EdgeInsets.only(bottom: outlinedBorders ? 16 : 10),
      child: TextFormField(
        keyboardType: formParam.keyboard,
        textInputAction: (formParam.maxLines == null || formParam.maxLines == 1)
            ? TextInputAction.next
            : TextInputAction.done,
        autovalidateMode:
            autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        initialValue: formParam.formData[mapKey] as String,
        minLines: formParam.minLines,
        maxLines: formParam.maxLines,
        autocorrect: formParam.autocorrect,
        enableSuggestions: formParam.enableSuggestions,
        decoration: InputDecoration(
          enabledBorder: border,
          focusedBorder: focusedBorder,
          errorBorder: errorBorder,
          labelText: formParam.separateLabel ? null : formParam.label(),

          // placeholder
          // hintText: mapKey.capitalize,

          // text below
          // helperText: mapKey.capitalize,
        ),
        inputFormatters:
            mapKey == 'phone' ? PhoneInputUtils.inputFormatters() : null,
        validator: (v) {
          if (formParam.req) {
            if (Utils.isEmpty(v)) {
              return 'Please enter ${mapKey.fromCamelCase()}';
            }
          }

          if (mapKey == 'phone' && Utils.isNotEmpty(v)) {
            return PhoneInputUtils.validator(v);
          }

          if (mapKey == 'email' && Utils.isNotEmpty(v)) {
            if (!StrUtils.isEmailValid(v)) {
              return 'Email invalid';
            }
          }

          return null;
        },
        onSaved: (String v) {
          formParam.formData[mapKey] = v.trim();
        },
      ),
    );
  }
}
