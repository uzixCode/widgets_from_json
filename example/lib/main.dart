import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:widgets_from_json/widgets_from_json.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

final view1 = {
  "field": {
    "type": "Column",
    "alignment": "between",
    "children": [
      {
        "type": "Row",
        "alignment": "between",
        "children": [
          {
            "type": "Container",
            "color": 0xffFB2576,
            "child": {
              "type": "Padding",
              "child": {
                "type": "Container",
                "color": 0xff3F0071,
                "child": {
                  "type": "Padding",
                  "child": {
                    "type": "Container",
                    "color": 0xffFF731D,
                    "child": {
                      "type": "Padding",
                      "child": {
                        "key": "Container1",
                        "type": "Text",
                        "value": "Container"
                      }
                    }
                  }
                }
              }
            }
          },
          {
            "type": "Container",
            "color": 0xffFB2576,
            "child": {
              "type": "Padding",
              "child": {
                "type": "Container",
                "color": 0xff3F0071,
                "child": {
                  "type": "Padding",
                  "child": {
                    "type": "Container",
                    "color": 0xffFF731D,
                    "child": {
                      "type": "Padding",
                      "child": {
                        "key": "Container2",
                        "type": "Text",
                        "value": "Container"
                      }
                    }
                  }
                }
              }
            }
          }
        ]
      },
      {"key": "title", "type": "Text", "output": true, "value": null},
      {
        "type": "Row",
        "alignment": "between",
        "children": [
          {
            "type": "Container",
            "color": 0xffFB2576,
            "child": {
              "type": "Padding",
              "child": {
                "type": "Container",
                "color": 0xff3F0071,
                "child": {
                  "type": "Padding",
                  "child": {
                    "type": "Container",
                    "color": 0xffFF731D,
                    "child": {
                      "type": "Padding",
                      "child": {
                        "key": "Container3",
                        "type": "Text",
                        "value": "Container"
                      }
                    }
                  }
                }
              }
            }
          },
          {
            "type": "Container",
            "color": 0xffFB2576,
            "child": {
              "type": "Padding",
              "child": {
                "type": "Container",
                "color": 0xff3F0071,
                "child": {
                  "type": "Padding",
                  "child": {
                    "type": "Container",
                    "color": 0xffFF731D,
                    "child": {
                      "type": "Padding",
                      "child": {
                        "key": "Container4",
                        "type": "Text",
                        "value": "Container"
                      }
                    }
                  }
                }
              }
            }
          }
        ]
      }
    ]
  }
};
final view2 = {
  "field": {
    "type": "Center",
    "child": {
      "type": "Container",
      "color": 0xffFB2576,
      "child": {
        "type": "Padding",
        "child": {
          "type": "Container",
          "color": 0xff3F0071,
          "child": {
            "type": "Padding",
            "child": {
              "type": "Container",
              "color": 0xffFF731D,
              "child": {
                "type": "Padding",
                "child": {"type": "Text", "value": "Container"}
              }
            }
          }
        }
      }
    }
  }
};
final view3 = {
  "field": {
    "type": "Center",
    "child": {
      "type": "SizedBox",
      "width": "50%",
      "height": "50%",
      "child": {
        "type": "Container",
        "color": 0xffFB2576,
        "child": {
          "type": "Center",
          "child": {"type": "Text", "value": "Container"}
        }
      }
    }
  }
};
final view4 = {
  "field": {
    "type": "Column",
    "alignment": "center",
    "children": [
      {
        "key": "username",
        "type": "TextField",
        "default": "TextField",
        "output": true
      }
    ]
  }
};

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final widgetsController = WidgetsController();
  Map<String, dynamic> source = view1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widgets From Json'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final importData = {
            "title": "Imported",
            "Container1": "Imported",
            "Container2": "Imported",
            "Container3": "Imported",
            "Container4": "Imported"
          };
          // log(widgetsController.getResult(context).toString());
          widgetsController.importData(importData);
          // if (source == view1) {
          //   source = view2;
          // } else if (source == view2) {
          //   source = view3;
          // } else {
          //   source = view1;
          // }
          // widgetsController.initialize(source);
        },
      ),
      body: WidgetsFromJson(
        controller: widgetsController,
        fieldType: WidgetType.row,
        mainAxisAlignment: "between",
        source: source,
        defaultComponent: (context, key, type, state) {
          switch (type) {
            case "Text":
              return Text(state[key]?["default"] != null
                  ? state[key]!["default"]
                  : (state[key]?["value"] ?? "-"));
            case "TextField":
              return TextField(
                controller: widgetsController.setIfNull<TextEditingController>(
                    key: key,
                    valueKey: "value",
                    value: TextEditingController(text: state[key]?["default"])),
              );
            case "HSpace":
              return SizedBox(
                height: (state[key]?["value"] ?? 0) * 1.0,
              );
            case "VSpace":
              return SizedBox(
                width: (state[key]?["value"] ?? 0) * 1.0,
              );
            case "Column":
              return Column(
                mainAxisAlignment: mainAxisAlignment(state[key]?["alignment"]),
                children: state[key]?["children"]
                        ?.map<Widget>((e) => widgetsController.getComponent(e))
                        .toList() ??
                    [],
              );
            case "Row":
              return Row(
                mainAxisAlignment: mainAxisAlignment(state[key]?["alignment"]),
                children: state[key]?["children"]
                        ?.map<Widget>((e) => widgetsController.getComponent(e))
                        .toList() ??
                    [],
              );
            case "Center":
              return Center(
                child: state[key]?["child"] == null
                    ? null
                    : widgetsController.getComponent(state[key]?["child"]),
              );
            case "Container":
              return InkWell(
                onTap: () {
                  widgetsController.changeValue(
                      key: key,
                      valueKey: "color",
                      value: (state[key]?["color"] ?? 0) * 10);
                },
                child: Container(
                  color: state[key]?["color"] == null
                      ? null
                      : Color(state[key]?["color"]),
                  child: state[key]?["child"] == null
                      ? null
                      : widgetsController.getComponent(state[key]?["child"]),
                ),
              );
            case "Padding":
              return Padding(
                padding: const EdgeInsets.all(10),
                child: state[key]?["child"] == null
                    ? null
                    : widgetsController.getComponent(state[key]?["child"]),
              );
            case "SizedBox":
              log(sizeDicider(context, state[key]?["width"]).toString());
              return SizedBox(
                width: sizeDicider(context, state[key]?["width"]),
                height: sizeDicider(context, state[key]?["height"]),
                child: state[key]?["child"] == null
                    ? null
                    : widgetsController.getComponent(state[key]?["child"]),
              );
            default:
              return const SizedBox();
          }
        },
        costumComponent: (context, key, type, state) {
          switch (type) {
            case "Padding":
              return Padding(
                padding: const EdgeInsets.all(10),
                child: state[key]?["child"] == null
                    ? null
                    : widgetsController.getComponent(state[key]?["child"]),
              );
          }
          return null;
        },
        onWarning: (key, type, state) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Lengkapi Semuanya")));
          log("$state");
        },
      ),
    );
  }

  double sizeDicider(BuildContext context, dynamic num,
      [String? widthOrHeight]) {
    try {
      if (num is double) {
        return num;
      }
      if (num is int) {
        return num * 1.0;
      }
      if (num is String) {
        if (num.trim().contains("%")) {
          if (widthOrHeight == "h") {
            return (MediaQuery.of(context).size.height / 100) *
                double.parse(num.trim().replaceAll("%", ""));
          }
          return (MediaQuery.of(context).size.width / 100) *
              double.parse(num.trim().replaceAll("%", ""));
        }
        return double.parse(num.trim());
      }
      return 0;
    } catch (e) {
      return 0;
    }
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
