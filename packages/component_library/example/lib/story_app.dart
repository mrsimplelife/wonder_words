import 'package:component_library/component_library.dart';
import 'package:component_library_storybook/component_storybook.dart';
import 'package:flutter/material.dart';

class StoryApp extends StatelessWidget {
  final _lightTheme = LightWonderThemeData();
  final _darkTheme = DarkWonderThemeData();

  StoryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WonderTheme(
      lightTheme: _lightTheme,
      darkTheme: _darkTheme,
      child: ComponentStorybook(
        lightThemeData: _lightTheme.materialThemeData,
        darkThemeData: _darkTheme.materialThemeData,
      ),
    );
  }
}
