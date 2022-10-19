import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'component.dart';

class WidgetsController extends Cubit<int> {
  WidgetsController() : super(0);
  void refresher() => emit(state + 1);
  Map<String, Map<String, dynamic>> result = {};
  Widget? Function(BuildContext context, String key, String type,
      Map<String, Map<String, dynamic>> state)? costumComponent;
  Widget Function(BuildContext context, String key, String type,
      Map<String, Map<String, dynamic>> state)? defaultComponent;
  Function(String key, String type, Map<String, dynamic> state)? onWarning;
  Map<String, dynamic> source = {};
  void changeValue(
      {required String key, required String valueKey, required dynamic value}) {
    if (result[key]?[valueKey] != null) {
      result[key]![valueKey] = value;
      (result[key]!["state"] as Component).refresher();
    }
  }

  void intercepting(Map<String, dynamic> s) {
    source = Map.of(s);
    if (source["field"] != null) {
      if (source["field"] is List) {
        source["field"] = source["field"]!.map((e) => intercept(e)).toList();
      } else {
        source["field"] = intercept(source["field"]);
      }
    }
  }

  void initialize(Map<String, dynamic> s) {
    result.clear();
    intercepting(s);
    if (source["field"] is List) {
      source["field"]?.forEach((element) {
        _initData(element);
      });
    } else {
      _initData(source["field"]);
    }
    refresher();
  }

  void _initData(Map<String, dynamic> element) {
    result[element["key"]] = {};
    element.forEach((key, value) {
      result[element["key"]]?[key] = value;
    });
    result[element["key"]]?["state"] = Component();
    result[element["key"]]?["isNullable"] = element["isNullable"] ?? true;
    if (element["child"] != null) {
      _initData(element["child"]);
    }
    if (element["children"] != null) {
      element["children"]?.forEach((element) {
        _initData(element);
      });
    }
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

  Map<String, dynamic>? getResult([BuildContext? context]) {
    Map<String, dynamic> temp = {};
    bool isPassed = true;
    result.forEach((key, value) {
      if (value["output"] != true) return;
      if (value["value"] is TextEditingController) {
        if (value["optional"] != true && value["value"].text.isEmpty) {
          if (onWarning != null) {
            onWarning!(value["key"], value["type"], value);
          }
          isPassed = false;
          return;
        }
        temp[key] = value["value"].text;
        return;
      }
      if (value["optional"] != true &&
          (value["value"] == null ||
              (value["value"] is String
                  ? value["value"] == ""
                  : value["value"] is int
                      ? value["value"] == 0
                      : value["value"] is double
                          ? value["value"] == 0
                          : false))) {
        if (onWarning != null) {
          onWarning!(value["key"], value["type"], value);
        }
        isPassed = false;
        return;
      }
      temp[key] = value["value"];
      return;
    });
    if (!isPassed) {
      return null;
    }

    return temp;
  }

  T setIfNull<T>(
      {required String key, required String valueKey, required T value}) {
    if (result[key]?[valueKey] == null) {
      result[key]?[valueKey] = value;
    }
    return result[key]?[valueKey];
  }

  Widget getComponent(Map<String, dynamic> e) => BlocProvider.value(
        value: result[e["key"]]?["state"] as Component,
        child: Builder(builder: (context) {
          context.watch<Component>();
          if (costumComponent != null) {
            return costumComponent!(context, e["key"], e["type"], result) ??
                (defaultComponent != null
                    ? defaultComponent!(context, e["key"], e["type"], result)
                    : const SizedBox());
          }
          return defaultComponent != null
              ? defaultComponent!(context, e["key"], e["type"], result)
              : const SizedBox();
        }),
      );
  @override
  Future<void> close() {
    return super.close();
  }
}
