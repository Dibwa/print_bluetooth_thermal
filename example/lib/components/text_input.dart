import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String textHint;
  final bool secure;
  final bool autofocus;
  final TextEditingController inputs;
  final Icon prefixIcon;
  final TextInputType keyboarType;
  final Function(String value) onchanged;
  const InputField(
      {super.key,
      required this.textHint,
      required this.secure,
      required this.autofocus,
      required this.inputs,
      required this.prefixIcon,
      required this.keyboarType,
      required this.onchanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      child: TextField(
          onChanged: onchanged,
          autofocus: autofocus,
          keyboardType: keyboarType,
          controller: inputs,
          cursorColor: Colors.black,
          obscureText: secure,
          decoration: InputDecoration(
              prefixIcon: prefixIcon,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.green)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.7))),
              hintText: textHint,
              fillColor: Colors.grey.shade100,
              filled: true)),
    );
  }
}
