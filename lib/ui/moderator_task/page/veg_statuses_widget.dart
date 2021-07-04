import 'package:flutter/material.dart';
import 'package:plante/model/veg_status.dart';
import 'package:plante/l10n/strings.dart';

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
      Row(children: [
        Column(children: [
          Text(
              '${context.strings.web_veg_statuses_widget_vegetarian_status_and_source} $_vegetarianStatusSource'),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.positive,
                groupValue: _vegetarianStatus,
                onChanged: vegetarianChangeCallback),
            Text(context.strings.web_veg_statuses_widget_veg_status_positive),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.negative,
                groupValue: _vegetarianStatus,
                onChanged: vegetarianChangeCallback),
            Text(context.strings.web_veg_statuses_widget_veg_status_negative),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.possible,
                groupValue: _vegetarianStatus,
                onChanged: vegetarianChangeCallback),
            Text(context.strings.web_veg_statuses_widget_veg_status_possible),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.unknown,
                groupValue: _vegetarianStatus,
                onChanged: vegetarianChangeCallback),
            Text(context.strings.web_veg_statuses_widget_veg_status_unknown),
          ]),
        ]),
        Column(children: [
          Text(
              '${context.strings.web_veg_statuses_widget_vegan_status_and_source} $_veganStatusSource'),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.positive,
                groupValue: _veganStatus,
                onChanged: veganChangeCallback),
            Text(context.strings.web_veg_statuses_widget_veg_status_positive),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.negative,
                groupValue: _veganStatus,
                onChanged: veganChangeCallback),
            Text(context.strings.web_veg_statuses_widget_veg_status_negative),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.possible,
                groupValue: _veganStatus,
                onChanged: veganChangeCallback),
            Text(context.strings.web_veg_statuses_widget_veg_status_possible),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.unknown,
                groupValue: _veganStatus,
                onChanged: veganChangeCallback),
            Text(context.strings.web_veg_statuses_widget_veg_status_unknown),
          ]),
        ]),
      ]),
    ]);
  }
}
