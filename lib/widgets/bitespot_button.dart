import 'package:bitespot/utils/constants/size_constants.dart';
import 'package:flutter/material.dart';

class BitespotButton extends StatelessWidget {
  final Function()? onTap;
  final bool isLoading;
  final String text;
  const BitespotButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(SizeConstants.s24),
        margin: const EdgeInsets.symmetric(horizontal: SizeConstants.s24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(SizeConstants.s12),
        ),
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surfaceBright,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConstants.s16,
                ),
              ),
      ),
    );
  }
}
