import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    this.icon,
    required this.title,
    this.buttonColor,
    this.titleTextStyle,
    required this.onTap,
    required this.isLoading,
    this.loadingIndicatorColor,
    this.height,
    this.width,
    this.enable = true,
  });
  final Widget? icon;
  final double? height;
  final double? width;

  final String title;
  final Color? buttonColor;
  final TextStyle? titleTextStyle;
  final bool? isLoading;
  final bool enable;
  final Color? loadingIndicatorColor;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        enable ? onTap() : null;
      },
      child: Container(
        height: height ?? 50.h,
        width: width ?? 250.w,
        decoration: BoxDecoration(
          color: buttonColor ?? Theme.of(context).colorScheme.error,
          border: Border.all(
            color: buttonColor ?? Theme.of(context).colorScheme.error,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child:
            isLoading == true
                ? Center(
                  child: CircularProgressIndicator(
                    color:
                        loadingIndicatorColor ??
                        Theme.of(context).colorScheme.primary,
                  ),
                )
                : Row(
                  mainAxisAlignment:
                      icon != null
                          ? MainAxisAlignment.spaceEvenly
                          : MainAxisAlignment.center,
                  children: [
                    if (icon != null)
                      SizedBox(
                        width: width != null ? width! / 4.5 : 50.w,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: icon,
                        ),
                      ),
                    Text(
                      title,
                      style:
                          titleTextStyle ??
                          Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (icon != null) const SizedBox(width: 20),
                  ],
                ),
      ),
    );
  }
}
