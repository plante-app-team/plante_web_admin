import 'package:flutter/material.dart';
import 'package:plante/ui/base/text_styles.dart';

class CheckboxText extends StatelessWidget {
  final String text;

  /// See [Checkbox.value]
  final bool? value;

  /// See [Checkbox.onChanged]
  final ValueChanged<bool?>? onChanged;

  const CheckboxText(
      {Key? key,
      required this.text,
      required this.value,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: () {
              onChanged?.call(!(value ?? false));
            },
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Checkbox(value: value, onChanged: onChanged),
              Text(text, style: TextStyles.normal),
            ])));
  }
}
