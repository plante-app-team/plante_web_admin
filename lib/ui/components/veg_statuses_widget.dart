import 'package:flutter/material.dart';
import 'package:plante/base/base.dart';
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

  VegStatus? get _veganStatus {
    if (_product.veganStatus == null) {
      return null;
    }
    return VegStatus.safeValueOf(_product.veganStatus!);
  }

  @override
  void initState() {
    super.initState();
    _product = widget.initialProduct
        .rebuild((e) => e..veganStatusSource = VegStatusSource.moderator.name);
  }

  void updateProduct(BackendProduct updatedProduct) {
    final oldVegStatus = _veganStatus;
    _product = updatedProduct;
    if (oldVegStatus != _veganStatus) {
      _product = _product.rebuild((e) => e
        ..moderatorVeganChoiceReasons = null
        ..moderatorVeganSourcesText = null);
    }
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
    final veganChangeCallback = !_editable
        ? null
        : (VegStatus? value) {
            updateProduct(_product.rebuild((e) => e.veganStatus = value?.name));
          };

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(context.strings.web_veg_statuses_widget_vegan_status),
            RadioText<VegStatus>(
                text:
                    context.strings.web_veg_statuses_widget_veg_status_positive,
                value: VegStatus.positive,
                groupValue: _veganStatus,
                onChanged: veganChangeCallback),
            RadioText<VegStatus>(
                text:
                    context.strings.web_veg_statuses_widget_veg_status_negative,
                value: VegStatus.negative,
                groupValue: _veganStatus,
                onChanged: veganChangeCallback),
            RadioText<VegStatus>(
                text:
                    context.strings.web_veg_statuses_widget_veg_status_possible,
                value: VegStatus.possible,
                groupValue: _veganStatus,
                onChanged: veganChangeCallback),
            RadioText<VegStatus>(
                text:
                    context.strings.web_veg_statuses_widget_veg_status_unknown,
                value: VegStatus.unknown,
                groupValue: _veganStatus,
                onChanged: veganChangeCallback),
            _ModeratorChoiceReasonsStrWidget(
                widget.editable,
                _veganStatus,
                _product.moderatorVeganChoiceReasons,
                _veganStatus?.possibleReasons ?? const [], (newVal) {
              updateProduct(_product
                  .rebuild((e) => e..moderatorVeganChoiceReasons = newVal));
            }),
            _ModeratorCommentWidget(
                widget.editable,
                _veganStatus,
                _product.moderatorVeganSourcesText,
                _product.moderatorVeganChoiceReasonsList, (sources) {
              updateProduct(_product
                  .rebuild((e) => e..moderatorVeganSourcesText = sources));
            }),
          ])),
      RadioText<bool>(
          text: context
              .strings.web_veg_statuses_widget_erase_product_veg_statuses,
          value: true,
          groupValue: _veganStatus == null,
          onChanged: _editable == false
              ? null
              : (value) {
                  if (value == true) {
                    updateProduct(_product.rebuild((e) => e
                      ..veganStatus = null
                      ..veganStatusSource = null
                      ..moderatorVeganChoiceReasons = null
                      ..moderatorVeganSourcesText = null));
                  } else if (value == false) {
                    updateProduct(_product.rebuild((e) => e
                      ..veganStatus = VegStatus.unknown.name
                      ..veganStatusSource = VegStatusSource.moderator.name
                      ..moderatorVeganChoiceReasons = null
                      ..moderatorVeganSourcesText = null));
                  }
                }),
    ]);
  }
}

class _ModeratorCommentWidget extends StatefulWidget {
  final bool editable;
  final VegStatus? vegStatus;
  final String? comment;
  final List<ModeratorChoiceReason> moderatorChoiceReasons;
  final ArgCallback<String?> callback;
  _ModeratorCommentWidget(this.editable, this.vegStatus, this.comment,
      this.moderatorChoiceReasons, this.callback,
      {Key? key})
      : super(key: key);

  @override
  _ModeratorCommentWidgetState createState() => _ModeratorCommentWidgetState();
}

