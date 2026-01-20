import 'package:align/app/auth/auth_controller.dart';
import 'package:align/app/profile/profile_controller.dart';
import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:align/domain/profile/emoji_catalog.dart';
import 'package:align/ui/auth/signup_flow/widgets/emoji_picker.dart';
import 'package:align/ui/shared/bottom_nav_bar.dart';
import 'package:align/ui/shared/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: AppSpacing.paddingXL,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Paramètres',
                            style: AppTextStyles.headlineLarge,
                          ),
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .signOut();
                            },
                            child: Text(
                              'Déconnexion',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),

                      AppSpacing.verticalMassive,

                      const _ProfileSection(),

                      AppSpacing.verticalMassive,

                      _SettingsSection(
                        title: 'Informations',
                        children: [
                          _SettingsTile(
                            icon: Icons.privacy_tip_rounded,
                            title: 'Politique de confidentialité',
                            onTap: () =>
                                _launchUrl('https://www.lipsum.com/privacy'),
                          ),
                          _SettingsTile(
                            icon: Icons.description_rounded,
                            title: 'Conditions d\'utilisation',
                            onTap: () =>
                                _launchUrl('https://www.lipsum.com/terms'),
                          ),
                          _SettingsTile(
                            icon: Icons.info_rounded,
                            title: 'Version',
                            trailing: Text(
                              '1.0.0',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            onTap: null,
                          ),
                        ],
                      ),

                      AppSpacing.verticalGiant,
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Navigation
            const BottomNavBar(currentRoute: '/settings'),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

// Section Profil avec avatar et bouton modifier
class _ProfileSection extends ConsumerWidget {
  const _ProfileSection();

  void _showEditProfileBottomSheet(
    BuildContext context,
    WidgetRef ref,
    String currentName,
    int currentEmojiIndex,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditProfileBottomSheet(
        currentName: currentName,
        currentEmojiIndex: currentEmojiIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayName = ref.watch(
      profileControllerProvider.select(
        (s) => s.profile?.displayName ?? 'Utilisateur',
      ),
    );
    final emojiIndex = ref.watch(
      profileControllerProvider.select((s) => s.profile?.emojiIndex ?? 0),
    );
    return Container(
      padding: AppSpacing.paddingXXL,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppBorderRadius.radiusXL,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.purple.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.purple, width: 3),
            ),
            child: Center(
              child: Text(
                emojiCatalog[emojiIndex],
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),

          AppSpacing.verticalLG,

          // Nom
          Text(
            displayName,
            style: AppTextStyles.headlineSmall,
            textAlign: TextAlign.center,
          ),

          AppSpacing.verticalXL,

          // Bouton modifier
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showEditProfileBottomSheet(
                context,
                ref,
                displayName,
                emojiIndex,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.radiusMD,
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: Text(
                'Modifier le profil',
                style: AppTextStyles.labelSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Column(spacing: 10, children: children),
      ],
    );
  }
}

// Élément de paramètre cliquable
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: AppBorderRadius.radiusMD,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppBorderRadius.radiusMD,
        child: Padding(
          padding: AppSpacing.paddingLG,
          child: Row(
            children: [
              Container(
                padding: AppSpacing.paddingSM,
                decoration: BoxDecoration(
                  color: AppColors.greenLight.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: AppColors.greenDark),
              ),
              AppSpacing.horizontalLG,
              Expanded(child: Text(title, style: AppTextStyles.bodyMedium)),
              if (trailing != null)
                trailing!
              else if (onTap != null)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditProfileBottomSheet extends ConsumerStatefulWidget {
  const _EditProfileBottomSheet({
    required this.currentName,
    required this.currentEmojiIndex,
  });

  final String currentName;
  final int currentEmojiIndex;

  @override
  ConsumerState<_EditProfileBottomSheet> createState() =>
      _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState
    extends ConsumerState<_EditProfileBottomSheet> {
  late TextEditingController _nameController;
  late int _selectedEmojiIndex;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _selectedEmojiIndex = widget.currentEmojiIndex;
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingXXL,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Modifier le profil', style: AppTextStyles.titleLarge),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),

                AppSpacing.verticalXXL,

                Text(
                  'Nom d\'affichage',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSpacing.verticalSM,
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Entrez votre nom',
                  validator: (value) {
                    final v = (value ?? '').trim();
                    if (v.isEmpty) {
                      return 'Veuillez entrer un nom';
                    }

                    if (v.length < 3) {
                      return 'Le nom doit contenir au moins 3 caractères';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _saveProfile(),
                ),

                AppSpacing.verticalXXL,

                Text(
                  'Choisissez un avatar',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSpacing.verticalMD,

                SizedBox(
                  height: 250,
                  child: SingleChildScrollView(
                    child: EmojiPicker(
                      selectedIndex: _selectedEmojiIndex,
                      onSelected: (index) {
                        setState(() {
                          _selectedEmojiIndex = index;
                        });
                      },
                    ),
                  ),
                ),

                AppSpacing.verticalXXL,

                // Bouton Enregistrer
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenDark,
                      foregroundColor: Colors.white,
                      padding: AppSpacing.paddingVerticalLG,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppBorderRadius.radiusMD,
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Enregistrer',
                      style: AppTextStyles.labelMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final newName = _nameController.text.trim();

    await ref
        .read(profileControllerProvider.notifier)
        .updateProfile(displayName: newName, emojiIndex: _selectedEmojiIndex);

    if (!mounted) return;
    context.pop();
  }
}
