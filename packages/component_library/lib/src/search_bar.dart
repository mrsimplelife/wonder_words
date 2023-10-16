import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const MySearchBar({this.controller, this.onChanged, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = ComponentLibraryLocalizations.of(context);
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.search),
        hintText: l10n.searchBarHintText,
        labelText: l10n.searchBarLabelText,
      ),
      onChanged: onChanged,
    );
  }
}
