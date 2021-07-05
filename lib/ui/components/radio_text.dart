import 'package:flutter/material.dart';
import 'package:plante/ui/base/text_styles.dart';

class RadioText<T> extends StatelessWidget {
  final String text;

  /// See [Radio.value].
  final T value;

  /// See [Radio.groupValue].
  final T? groupValue;

  /// See [Radio.onChanged].
  final ValueChanged<T?>? onChanged;

  const RadioText(
      {Key? key,
      required this.text,
      required this.value,
      required this.groupValue,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: () {
              onChanged?.call(value);
            },
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Radio<T>(
                  value: value, groupValue: groupValue, onChanged: onChanged),
              Text(text, style: TextStyles.normal),
            ])));
  }
}
