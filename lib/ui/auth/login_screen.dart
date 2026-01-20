import 'package:align/app/auth/auth_controller.dart';
import 'package:align/app/router.dart';
import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:align/ui/shared/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authControllerProvider.notifier)
        .signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppSpacing.paddingXXL,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppSpacing.verticalMassive,

                  // Logo/Illustration
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.greenDark.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🎯', style: TextStyle(fontSize: 60)),
                      ),
                    ),
                  ),

                  AppSpacing.verticalHuge,

                  // Titre
                  Text(
                    'Bon retour !',
                    style: AppTextStyles.displaySmall,
                    textAlign: TextAlign.center,
                  ),

                  AppSpacing.verticalSM,

                  Text(
                    'Connectez-vous pour jouer',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  AppSpacing.verticalMassive,

                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Email',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  AppSpacing.verticalSM,
                  CustomTextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'jean@doe.fr',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre email';
                      }
                      if (!value.contains('@')) {
                        return 'Email invalide';
                      }
                      return null;
                    },
                  ),

                  AppSpacing.verticalXXL,

                  // Champ Mot de passe
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Mot de passe',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  AppSpacing.verticalSM,
                  CustomTextField(
                    controller: _passwordController,
                    obscureText: true,
                    hintText: '******',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      }
                      if (value.length < 6) {
                        return 'Le mot de passe doit contenir au moins 6 caractères';
                      }
                      return null;
                    },
                  ),

                  AppSpacing.verticalHuge,

                  // Message d'erreur
                  if (authState.errorMessage != null)
                    Container(
                      padding: AppSpacing.paddingLG,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: AppBorderRadius.radiusSM,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          AppSpacing.horizontalMD,
                          Expanded(
                            child: Text(
                              authState.errorMessage!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Bouton Connexion
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenDark,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.textMuted,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.radiusXXL,
                        ),
                        elevation: 0,
                      ),
                      child: authState.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Se connecter',
                              style: AppTextStyles.labelMedium,
                            ),
                    ),
                  ),

                  AppSpacing.verticalXXL,

                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: AppSpacing.paddingHorizontalLG,
                        child: Text(
                          'OU',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),

                  AppSpacing.verticalXXL,

                  // Bouton S'inscrire
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => context.go(Routes.signup),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.greenDark,
                        side: const BorderSide(
                          color: AppColors.greenDark,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.radiusXXL,
                        ),
                      ),
                      child: Text(
                        'Créer un compte',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.greenDark,
                        ),
                      ),
                    ),
                  ),

                  AppSpacing.verticalMassive,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
