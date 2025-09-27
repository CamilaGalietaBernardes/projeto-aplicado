import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/presentation/theme/app_colors.dart';

class TextFormBase extends StatefulWidget {
  final bool obscure;
  final Widget? suffix;
  final bool? enabled;
  final String placeholder;
  final String? errorMessage;
  final double? paddingTop;
  final double? paddingRight;
  final double? paddingBottom;
  final int? maxline;
  final Color? textinput;
  final Color? colorform;
  final double? paddingLeft;
  final VoidCallback? onTap;
  final TextInputAction? action;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? keyboardType;
  final int? maxLength;
  final void Function(String)? onChanged;
  final bool readOnly;
  final AutovalidateMode? autovalidateMode;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final double fontSize;
  final double? contentPaddingVertical;

  const TextFormBase({
    super.key,
    required this.obscure,
    required this.placeholder,
    this.contentPaddingVertical,
    this.paddingTop,
    this.enabled,
    this.paddingRight,
    this.paddingBottom,
    this.paddingLeft,
    this.onTap,
    this.action,
    this.errorMessage,
    this.inputFormatter,
    this.keyboardType,
    this.maxLength,
    this.suffix,
    this.onChanged,
    this.textinput,
    this.readOnly = false,
    this.autovalidateMode,
    this.controller,
    this.colorform,
    this.maxline = 1,
    this.focusNode,
    this.fontSize = 13,
  });

  @override
  State<TextFormBase> createState() => _TextFormBaseState();
}

class _TextFormBaseState extends State<TextFormBase> {
  late final FocusNode _internalFocusNode;
  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode;
  bool _hasFocus = false;

  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode();
    _effectiveFocusNode.addListener(() {
      setState(() => _hasFocus = _effectiveFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        widget.colorform ??
        (!isDarkMode ? AppColors.accentWhite : AppColors.black);
    final textColor =
        widget.textinput ??
        (!isDarkMode ? AppColors.accentWhite : AppColors.black);
    final hintColor = !isDarkMode
        ? AppColors.lightGray
        : AppColors.black.withAlpha(200);

    return Padding(
      padding: EdgeInsets.only(
        top: widget.paddingTop ?? 10,
        right: widget.paddingRight ?? 0,
        bottom: widget.paddingBottom ?? 0,
        left: widget.paddingLeft ?? 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _hasFocus ? AppColors.lightGray : AppColors.black,
                width: 0.7,
              ),
            ),
            child: TextFormField(
              enabled: widget.enabled,
              focusNode: _effectiveFocusNode,
              maxLines: widget.maxline,
              onTap: widget.onTap,
              controller: widget.controller,
              onChanged: widget.onChanged,
              obscureText: widget.obscure,
              maxLength: widget.maxLength,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatter,
              textInputAction: widget.action ?? TextInputAction.next,
              readOnly: widget.readOnly || widget.onTap != null,
              autovalidateMode: widget.autovalidateMode,
              style: TextStyle(color: textColor, fontSize: 15.sp),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: widget.contentPaddingVertical ?? 20,
                  horizontal: 10.w,
                ),
                hintText: widget.placeholder,
                hintStyle: TextStyle(
                  color: hintColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                counterText: '',
                border: InputBorder.none,
                suffixIcon: widget.suffix,
              ),
            ),
          ),
          if (widget.errorMessage != null)
            Padding(
              padding: EdgeInsets.only(top: 6.h, left: 6.w),
              child: Text(
                widget.errorMessage!,
                style: TextStyle(color: AppColors.errorRed, fontSize: 11.sp),
              ),
            ),
        ],
      ),
    );
  }
}
