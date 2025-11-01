import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pagination_and_theme_task/config/theme/app_style.dart';
import 'package:pagination_and_theme_task/core/constants/app_assets.dart';

class CustomDetailsAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomDetailsAppbar({super.key, required this.title, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  final List<Widget>? actions;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(children: [
         
        ],
      ),
      centerTitle: false,
      leadingWidth: 200,
      excludeHeaderSemantics: true,
      actions: actions,
      leading: Row(
        children: [
          IconButton(
            icon: SvgPicture.asset(
              AppAssets.rightArrowIcon,
              width: 16,
              height: 16,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),

          Text(title, style: AppTextStyles.medium18),
        ],
      ),
    );
  }
}
