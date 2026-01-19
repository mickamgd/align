import 'package:align/app/auth/auth_controller.dart';
import 'package:align/app/auth/signup/signup_controller.dart';
import 'package:align/app/auth/signup/signup_state.dart';
import 'package:align/app/router.dart';
import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:align/ui/auth/signup_flow/signup_step_credentials.dart';
import 'package:align/ui/auth/signup_flow/signup_step_identity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SignupFlowScreen extends ConsumerStatefulWidget {
  const SignupFlowScreen({super.key});

  @override
  ConsumerState<SignupFlowScreen> createState() => _SignupFlowScreenState();
}

class _SignupFlowScreenState extends ConsumerState<SignupFlowScreen> {
  late final PageController _pageController;

  final _identityFormKey = GlobalKey<FormState>();
  final _credentialsFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupControllerProvider);
    final authState = ref.watch(authControllerProvider);

    // Sync page avec step
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = signupState.step.clamp(0, 1);
      if (_pageController.hasClients &&
          _pageController.page?.round() != target) {
        _pageController.animateToPage(
          target,
          duration: AppDurations.pageTransition,
          curve: Curves.easeOut,
        );
      }
    });

    final isSubmitting = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingXL,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppBorderRadius.radiusSM,
                      boxShadow: AppShadows.standard,
                    ),
                    child: IconButton(
                      icon: Icon(
                        signupState.step == 0
                            ? Icons.close
                            : Icons.arrow_back_rounded,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: signupState.step == 0
                          ? isSubmitting
                                ? null
                                : () => context.go(Routes.login)
                          : () => ref
                                .read(signupControllerProvider.notifier)
                                .previousStep(),
                    ),
                  ),
                  const Spacer(),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 2,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: AppColors.pink,
                      spacing: 5.0,
                      dotColor: AppColors.black,
                    ),
                  ),
                ],
              ),

              AppSpacing.verticalXXXL,

              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SignupStepIdentity(formKey: _identityFormKey),
                    SignupStepCredentials(formKey: _credentialsFormKey),
                  ],
                ),
              ),

              if (authState.errorMessage != null)
                Center(
                  child: Padding(
                    padding: AppSpacing.paddingVerticalXL,
                    child: Text(
                      authState.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              SizedBox(
                width: double.infinity,
                child: _PrimaryButton(
                  isLoading: isSubmitting,
                  label: signupState.step == 0
                      ? 'Continuer'
                      : 'Créer mon compte',
                  onPressed: isSubmitting
                      ? null
                      : () => _handleButtonPress(signupState),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleButtonPress(SignupState signupState) async {
    final ctrl = ref.read(signupControllerProvider.notifier);
    final s = ref.read(signupControllerProvider);

    FocusScope.of(context).unfocus();

    if (signupState.step == 0) {
      final ok = _identityFormKey.currentState?.validate() ?? false;
      if (!ok) return;
      ctrl.nextStep();
    } else {
      final ok = _credentialsFormKey.currentState?.validate() ?? false;
      if (!ok) return;
      await _submitSignup(s);
    }
  }

  Future<void> _submitSignup(SignupState signupState) async {
    await ref
        .read(authControllerProvider.notifier)
        .signUp(
          email: signupState.email.trim(),
          password: signupState.password,
          displayName: signupState.displayName.trim(),
          emojiIndex: signupState.emojiIndex!,
        );

    final authState = ref.read(authControllerProvider);
    if (authState.isAuthenticated && mounted) {
      ref.read(signupControllerProvider.notifier).reset();
      context.go(Routes.home);
    }
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: isLoading
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    );
  }
}
