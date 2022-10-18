import 'package:flutter/material.dart';

import 'package:widgets_from_json/widgets_from_json.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final widgetsController = WidgetsController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Widgets From Json'),
        ),
        body: WidgetsFromJson(
          controller: widgetsController,
          source: const {
            "field": [
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
                          "child": {"type": "Text", "value": "Container"}
                        }
                      }
                    }
                  }
                }
              }
            ]
          },
          costumComponent: (context, key, type, state) {
            switch (type) {
              case "Text":
                return Text(state[key]?["value"] ?? "-");
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
                  children: state[key]?["children"]
                          ?.map<Widget>(
                              (e) => widgetsController.getComponent(e))
                          .toList() ??
                      [],
                );
              case "Row":
                return Row(
                  children: state[key]?["children"]
                          ?.map<Widget>(
                              (e) => widgetsController.getComponent(e))
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
                return UnconstrainedBox(
                  child: InkWell(
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
                          : widgetsController
                              .getComponent(state[key]?["child"]),
                    ),
                  ),
                );
              case "Padding":
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: state[key]?["child"] == null
                      ? null
                      : widgetsController.getComponent(state[key]?["child"]),
                );
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
