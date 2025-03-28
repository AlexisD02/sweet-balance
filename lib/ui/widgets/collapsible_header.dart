import 'package:flutter/material.dart';

class CollapsibleHeader extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool isEditMode;

  const CollapsibleHeader({
    super.key,
    required this.title,
    this.actions,
    this.onBackPressed,
    this.isEditMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.grey[200],
      pinned: true,
      floating: false,
      expandedHeight: 300.0,
      elevation: 0,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double collapseRatioBT = ((constraints.maxHeight - kToolbarHeight - 100) /
              (250.0 - kToolbarHeight))
              .clamp(0.0, 1.0);

          double collapseRatioST = ((constraints.maxHeight - kToolbarHeight) /
              (200.0 - kToolbarHeight))
              .clamp(0.0, 1.0);

          return Stack(
            children: [
              Opacity(
                opacity: collapseRatioBT,
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 30.0,
                      color: Colors.black.withOpacity(collapseRatioBT),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: isEditMode ? 60.0 : 25.0,
                bottom: 12.0,
                child: Opacity(
                  opacity: 1.0 - collapseRatioST,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              if (isEditMode)
                Positioned(
                  left: 20.0,
                  bottom: 15.0,
                  child: GestureDetector(
                    onTap: onBackPressed,
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                    ),
                  ),
                ),
              Positioned(
                right: isEditMode ? 18.0 : 10.0,
                bottom: isEditMode ? 8.0 : 3.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions ??
                      [],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
