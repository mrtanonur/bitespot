import 'package:bitespot/utils/constants/size_constants.dart';
import 'package:flutter/material.dart';

class BitespotTextFormfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;

  const BitespotTextFormfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.validator,
  });

  @override
  State<BitespotTextFormfield> createState() => _BitespotTextFormfieldState();
}

class _BitespotTextFormfieldState extends State<BitespotTextFormfield> {
  bool shownPassword = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SizeConstants.s24),
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        validator: widget.validator,
        controller: widget.controller,
        obscureText: shownPassword ? false : widget.obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          suffixIcon: widget.obscureText
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      shownPassword = !shownPassword;
                    });
                  },
                  icon: Icon(
                    shownPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
