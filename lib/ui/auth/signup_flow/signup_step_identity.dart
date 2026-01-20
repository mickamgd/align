import 'package:align/app/auth/signup/signup_controller.dart';
import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:align/ui/auth/signup_flow/widgets/emoji_picker.dart';
import 'package:align/ui/shared/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupStepIdentity extends ConsumerStatefulWidget {
  const SignupStepIdentity({required this.formKey, super.key});
  final GlobalKey<FormState> formKey;

  @override
  ConsumerState<SignupStepIdentity> createState() => _SignupStepIdentityState();
}

class _SignupStepIdentityState extends ConsumerState<SignupStepIdentity>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    final s = ref.read(signupControllerProvider);
    _nameCtrl = TextEditingController(text: s.displayName);

    _nameCtrl.addListener(() {
      ref
          .read(signupControllerProvider.notifier)
          .setDisplayName(_nameCtrl.text);
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final state = ref.watch(signupControllerProvider);
    final ctrl = ref.read(signupControllerProvider.notifier);

    if (_nameCtrl.text != state.displayName) {
      _nameCtrl.value = _nameCtrl.value.copyWith(
        text: state.displayName,
        selection: TextSelection.collapsed(offset: state.displayName.length),
      );
    }

    return Form(
      key: widget.formKey,
      child: ListView(
        children: [
          Text(
            'Comment vous appelez-vous ?',
            style: AppTextStyles.headlineSmall,
          ),
          AppSpacing.verticalXL,
          CustomTextField(
            controller: _nameCtrl,
            hintText: 'Nom',
            validator: (v) {
              final value = (v ?? '').trim();
              if (value.length < 3) return 'Minimum 3 caractères';
              return null;
            },
          ),

          AppSpacing.verticalXL,
          // avatar
          EmojiPicker(
            selectedIndex: state.emojiIndex,
            onSelected: ctrl.setEmojiIndex,
          ),
          AppSpacing.verticalMD,
          Text(
            state.isIdentityValid ? 'Parfait.' : 'Nom (≥ 3) + avatar requis.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
