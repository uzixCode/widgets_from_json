import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/form_controller.dart';
export 'cubit/form_controller.dart';
export 'cubit/component.dart';

enum WidgetType { listView, column, row, child }

// ignore: must_be_immutable
class WidgetsFromJson extends StatelessWidget {
  WidgetsFromJson(
      {super.key,
      required this.controller,
      required this.source,
      this.resultBuilder,
      this.radio,
      this.costumComponent,
      this.fieldType,
      this.mainAxisAlignment,
      this.defaultComponent,
      this.onWarning});
  WidgetsController controller;
  Map<String, dynamic> source;
  Widget Function(String key, Map<String, Map<String, dynamic>> state)? radio;
  Widget Function(
      BuildContext context,
      String key,
      String type,
      Map<String, Map<String, dynamic>> state,
      Map<String, dynamic> source)? defaultComponent;

  /// [costumComponent] will override default [defaultComponent] if it has same type
  Widget? Function(
      BuildContext context,
      String key,
      String type,
      Map<String, Map<String, dynamic>> state,
      Map<String, dynamic> source)? costumComponent;
  Function(String key, String type, Map<String, dynamic> state)? onWarning;
  void Function(Map<String, Map<String, dynamic>> result)? resultBuilder;
  WidgetType? fieldType;
  String? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: controller,
      child: _Main(
          key: key,
          controller: controller,
          source: source,
          costumComponent: costumComponent,
          defaultComponent: defaultComponent,
          fieldType: fieldType,
          mainAxisAlignment: mainAxisAlignment,
          onWarning: onWarning,
          radio: radio,
          resultBuilder: resultBuilder),
    );
  }
}

class _Main extends StatefulWidget {
  _Main(
      {super.key,
      required this.controller,
      required this.source,
      this.resultBuilder,
      this.radio,
      this.costumComponent,
      this.fieldType,
      this.mainAxisAlignment,
      this.defaultComponent,
      this.onWarning});
  WidgetsController controller;
  Map<String, dynamic> source;
  Widget Function(String key, Map<String, Map<String, dynamic>> state)? radio;
  Widget Function(
      BuildContext context,
      String key,
      String type,
      Map<String, Map<String, dynamic>> state,
      Map<String, dynamic> source)? defaultComponent;

  /// [costumComponent] will override default [defaultComponent] if it has same type
  Widget? Function(
      BuildContext context,
      String key,
      String type,
      Map<String, Map<String, dynamic>> state,
      Map<String, dynamic> source)? costumComponent;
  Function(String key, String type, Map<String, dynamic> state)? onWarning;
  void Function(Map<String, Map<String, dynamic>> result)? resultBuilder;
  WidgetType? fieldType;
  String? mainAxisAlignment;
  @override
  State<_Main> createState() => _WidgetsFromJsonState();
}

class _WidgetsFromJsonState extends State<_Main> {
  List<Map<String, dynamic>>? list = [];
  @override
  void initState() {
    if (widget.source["field"] != null) {
      widget.controller.initialize(widget.source);
      widget.controller.costumComponent = widget.costumComponent;
      widget.controller.defaultComponent = widget.defaultComponent;
      widget.controller.onWarning = widget.onWarning;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WidgetsController>();
    if (controller.source["field"] == null) {
      return const SizedBox();
    }
    if (controller.source["field"] is! List) {
      return controller.getComponent(controller.source["field"]);
    }
    if (widget.fieldType == WidgetType.column) {
      return Column(
        mainAxisAlignment: mainAxisAlignment(widget.mainAxisAlignment),
        children: controller.source["field"]
                ?.map<Widget>((e) => controller.getComponent(e))
                .toList() ??
            [],
      );
    }
    if (widget.fieldType == WidgetType.row) {
      return Row(
        mainAxisAlignment: mainAxisAlignment(widget.mainAxisAlignment),
        children: controller.source["field"]
                ?.map<Widget>((e) => controller.getComponent(e))
                .toList() ??
            [],
      );
    }

    return ListView(
      children: controller.source["field"]
              ?.map<Widget>((e) => controller.getComponent(e))
              .toList() ??
          [],
    );
  }

  MainAxisAlignment mainAxisAlignment(String? alignment) {
    switch (alignment) {
      case "center":
        return MainAxisAlignment.center;
      case "end":
        return MainAxisAlignment.end;
      case "around":
        return MainAxisAlignment.spaceAround;
      case "evenly":
        return MainAxisAlignment.spaceEvenly;
      case "between":
        return MainAxisAlignment.spaceBetween;
      default:
        return MainAxisAlignment.start;
    }
  }
}
