import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? iconData;
  final Widget? leadingIcon;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final bool readOnly;
  final Color? borderColor;
  final TextEditingController? controller;
  final Function()? onTap;
  final String? hintText;
  final void Function(String value)? onChanged;
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool obscureText;
  final FocusNode? focusNode;
  final int? maxLength;
  final int? maxLines;
  final String? counterText;
  final double? fontSize;
  final Widget? prefixIcon;
  final TextInputType? keyBoardType;
  final bool? enabled;
  final void Function(String)? onFieldSubmitted;
  final EdgeInsetsGeometry contentPadding;
  final String obscuringCharacter;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;

  const AppTextField({
    super.key,
    this.labelText,
    this.width = 1,
    this.iconData,
    this.controller,
    this.onTap,
    this.readOnly = false,
    this.height,
    this.hintText,
    this.onChanged,
    this.prefixIcon,
    this.leadingIcon,
    this.initialValue,
    this.style = const TextStyle(),
    this.validator,
    this.fontSize = 14,
    this.obscureText = false,
    this.focusNode,
    this.keyBoardType,
    this.enabled = true,
    this.textAlign = TextAlign.start,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.borderColor,
    this.labelStyle,
    this.maxLength,
    this.counterText,
    this.obscuringCharacter = '•',
    this.textCapitalization = TextCapitalization.words,
    this.contentPadding =
    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height,
      child: TextFormField(
        onFieldSubmitted: onFieldSubmitted,
        textCapitalization: textCapitalization,
        enabled: enabled,
        focusNode: focusNode,
        initialValue: initialValue,
        validator: validator,
        onChanged: onChanged,
        readOnly: readOnly,
        obscureText: obscureText,
        onTap: onTap,
        textAlign: textAlign,
        keyboardType: keyBoardType,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLength: maxLength,
        maxLines: maxLines,
        enableSuggestions: true,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
        ),
        obscuringCharacter: obscuringCharacter,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          counterText: '',
          prefix: leadingIcon,
          filled: readOnly,
          hintText: hintText,
          suffixIcon: iconData,
          labelText: labelText == '' ? null : labelText,
          contentPadding: contentPadding,
          alignLabelWithHint: true,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: borderColor ?? Colors.grey, // Default underline color
              width: 1.0,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: borderColor ?? Colors.grey, // Default underline color
              width: 1.0,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: borderColor ?? Theme.of(context).primaryColor, // Highlight color
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
