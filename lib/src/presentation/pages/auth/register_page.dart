import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/configs/theme_data.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/constants/contants.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/presentation/pages/auth/user_account_complete_form_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/common/privacy_policy_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/common/terms_condition_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/auth_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_elevated_button.dart';
import 'package:palpa_marketplace/src/presentation/widgets/dismiss_keyboard_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';

class RegisterPage extends ConsumerStatefulWidget {
  static const String path = '/registerpage';
  const RegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPage();
}

class _RegisterPage extends ConsumerState<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController userNamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();

  //0718901234

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (pre, next) {
      if (next.authState == .registerSuccess) {
        navigatorToVerifyOtppage();
      }

      if (next.authState == .registerFailed) {
        showSnack(msg: next.errorMessage?.error);
      }
    });
    final theme = ref.read(appThemeDataProvider);
    final state = ref.watch(authProvider);
    return DismissKeyboardWidget(
      child: LoadingWidget(
        isLoading: (state.authState == .registering),
        child: Scaffold(
          appBar: AppbarPageWidget(hideSearch: true),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: .symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: .max,
                    spacing: 24.h,
                    crossAxisAlignment: .center,
                    mainAxisAlignment: .center,
                    children: [
                      Padding(
                        padding: .symmetric(vertical: 0.05.sh),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 110.h,
                          width: 106.w,
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            spacing: 4.w,
                            children: [
                              Text(
                                context.local.name,
                                style: theme.textTheme.bodyMedium,
                              ),
                              Text(
                                '*',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          TextFormField(
                            controller: nameController,
                            validator: (value) {
                              String str = value ?? '';
                              if (str.length < 4) {
                                return context.local.name_length_error;
                              } else if (str.length > 50) {
                                return context.local.name_max_length_error;
                              } else {
                                return null;
                              }
                            },
                            decoration:
                                InputDecoration(
                                  hintText: context.local.enternamehint,
                                ).copyWith(
                                  focusedBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .focusedBorder,
                                  errorBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .errorBorder,
                                  border: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .border,
                                  focusedErrorBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .focusedErrorBorder,
                                  enabledBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .enabledBorder,
                                ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            spacing: 4.w,
                            children: [
                              Text(
                                context.local.lastname,
                                style: theme.textTheme.bodyMedium,
                              ),
                              Text(
                                '*',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          TextFormField(
                            controller: lastnameController,
                            validator: (value) {
                              String str = value ?? '';
                              if (str.length < 4) {
                                return context.local.lastname_length_error;
                              } else if (str.length > 20) {
                                return context.local.lastname_max_length_error;
                              } else {
                                return null;
                              }
                            },
                            decoration:
                                InputDecoration(
                                  hintText: context.local.enter_lastname,
                                ).copyWith(
                                  focusedBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .focusedBorder,
                                  errorBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .errorBorder,
                                  border: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .border,
                                  focusedErrorBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .focusedErrorBorder,
                                  enabledBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .enabledBorder,
                                ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            spacing: 4.w,
                            children: [
                              Text(
                                context.local.username,
                                style: theme.textTheme.bodyMedium,
                              ),
                              Text(
                                '*',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          TextFormField(
                            maxLength: Constants.usernameLengthLimit,
                            controller: userNamecontroller,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],

                            validator: (value) {
                              final RegExp usernameRegex = RegExp(
                                r'^[a-zA-Z0-9._-]+$',
                              );
                              String str = value ?? '';
                              if (str.length < 5) {
                                return context.local.username_length_error;
                              } else if (str.isEmpty) {
                                return context.local.username_required;
                              } else if (str.isNotEmpty &&
                                  !usernameRegex.hasMatch(str)) {
                                return context.local.user_input_guide;
                              } else {
                                return null;
                              }
                            },
                            decoration:
                                InputDecoration(
                                  hintText: context.local.enter_username_hint,
                                  counterText: '',
                                ).copyWith(
                                  focusedBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .focusedBorder,
                                  errorBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .errorBorder,
                                  border: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .border,
                                  focusedErrorBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .focusedErrorBorder,
                                  enabledBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .enabledBorder,
                                ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            spacing: 4.w,
                            children: [
                              Text(
                                context.local.password,
                                style: theme.textTheme.bodyMedium,
                              ),
                              Text(
                                '*',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          TextFormField(
                            obscureText: true,
                            controller: passwordcontroller,
                            maxLength: Constants.passwordLengthLimit,
                            validator: (value) {
                              String str = value ?? '';
                              if (str.length < 8) {
                                return context.local.password_length_error;
                              } else if (str.isEmpty) {
                                return context.local.password_required;
                              }
                              return null;
                            },
                            decoration:
                                InputDecoration(
                                  hintText: context.local.enter_password_hint,
                                  counterText: '',
                                ).copyWith(
                                  focusedBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .focusedBorder,
                                  errorBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .errorBorder,
                                  border: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .border,
                                  focusedErrorBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .focusedErrorBorder,
                                  enabledBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .enabledBorder,
                                ),
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          Row(
                            spacing: 4.w,
                            children: [
                              Text(
                                context.local.confirmpassword,
                                style: theme.textTheme.bodyMedium,
                              ),
                              Text(
                                '*',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          TextFormField(
                            obscureText: true,
                            controller: passwordConfirmationController,
                            maxLength: Constants.passwordLengthLimit,
                            validator: (value) {
                              String confirmpass = value ?? '';
                              final password = passwordcontroller.text;

                              if (confirmpass != password) {
                                return context.local.confirm_password_mismatch;
                              }
                              return null;
                            },
                            decoration:
                                InputDecoration(
                                  hintText: context.local.confirm_password_hint,
                                  counterText: '',
                                ).copyWith(
                                  focusedBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .focusedBorder,
                                  errorBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .errorBorder,
                                  border: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .border,
                                  focusedErrorBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .focusedErrorBorder,
                                  enabledBorder: AppTheme
                                      .inputTextFeildThemeLightRadiu10
                                      .enabledBorder,
                                ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              isDisabled: (state.authState == .gettingOtp),
                              title: context.local.signup,
                              onPressed: () async {
                                final isValid =
                                    _formKey.currentState?.validate() ?? false;
                                if (isValid) {
                                  final auth = ref.read(authProvider.notifier);

                                  final name = nameController.text.trim();
                                  final lastname = lastnameController.text
                                      .trim();
                                  final username = userNamecontroller.text
                                      .trim();
                                  final password = passwordcontroller.text
                                      .trim();

                                  final passwordConfirmation =
                                      passwordConfirmationController.text
                                          .trim();

                                  await auth.register(
                                    name: name,
                                    lastname: lastname,
                                    username: username,
                                    password: password,
                                    passwordConfirmation: passwordConfirmation,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: .symmetric(horizontal: 24.w),
              child: Column(
                mainAxisSize: .min,
                children: [
                  Text.rich(
                    TextSpan(
                      text: context.local.bysignintokaraniz,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textFieldHint2Color,
                      ),
                      children: [
                        TextSpan(
                          text: context.local.termsconditions,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.push(TermsConditionPage.path);
                            },
                        ),
                        TextSpan(
                          text: context.local.usingkaranizand,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textFieldHint2Color,
                          ),
                        ),
                        TextSpan(
                          text: context.local.privacypolicy,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.push(PrivacyPolicyPage.path);
                            },
                        ),
                        TextSpan(
                          text: context.local.youacceptit,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textFieldHint2Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  32.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigatorToVerifyOtppage() {
    context.push(UserAccountCompleteFormPage.path);
  }

  void showSnack({String? msg}) {
    context.showMySnackBar(content: msg ?? context.local.somethingwentwrong);
  }

  @override
  void dispose() {
    nameController.dispose();
    lastnameController.dispose();
    userNamecontroller.dispose();
    passwordcontroller.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }
}