class _ModeratorCommentWidgetState extends State<_ModeratorCommentWidget> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentController.text = widget.comment ?? '';
    _commentController.addListener(() {
      final String? text;
      if (_commentController.text.isNotEmpty) {
        text = _commentController.text;
      } else {
        text = null;
      }
      widget.callback.call(text);
    });
  }

  @override
  void didUpdateWidget(_ModeratorCommentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.comment ?? '') != _commentController.text) {
      _commentController.text = widget.comment ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (widget.vegStatus != null && widget.moderatorChoiceReasons.isNotEmpty)
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Text(context
                  .strings.web_veg_statuses_veg_status_choice_reason_source),
              InputFieldMultilinePlante(
                readOnly: !widget.editable,
                controller: _commentController,
              ),
            ])
    ]);
  }
}

class _ModeratorChoiceReasonsStrWidget extends StatefulWidget {
  final bool editable;
  final VegStatus? vegStatus;
  final String? moderatorChoiceReasonsStr;
  final List<ModeratorChoiceReason> acceptableReasons;
  final ArgCallback<String?> callback;
  _ModeratorChoiceReasonsStrWidget(this.editable, this.vegStatus,
      this.moderatorChoiceReasonsStr, this.acceptableReasons, this.callback,
      {Key? key})
      : super(key: key);

  @override
  _ModeratorChoiceReasonsStrWidgetState createState() =>
      _ModeratorChoiceReasonsStrWidgetState();
}

class _ModeratorChoiceReasonsStrWidgetState
    extends State<_ModeratorChoiceReasonsStrWidget> {
  final chosenReasons = <ModeratorChoiceReason>[];

  @override
  void initState() {
    super.initState();
    chosenReasons.addAll(moderatorChoiceReasonFromPersistentIdsStr(
        widget.moderatorChoiceReasonsStr));
  }

  @override
  void didUpdateWidget(_ModeratorChoiceReasonsStrWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    chosenReasons.removeWhere((e) => !widget.acceptableReasons.contains(e));
  }

  List<ModeratorChoiceReason?> get acceptableReasons {
    final result = <ModeratorChoiceReason?>[];
    result.add(null);
    result.addAll(widget.acceptableReasons);
    result.removeWhere((e) => chosenReasons.contains(e));
    return result;
  }

  String? get chosenReasonsStr {
    if (chosenReasons.isEmpty) {
      return null;
    }
    return chosenReasons.map((e) => e.persistentId).join(',');
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text(context.strings.web_veg_statuses_veg_status_choice_reason),
          ...chosenReasons.map((e) => Column(children: [
                Row(children: [
                  IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: !widget.editable
                          ? null
                          : () {
                              setState(() {
                                chosenReasons.remove(e);
                                widget.callback.call(chosenReasonsStr);
                              });
                            }),
                  Flexible(
                      child: SelectableText(
                          '${e.persistentId}. ' + e.localize(context),
                          style: TextStyles.normal)),
                ]),
                const SizedBox(height: 8),
              ])),
          DropdownPlante<ModeratorChoiceReason?>(
              isExpanded: true,
              value: null,
              values: acceptableReasons,
              dropdownItemBuilder: (value) {
                final String text;
                if (value != null) {
                  text = '${value.persistentId}. ${value.localize(context)}';
                } else {
                  text = '-';
                }
                return Text(text, style: TextStyles.normal);
              },
              onChanged: widget.editable == false
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          chosenReasons.add(value);
                          widget.callback.call(chosenReasonsStr);
                        });
                      }
                    })
        ]);
    return Column(children: [if (widget.vegStatus != null) content]);
  }
}

extension _VegStatusExt on VegStatus {
  List<ModeratorChoiceReason> get possibleReasons {
    final result = ModeratorChoiceReason.values
        .where((e) => e.targetStatuses.contains(this))
        .toList();
    result.sort((ModeratorChoiceReason lhs, ModeratorChoiceReason rhs) =>
        lhs.persistentId - rhs.persistentId);
    return result;
  }
}

extension _BackendProductExt on BackendProduct {
  List<ModeratorChoiceReason> get moderatorVeganChoiceReasonsList {
    return moderatorChoiceReasonFromPersistentIdsStr(
        moderatorVeganChoiceReasons);
  }
}
