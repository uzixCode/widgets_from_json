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
              {"key": "judul", "type": "Text", "value": "Widgets From Json"}
            ]
          },
          costumComponent: (context, key, type, state) {
            switch (type) {
              case "Text":
                return Text(state[key]?["value"] ?? "-");
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
