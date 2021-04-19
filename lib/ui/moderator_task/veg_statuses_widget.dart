import 'package:flutter/material.dart';
import 'package:untitled_vegan_app_web_admin/model/veg_status.dart';

typedef OnVegStatusesChangeCallback =
void Function(VegStatus? vegetarianStatus, VegStatus? veganStatus);

class VegStatusesWidget extends StatelessWidget {
  final OnVegStatusesChangeCallback _callback;
  final bool _editable;
  final VegStatus? _vegetarianStatus;
  final String? _vegetarianStatusSource;
  final VegStatus? _veganStatus;
  final String? _veganStatusSource;

  VegStatusesWidget(
      this._callback,
      this._editable,
      this._vegetarianStatus,
      this._vegetarianStatusSource,
      this._veganStatus,
      this._veganStatusSource);
  
  @override
  Widget build(BuildContext context) {
    final vegetarianChangeCallback = !_editable ? null : (VegStatus? value) {
      _callback.call(value, _veganStatus);
    };
    final veganChangeCallback = !_editable ? null : (VegStatus? value) {
      _callback.call(_vegetarianStatus, value);
    };

    return Column(children: [
      Row(children: [
        Column(children: [
          Text("Вегетарианский статус,\nисточник: $_vegetarianStatusSource"),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.positive,
                groupValue: _vegetarianStatus,
                onChanged: vegetarianChangeCallback),
            Text("Точно да"),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.negative,
                groupValue: _vegetarianStatus,
                onChanged: vegetarianChangeCallback),
            Text("Точно нет"),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.possible,
                groupValue: _vegetarianStatus,
                onChanged: vegetarianChangeCallback),
            Text("Возможно"),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.unknown,
                groupValue: _vegetarianStatus,
                onChanged: vegetarianChangeCallback),
            Text("Непонятно"),
          ]),
        ]),

        Column(children: [
          Text("Веганский статус,\nисточник: $_veganStatusSource"),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.positive,
                groupValue: _veganStatus,
                onChanged: veganChangeCallback),
            Text("Точно да"),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.negative,
                groupValue: _veganStatus,
                onChanged: veganChangeCallback),
            Text("Точно нет"),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.possible,
                groupValue: _veganStatus,
                onChanged: veganChangeCallback),
            Text("Возможно"),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.unknown,
                groupValue: _veganStatus,
                onChanged: veganChangeCallback),
            Text("Непонятно"),
          ]),
        ]),
      ]),
    ]);
  }
}
