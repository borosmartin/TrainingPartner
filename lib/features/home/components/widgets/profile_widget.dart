import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/resources/firebase/auth_service.dart';
import 'package:training_partner/core/resources/widgets/shimmer_container.dart';
import 'package:training_partner/features/settings/components/pages/settings_page.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';

class ProfileWidget extends StatelessWidget {
  final User user;
  final AppSettings settings;

  const ProfileWidget({super.key, required this.user, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ClipOval(
                child: (user.photoURL == null)
                    ? Image.asset(
                        'assets/images/default_profile_picture.jpg',
                        height: 70,
                        width: 70,
                      )
                    : CachedNetworkImage(
                        imageUrl: user.photoURL!,
                        height: 60,
                        width: 60,
                        placeholder: (context, url) => const ShimmerContainer(height: 70, width: 70),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back,', style: CustomTextStyle.bodyPrimary(context)),
                Text(user.displayName ?? '', style: CustomTextStyle.subtitlePrimary(context)),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage(settings: settings))),
              icon: const PhosphorIcon(
                PhosphorIconsBold.gear,
                size: 25,
              ),
            ),
            const SizedBox(width: 15),
            IconButton(
              onPressed: _signOut,
              icon: const PhosphorIcon(
                PhosphorIconsBold.signOut,
                size: 25,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _signOut() async {
    await AuthService().signOut();
  }
}
