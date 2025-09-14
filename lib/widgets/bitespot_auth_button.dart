import 'package:bitespot/utils/constants/size_constants.dart';
import 'package:flutter/material.dart';

class BitespotAuthButton extends StatelessWidget {
  final String imagePath;
  final double height;
  final void Function()? onTap;
  const BitespotAuthButton({
    super.key,
    required this.imagePath,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(SizeConstants.s12),
        ),

        padding: const EdgeInsets.all(SizeConstants.s24),
        child: Image.asset(imagePath, height: height),
      ),
    );
  }
}
