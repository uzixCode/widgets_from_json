import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/component.dart';
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
  @override
  void initState() {
    widget.controller.initialize(widget.source);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fieldType == WidgetType.column) {
      return Column(
        children: widget.source["field"]
                ?.map<Widget>((e) => getComponent(e))
                .toList() ??
            [],
      );
    }
    return ListView(
      children: widget.source["field"]
              ?.map<Widget>((e) => getComponent(e))
              .toList() ??
          [],
    );
  }

  Widget getComponent(Map<String, dynamic> e) => BlocProvider.value(
        value: widget.controller.result[e["key"]]?["state"] as Component,
        child: Builder(builder: (context) {
          context.watch<Component>();
          return widget.costumComponent != null
              ? widget.costumComponent!(
                  context, e["key"], e["type"], widget.controller.result)
              : const SizedBox();
        }),
      );
}
