import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hancord_test/core/utils/colors.dart';
import 'package:hancord_test/core/utils/svgs.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navItem(index: 0, iconPath: Svgs.home, label: "Home"),
          _navItem(index: 1, iconPath: Svgs.booking, label: "Bookings"),
          _navItem(index: 2, iconPath: Svgs.group, label: "Account"),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required String iconPath,
    required String label,
  }) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 22,
              height: 22,
              color: isSelected ? PColors.color4FB15E : PColors.colorB3B3B3,
            ),
            if (isSelected) ...[
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

