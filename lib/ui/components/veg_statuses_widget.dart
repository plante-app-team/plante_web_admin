import 'package:flutter/material.dart';
import 'package:plante/model/veg_status.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante_web_admin/ui/components/radio_text.dart';

typedef OnVegStatusesChangeCallback = void Function(
    VegStatus? vegetarianStatus, VegStatus? veganStatus);

class VegStatusesWidget extends StatelessWidget {
  final OnVegStatusesChangeCallback _callback;
  final bool _editable;
  final VegStatus? _vegetarianStatus;
  final String? _vegetarianStatusSource;
  final VegStatus? _veganStatus;
  final String? _veganStatusSource;

  VegStatusesWidget(this._callback, this._editable, this._vegetarianStatus,
      this._vegetarianStatusSource, this._veganStatus, this._veganStatusSource);

  @override
  Widget build(BuildContext context) {
    final vegetarianChangeCallback = !_editable
        ? null
        : (VegStatus? value) {
            _callback.call(value, _veganStatus);
          };
    final veganChangeCallback = !_editable
        ? null
        : (VegStatus? value) {
            _callback.call(_vegetarianStatus, value);
          };

    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(children: [
          Text(
              '${context.strings.web_veg_statuses_widget_vegetarian_status_and_source} $_vegetarianStatusSource'),
          RadioText<VegStatus>(
              text: context.strings.web_veg_statuses_widget_veg_status_positive,
              value: VegStatus.positive,
              groupValue: _vegetarianStatus,
              onChanged: vegetarianChangeCallback),
          RadioText<VegStatus>(
              text: context.strings.web_veg_statuses_widget_veg_status_negative,
              value: VegStatus.negative,
              groupValue: _vegetarianStatus,
              onChanged: vegetarianChangeCallback),
          RadioText<VegStatus>(
              text: context.strings.web_veg_statuses_widget_veg_status_possible,
              value: VegStatus.possible,
              groupValue: _vegetarianStatus,
              onChanged: vegetarianChangeCallback),
          RadioText<VegStatus>(
              text: context.strings.web_veg_statuses_widget_veg_status_unknown,
              value: VegStatus.unknown,
              groupValue: _vegetarianStatus,
              onChanged: vegetarianChangeCallback),
        ]),
        SizedBox(width: 50),
        Column(children: [
          Text(
              '${context.strings.web_veg_statuses_widget_vegan_status_and_source} $_veganStatusSource'),
          RadioText<VegStatus>(
              text: context.strings.web_veg_statuses_widget_veg_status_positive,
              value: VegStatus.positive,
              groupValue: _veganStatus,
              onChanged: veganChangeCallback),
          RadioText<VegStatus>(
              text: context.strings.web_veg_statuses_widget_veg_status_negative,
              value: VegStatus.negative,
              groupValue: _veganStatus,
              onChanged: veganChangeCallback),
          RadioText<VegStatus>(
              text: context.strings.web_veg_statuses_widget_veg_status_possible,
              value: VegStatus.possible,
              groupValue: _veganStatus,
              onChanged: veganChangeCallback),
          RadioText<VegStatus>(
              text: context.strings.web_veg_statuses_widget_veg_status_unknown,
              value: VegStatus.unknown,
              groupValue: _veganStatus,
              onChanged: veganChangeCallback),
        ]),
      ]),
      RadioText<bool>(
          text: context
              .strings.web_veg_statuses_widget_erase_product_veg_statuses,
          value: true,
          groupValue: _veganStatus == null && _vegetarianStatus == null,
          onChanged: (value) {
            if (value == true) {
              _callback.call(null, null);
            } else if (value == false) {
              _callback.call(VegStatus.unknown, VegStatus.unknown);
            }
          }),
    ]);
  }
}
