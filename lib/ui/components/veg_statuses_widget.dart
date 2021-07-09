import 'package:flutter/material.dart';
import 'package:plante/model/moderator_choice_reason.dart';
import 'package:plante/model/veg_status.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante/model/veg_status_source.dart';
import 'package:plante/outside/backend/backend_product.dart';
import 'package:plante/ui/base/components/dropdown_plante.dart';
import 'package:plante/ui/base/components/input_field_multiline_plante.dart';
import 'package:plante/ui/base/text_styles.dart';
import 'package:plante_web_admin/ui/components/radio_text.dart';

typedef OnVegStatusesChangeCallback = void Function(
    BackendProduct updatedProduct);

class VegStatusesWidget extends StatefulWidget {
  final OnVegStatusesChangeCallback callback;
  final bool editable;
  final BackendProduct initialProduct;

  VegStatusesWidget(this.callback, this.editable, this.initialProduct,
      {Key? key})
      : super(key: key);

  @override
  _VegStatusesWidgetState createState() => _VegStatusesWidgetState();
}

class _VegStatusesWidgetState extends State<VegStatusesWidget> {
  late BackendProduct _product;

  bool get _editable => widget.editable;

  VegStatus? get _vegetarianStatus {
    if (_product.vegetarianStatus == null) {
      return null;
    }
    return VegStatus.safeValueOf(_product.vegetarianStatus!);
  }

  VegStatus? get _veganStatus {
    if (_product.veganStatus == null) {
      return null;
    }
    return VegStatus.safeValueOf(_product.veganStatus!);
  }

  ModeratorChoiceReason? get _vegetarianChoiceReason {
    if (_product.moderatorVegetarianChoiceReason == null) {
      return null;
    }
    return moderatorChoiceReasonFromPersistentId(
        _product.moderatorVegetarianChoiceReason!);
  }

  ModeratorChoiceReason? get _veganChoiceReason {
    if (_product.moderatorVeganChoiceReason == null) {
      return null;
    }
    return moderatorChoiceReasonFromPersistentId(
        _product.moderatorVeganChoiceReason!);
  }

  @override
  void initState() {
    super.initState();
    _product = widget.initialProduct.rebuild((e) => e
      ..vegetarianStatusSource = VegStatusSource.moderator.name
      ..veganStatusSource = VegStatusSource.moderator.name);
  }

  void updateProduct(BackendProduct updatedProduct) {
    _product = updatedProduct;
    widget.callback.call(_product);
  }

  @override
  void didUpdateWidget(VegStatusesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialProduct != _product) {
      _product = widget.initialProduct;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vegetarianChangeCallback = !_editable
        ? null
        : (VegStatus? value) {
            updateProduct(
                _product.rebuild((e) => e.vegetarianStatus = value?.name));
          };
    final veganChangeCallback = !_editable
        ? null
        : (VegStatus? value) {
            updateProduct(_product.rebuild((e) => e.veganStatus = value?.name));
          };

    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context
                      .strings.web_veg_statuses_widget_vegetarian_status),
                  RadioText<VegStatus>(
                      text: context
                          .strings.web_veg_statuses_widget_veg_status_positive,
                      value: VegStatus.positive,
                      groupValue: _vegetarianStatus,
                      onChanged: vegetarianChangeCallback),
                  RadioText<VegStatus>(
                      text: context
                          .strings.web_veg_statuses_widget_veg_status_negative,
                      value: VegStatus.negative,
                      groupValue: _vegetarianStatus,
                      onChanged: vegetarianChangeCallback),
                  RadioText<VegStatus>(
                      text: context
                          .strings.web_veg_statuses_widget_veg_status_possible,
                      value: VegStatus.possible,
                      groupValue: _vegetarianStatus,
                      onChanged: vegetarianChangeCallback),
                  RadioText<VegStatus>(
                      text: context
                          .strings.web_veg_statuses_widget_veg_status_unknown,
                      value: VegStatus.unknown,
                      groupValue: _vegetarianStatus,
                      onChanged: vegetarianChangeCallback),
                  _ModeratorChoiceReasoningWidget(
                      widget.editable,
                      _vegetarianStatus,
                      _vegetarianChoiceReason,
                      _product.moderatorVegetarianSourcesText,
                      vegetarianModeratorChoiceReasons(),
                      (choiceReason, sources) {
                    updateProduct(_product.rebuild((e) => e
                      ..moderatorVegetarianChoiceReason =
                          choiceReason?.persistentId
                      ..moderatorVegetarianSourcesText = sources));
                  }),
                ]),
            SizedBox(width: 50),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.strings.web_veg_statuses_widget_vegan_status),
                  RadioText<VegStatus>(
                      text: context
                          .strings.web_veg_statuses_widget_veg_status_positive,
                      value: VegStatus.positive,
                      groupValue: _veganStatus,
                      onChanged: veganChangeCallback),
                  RadioText<VegStatus>(
                      text: context
                          .strings.web_veg_statuses_widget_veg_status_negative,
                      value: VegStatus.negative,
                      groupValue: _veganStatus,
                      onChanged: veganChangeCallback),
                  RadioText<VegStatus>(
                      text: context
                          .strings.web_veg_statuses_widget_veg_status_possible,
                      value: VegStatus.possible,
                      groupValue: _veganStatus,
                      onChanged: veganChangeCallback),
                  RadioText<VegStatus>(
                      text: context
                          .strings.web_veg_statuses_widget_veg_status_unknown,
                      value: VegStatus.unknown,
                      groupValue: _veganStatus,
                      onChanged: veganChangeCallback),
                  _ModeratorChoiceReasoningWidget(widget.editable, _veganStatus,
                      _veganChoiceReason, _product.moderatorVeganSourcesText,
                      veganModeratorChoiceReasons(),
                      (choiceReason, sources) {
                    updateProduct(_product.rebuild((e) => e
                      ..moderatorVeganChoiceReason = choiceReason?.persistentId
                      ..moderatorVeganSourcesText = sources));
                  }),
                ]),
          ]),
      RadioText<bool>(
          text: context
              .strings.web_veg_statuses_widget_erase_product_veg_statuses,
          value: true,
          groupValue: _veganStatus == null && _vegetarianStatus == null,
          onChanged: _editable == false
              ? null
              : (value) {
                  if (value == true) {
                    updateProduct(_product.rebuild((e) => e
                      ..veganStatus = null
                      ..vegetarianStatus = null
                      ..veganStatusSource = null
                      ..vegetarianStatusSource = null
                      ..moderatorVegetarianChoiceReason = null
                      ..moderatorVegetarianSourcesText = null
                      ..moderatorVeganChoiceReason = null
                      ..moderatorVeganSourcesText = null));
                  } else if (value == false) {
                    updateProduct(_product.rebuild((e) => e
                      ..veganStatus = VegStatus.unknown.name
                      ..vegetarianStatus = VegStatus.unknown.name
                      ..veganStatusSource = VegStatusSource.moderator.name
                      ..vegetarianStatusSource = VegStatusSource.moderator.name
                      ..moderatorVegetarianChoiceReason = null
                      ..moderatorVegetarianSourcesText = null
                      ..moderatorVeganChoiceReason = null
                      ..moderatorVeganSourcesText = null));
                  }
                }),
    ]);
  }
}

