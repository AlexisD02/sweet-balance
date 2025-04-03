import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final String placeholder;
  final Function(String) onChanged;
  final VoidCallback onOpenFilter;

  const SearchField({
    super.key,
    required this.placeholder,
    required this.onChanged,
    required this.onOpenFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: placeholder,
            prefixIcon: const Icon(Icons.search),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(12, 14, 48, 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.black26),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.black26),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
        Positioned(
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.black),
            onPressed: onOpenFilter,
          ),
        ),
      ],
    );
  }
}
