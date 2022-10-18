import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'cubit/form_controller.dart';
export 'cubit/form_controller.dart';
export 'cubit/component.dart';

enum WidgetType { listView, column }

// ignore: must_be_immutable
class WidgetsFromJson extends StatefulWidget {
  WidgetsFromJson(
      {super.key,
      required this.controller,
      required this.source,
      this.resultBuilder,
      this.radio,
      this.costumComponent,
      this.fieldType});
  WidgetsController controller;
  Map<String, List<Map<String, dynamic>>> source;
  Widget Function(String key, Map<String, Map<String, dynamic>> state)? radio;
  Widget Function(BuildContext context, String key, String type,
      Map<String, Map<String, dynamic>> state)? costumComponent;
  void Function(Map<String, Map<String, dynamic>> result)? resultBuilder;
  WidgetType? fieldType;
  @override
  State<WidgetsFromJson> createState() => _WidgetsFromJsonState();
}

class _WidgetsFromJsonState extends State<WidgetsFromJson> {
  List<Map<String, dynamic>>? list = [];
  Map<String, List<Map<String, dynamic>>> _source = {};
  @override
  void initState() {
    _source = Map.of(widget.source);
    if (_source["field"] != null) {
      _source["field"] = _source["field"]!.map((e) => intercept(e)).toList();
    }
    log(_source.toString());
    widget.controller.initialize(_source);
    widget.controller.costumComponent = widget.costumComponent;
    super.initState();
  }

  Map<String, dynamic> intercept(Map<String, dynamic> element) {
    Map<String, dynamic> temp = Map.of(element);
    String widgetsKey = const Uuid().v4();
    if (temp["key"] == null) {
      temp["key"] = widgetsKey;
    }
    if (temp["child"] != null) {
      temp["child"] = intercept(temp["child"]);
    }
    if (temp["children"] != null) {
      temp["children"] = temp["children"]!.map((e) => intercept(e)).toList();
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fieldType == WidgetType.column) {
      return Column(
        children: _source["field"]
                ?.map<Widget>((e) => widget.controller.getComponent(e))
                .toList() ??
            [],
      );
    }
    return ListView(
      children: _source["field"]
              ?.map<Widget>((e) => widget.controller.getComponent(e))
              .toList() ??
          [],
    );
  }
}
