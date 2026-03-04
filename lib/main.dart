import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:system_fonts/system_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ColorOS Font Test',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, String> fonts = {};
  String? currentFont;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final rs =
          await MethodChannel('utils').invokeListMethod('getFonts') ?? {};

      fonts = {};
      for (final f in rs) {
        final mp = f as Map;
        fonts[mp['name'] as String] = mp['path'] as String;
      }
      setState(() {});
    });
  }

  void selectFont(String family) async {
    final path = fonts[family]!;
    final file = File(path);
    if (!await file.exists()) {
      debugPrint('Font file not found: $path');
      return;
    }

    final bytes = await file.readAsBytes();
    final fontLoader = FontLoader(family);
    fontLoader.addFont(Future.value(ByteData.view(bytes.buffer)));
    await fontLoader.load();
    currentFont = family;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(fontFamily: currentFont),
      child: Scaffold(
        appBar: AppBar(title: Text('ColorOS Font Test')),
        body: SingleChildScrollView(
          padding: .symmetric(horizontal: 18, vertical: 16),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              DropdownButton(
                hint: Text('字体列表'),
                isExpanded: true,
                value: currentFont ?? 'default',
                items: [
                  DropdownMenuItem(
                    value: 'default',
                    child: Text('system default', overflow: .ellipsis),
                  ),
                  for (final font in fonts.entries)
                    DropdownMenuItem(
                      value: font.key,
                      child: Text(
                        "${font.key} (${font.value})",
                        overflow: .ellipsis,
                      ),
                    ),
                ],
                onChanged: (v) {
                  selectFont(v!);
                },
              ),

              Text(
                'Lemur ipsum dolor sit amet.',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
              ),
              Text(
                'Lemur ipsum dolor sit amet.',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
              Text(
                'Lemur ipsum dolor sit amet.',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              Text(
                'Lemur ipsum dolor sit amet.',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),

              Text(
                '秋水共十长天一色，落霞与孤鹜齐飞',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
              ),
              Text(
                '秋水共十长天一色，落霞与孤鹜齐飞',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
              Text(
                '秋水共十长天一色，落霞与孤鹜齐飞',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              Text(
                '秋水共十长天一色，落霞与孤鹜齐飞',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
