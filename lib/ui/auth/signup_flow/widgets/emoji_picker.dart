import 'package:align/app/theme.dart';
import 'package:align/domain/profile/emoji_catalog.dart';
import 'package:flutter/material.dart';

class EmojiPicker extends StatelessWidget {
  const EmojiPicker({
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final int? selectedIndex;
  final void Function(int index) onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: emojiCatalog.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final isSelected = selectedIndex == index;
        return InkWell(
          onTap: () => onSelected(index),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.purple.withAlpha(60) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: isSelected ? 2.5 : 1,
                color: isSelected ? AppColors.purple : AppColors.textMuted,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              emojiCatalog[index],
              style: const TextStyle(fontSize: 22),
            ),
          ),
        );
      },
    );
  }
}
