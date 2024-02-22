import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/firebase/auth_service.dart';
import 'package:training_partner/core/resources/widgets/custom_small_button.dart';
import 'package:training_partner/core/resources/widgets/shimmer_container.dart';

class ProfileWidget extends StatelessWidget {
  final User user;
  const ProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: (user.photoURL == null)
                  ? Image.asset(
                      'assets/images/default_profile_picture.jpg',
                      height: 100,
                      width: 100,
                    )
                  : CachedNetworkImage(
                      imageUrl: user.photoURL!,
                      placeholder: (context, url) => const ShimmerContainer(height: 100, width: 100),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
            ),
            const Spacer(),
            CustomSmallButton(
              label: 'Settings',
              icon: const Icon(Icons.settings_rounded, color: Colors.black38),
              onTap: () {},
            ),
            const SizedBox(width: 10),
            CustomSmallButton(
              label: 'Logout',
              icon: const Icon(Iconsax.logout5, color: Colors.black38),
              onTap: _signOut,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.person, size: 20),
            const SizedBox(width: 10),
            Text(user.displayName ?? '', style: boldNormalBlack),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.email, size: 20),
            const SizedBox(width: 10),
            Text(user.email!, style: normalGrey),
          ],
        ),
      ],
    );
  }

  Future<void> _signOut() async {
    await AuthService().signOut();
  }
}
