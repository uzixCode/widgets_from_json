import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'component.dart';

class WidgetsController extends Cubit<int> {
  WidgetsController() : super(0);
  void refresher() => emit(state + 1);
  Map<String, Map<String, dynamic>> result = {};
  Widget Function(BuildContext context, String key, String type,
      Map<String, Map<String, dynamic>> state)? costumComponent;
  void changeValue(
      {required String key, required String valueKey, required dynamic value}) {
    result[key]![valueKey] = value;
    (result[key]!["state"] as Component).refresher();
  }

  void initialize(Map<String, List<Map<String, dynamic>>> source) {
    source["field"]?.forEach((element) {
      _initData(element);
    });
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

  Map<String, dynamic>? getResult([BuildContext? context]) {
    Map<String, dynamic> temp = {};
    bool isPassed = true;
    result.forEach((key, value) {
      switch (value["type"]) {
        case "TextField":
          if (value["isNullable"] == false && value["value"].text.isEmpty) {
            if (context != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("${value["label"]} Tidak Boleh kosong")));
            }
            isPassed = false;
            break;
          }
          temp[key] = value["value"].text;
          break;
        default:
          if (value["isNullable"] == false && value["value"] == null) {
            if (context != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("${value["label"]} Tidak Boleh kosong")));
            }
            isPassed = false;
            break;
          }
          temp[key] = value["value"];
      }
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
          return costumComponent != null
              ? costumComponent!(context, e["key"], e["type"], result)
              : const SizedBox();
        }),
      );
  @override
  Future<void> close() {
    return super.close();
  }
}
