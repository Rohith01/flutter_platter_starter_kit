import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LogoHeader extends StatelessWidget {
  const LogoHeader({super.key, this.showBackButton = true});
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            if (showBackButton)
              IconButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ))
            else
              const SizedBox(
                height: 50,
              )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 70.h, bottom: 80.h),
          child: Text(
            'Flutter-Platter',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
