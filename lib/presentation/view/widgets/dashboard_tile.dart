import 'package:flutter/material.dart';

class DashBoardTile extends StatelessWidget {
  const DashBoardTile({
    super.key,
    required this.leadingWidget,
    this.title,
    required this.onTap,
  });
  final Widget? leadingWidget;
  final String? title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 150,
        width: 150,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.tertiary.withAlpha(100),
              Theme.of(context).colorScheme.tertiary,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            leadingWidget ?? const SizedBox(),
            const SizedBox(height: 20),
            if (title != null)
              Text(title!, style: Theme.of(context).textTheme.bodyLarge)
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }
}
