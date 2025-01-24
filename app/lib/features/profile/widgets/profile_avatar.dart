import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoURL;
  final double radius;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.photoURL,
    this.radius = 40,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            backgroundImage: photoURL != null ? NetworkImage(photoURL!) : null,
            child: photoURL == null
                ? Icon(
                    Icons.person,
                    size: radius,
                    color: theme.colorScheme.primary,
                  )
                : null,
          ),
          if (onTap != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: radius * 0.4,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
