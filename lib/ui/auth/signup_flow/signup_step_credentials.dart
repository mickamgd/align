import 'package:align/app/auth/signup/signup_controller.dart';
import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupStepCredentials extends ConsumerStatefulWidget {
  const SignupStepCredentials({required this.formKey, super.key});
  final GlobalKey<FormState> formKey;

  @override
  ConsumerState<SignupStepCredentials> createState() =>
      _SignupStepCredentialsState();
}

class _SignupStepCredentialsState extends ConsumerState<SignupStepCredentials>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController _emailCtrl;
  late final TextEditingController _pwdCtrl;

  @override
  void initState() {
    super.initState();
    final s = ref.read(signupControllerProvider);

    _emailCtrl = TextEditingController(text: s.email);
    _pwdCtrl = TextEditingController(text: s.password);

    _emailCtrl.addListener(() {
      ref.read(signupControllerProvider.notifier).setEmail(_emailCtrl.text);
    });
    _pwdCtrl.addListener(() {
      ref.read(signupControllerProvider.notifier).setPassword(_pwdCtrl.text);
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final state = ref.watch(signupControllerProvider);

    return Form(
      key: widget.formKey,
      child: ListView(
        children: [
          Text('Vos identifiants', style: AppTextStyles.headlineSmall),
          AppSpacing.verticalXL,
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Email'),
            validator: (v) {
              final value = (v ?? '').trim();
              final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
              if (!ok) return 'Email invalide';
              return null;
            },
          ),

          AppSpacing.verticalMD,

          TextFormField(
            controller: _pwdCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Mot de passe',
              helperText: 'Minimum 6 caractères',
            ),
            validator: (v) {
              if ((v ?? '').length < 6) return 'Minimum 6 caractères';
              return null;
            },
          ),
          AppSpacing.verticalMD,
          Text(
            state.isCredentialsValid
                ? 'OK.'
                : 'Email valide + mot de passe (≥ 6).',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
