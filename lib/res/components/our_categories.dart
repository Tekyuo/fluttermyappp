import 'package:flutter/material.dart';
class CustomTextFieldCategory extends StatelessWidget {
  final String hint;
  final TextEditingController textController;
  final List<String> suggestions;
  final Function() onFieldSubmitted;

  CustomTextFieldCategory({required this.hint, required this.textController, required this.suggestions, required this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return suggestions.where((word) => word.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: (String value) {
        textController.text = value;
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hint,
          ),
          onSubmitted: (value) {
            onFieldSubmitted();
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Material(
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options.elementAt(index);
              return ListTile(
                title: Text(option),
                onTap: () {
                  onSelected(option);
                },
              );
            },
          ),
        );
      },
    );
  }
}