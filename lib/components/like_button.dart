import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  void Function()? onTap;

  LikeButton({super.key, required this.onTap, required this.isLiked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isLiked
          ? Icon(
              Icons.favorite,
              color: Colors.red,
            )
          : Icon(
              Icons.favorite_outline,
              color: Colors.grey,
            ),
    );
  }
}
