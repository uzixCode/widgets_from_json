import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'component.dart';

class WidgetsController extends Cubit<int> {
  WidgetsController() : super(0);
  void refresher() => emit(state + 1);
  Map<String, Map<String, dynamic>> result = {};
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
    switch (element["type"]) {
      case "TextField":
        result[element["key"]] = {};
        element.forEach((key, value) {
          result[element["key"]]?[key] = value;
        });
        result[element["key"]]?["value"] = TextEditingController();
        result[element["key"]]?["state"] = Component();
        result[element["key"]]?["isNullable"] = element["isNullable"] ?? true;
        break;
      case "Column":
        result[element["key"]] = {};
        element.forEach((key, value) {
          result[element["key"]]?[key] = value;
        });
        result[element["key"]]?["state"] = Component();
        result[element["key"]]?["isNullable"] = element["isNullable"] ?? true;
        if (element["children"] != null) {
          element["children"]?.forEach((element) {
            _initData(element);
          });
        }
        break;
      case "Row":
        result[element["key"]] = {};
        element.forEach((key, value) {
          result[element["key"]]?[key] = value;
        });
        result[element["key"]]?["state"] = Component();
        result[element["key"]]?["isNullable"] = element["isNullable"] ?? true;
        if (element["children"] != null) {
          element["children"]?.forEach((element) {
            _initData(element);
          });
        }
        break;
      default:
        result[element["key"]] = {};
        element.forEach((key, value) {
          result[element["key"]]?[key] = value;
        });
        result[element["key"]]?["state"] = Component();
        result[element["key"]]?["isNullable"] = element["isNullable"] ?? true;
        break;
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

  @override
  Future<void> close() {
    return super.close();
  }
}