typedef _ModeratorChoiceReasoningCallback = void Function(
    ModeratorChoiceReason? choiceReason, String? sources);

class _ModeratorChoiceReasoningWidget extends StatefulWidget {
  final bool editable;
  final VegStatus? vegStatus;
  final ModeratorChoiceReason? moderatorChoiceReason;
  final String? sources;
  final List<ModeratorChoiceReason> acceptableReasons;
  final _ModeratorChoiceReasoningCallback callback;
  _ModeratorChoiceReasoningWidget(this.editable, this.vegStatus,
      this.moderatorChoiceReason, this.sources, this.acceptableReasons, this.callback,
      {Key? key})
      : super(key: key);

  @override
  __ModeratorChoiceReasoningWidgetState createState() =>
      __ModeratorChoiceReasoningWidgetState();
}

class __ModeratorChoiceReasoningWidgetState
    extends State<_ModeratorChoiceReasoningWidget> {
  final _sourcesController = TextEditingController();

  List<ModeratorChoiceReason?> get acceptableReasons {
    final result = <ModeratorChoiceReason?>[];
    result.add(null);
    result.addAll(widget.acceptableReasons);
    return result;
  }

  @override
  void initState() {
    super.initState();
    _sourcesController.text = widget.sources ?? '';
    _sourcesController.addListener(() {
      final String? text;
      if (_sourcesController.text.isNotEmpty) {
        text = _sourcesController.text;
      } else {
        text = null;
      }
      widget.callback.call(widget.moderatorChoiceReason, text);
    });
  }

  @override
  void didUpdateWidget(_ModeratorChoiceReasoningWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.sources ?? '') != _sourcesController.text) {
      _sourcesController.text = widget.sources ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(children: [
        if (widget.vegStatus != null)
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Text(context.strings.web_veg_statuses_veg_status_choice_reason,
                    style: TextStyles.hint),
                DropdownPlante<ModeratorChoiceReason?>(
                    isExpanded: true,
                    value: widget.moderatorChoiceReason,
                    values: acceptableReasons,
                    dropdownItemBuilder: (value) {
                      final String text;
                      if (value != null) {
                        text =
                            '${value.persistentId}. ${value.localize(context)}';
                      } else {
                        text = '-';
                      }
                      return Text(text, style: TextStyles.normal);
                    },
                    onChanged: widget.editable == false
                        ? null
                        : (value) {
                            widget.callback.call(value, widget.sources);
                          })
              ]),
        if (widget.vegStatus != null && widget.moderatorChoiceReason != null)
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Text(
                    context.strings
                        .web_veg_statuses_veg_status_choice_reason_source,
                    style: TextStyles.hint),
                InputFieldMultilinePlante(
                  readOnly: !widget.editable,
                  controller: _sourcesController,
                ),
              ])
      ]),
    );
  }
}
