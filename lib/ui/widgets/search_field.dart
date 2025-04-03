import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class SearchField extends StatelessWidget {
  final String placeholder;
  final Function(String) onChanged;
  final Function(SortOption) onSortChanged;

  const SearchField({
    super.key,
    required this.placeholder,
    required this.onChanged,
    required this.onSortChanged,
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
            // Increased right padding to avoid icon overlap
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
          child: PopupMenuButton<SortOption>(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortOption.POPULARITY,
                child: Text("Popularity"),
              ),
              const PopupMenuItem(
                value: SortOption.PRODUCT_NAME,
                child: Text("Alphabetical"),
              ),
              const PopupMenuItem(
                value: SortOption.CREATED,
                child: Text("Newest First"),
              ),
            ],
            onSelected: onSortChanged,
          ),
        ),
      ],
    );
  }
}
