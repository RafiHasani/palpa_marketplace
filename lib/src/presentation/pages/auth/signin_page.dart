import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/configs/theme_data.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/constants/test_keys.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/presentation/pages/auth/register_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/common/privacy_policy_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/common/terms_condition_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_home_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/home_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/auth_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_elevated_button.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_outline_button.dart';
import 'package:palpa_marketplace/src/presentation/widgets/dismiss_keyboard_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const String path = '/loginpage';
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends ConsumerState<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (pre, next) {
      if (next.authState == .loginSuccess) {
        if (next.user?.isProducer ?? false) {
          navigateToProducerPage();
        } else if (!(next.user?.isProducer ?? false)) {
          navigateToHomePage();
        }
      }

      if (next.authState == .loginFailed) {
        showSnack(msg: next.errorMessage?.error);
      }
    });
    final theme = ref.read(appThemeDataProvider);
    final state = ref.watch(authProvider);
    return DismissKeyboardWidget(
      child: LoadingWidget(
        isLoading: (state.authState == .loggingin),
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: .symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: .max,
                    spacing: 24.h,
                    crossAxisAlignment: .start,
                    mainAxisAlignment: .center,
                    children: [
                      Center(
                        child: Padding(
                          padding: .symmetric(vertical: 0.1.sh),
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 110.h,
                            width: 106.w,
                          ),
                        ),
                      ),
                      Text(
                        context.local.signin_info,
                        textAlign: .start,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),

                      Column(
                        spacing: 8.h,
                        children: [
                          TextFormField(
                            key: Key(TestKeys.usernamefield),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            controller: usernameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return context.local.enterusername;
                              }
                              return null;
                            },
                            maxLength: 10,
                            decoration:
                                InputDecoration(
                                  hintText: context.local.username,
                                  hintStyle: theme.textTheme.bodyMedium,
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

                          TextFormField(
                            key: Key(TestKeys.passwordfield),
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return context.local.enterpassword;
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration:
                                InputDecoration(
                                  hintText: context.local.password,
                                  hintStyle: theme.textTheme.bodyMedium,
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
                              key: Key(TestKeys.loginButton),
                              isDisabled: (state.authState == .loggingin),
                              title: context.local.login,
                              onPressed: () async {
                                final isValid =
                                    _formKey.currentState?.validate() ?? false;
                                if (isValid) {
                                  final auth = ref.read(authProvider.notifier);

                                  final username = usernameController.text
                                      .trim();

                                  final password = passwordController.text
                                      .trim();

                                  await auth.loginWithUsernamePassword(
                                    username,
                                    password,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: CustomOutlineButton(
                              title: context.local.signup,
                              titleColor: AppColors.primaryColor,

                              onPressed: () async {
                                context.push(RegisterPage.path);
                              },
                            ),
                          ),
                        ],
                      ),

                      // Row(
                      //   children: [
                      //     Expanded(child: Divider()),
                      //     Padding(
                      //       padding: .symmetric(horizontal: 8.w),
                      //       child: Text('یا'),
                      //     ),
                      //     Expanded(child: Divider()),
                      //   ],
                      // ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: OutlinedButton.icon(
                      //         onPressed: () {},
                      //         label: Text(
                      //           'با حساب کاربری گوگل تان وارید شوید',
                      //           style: theme.textTheme.bodyMedium,
                      //         ),
                      //         icon: SvgIcon(
                      //           assetName: 'assets/icons/google_logo.svg',
                      //         ),
                      //         style: OutlinedButton.styleFrom(
                      //           side: BorderSide(color: AppColors.primaryColor),
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: .circular(10.r),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
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

  void navigateToHomePage() {
    context.go(HomePage.path);
  }

  void navigateToProducerPage() {
    context.go(ProducerHomePage.path);
  }

  void showSnack({String? msg}) {
    context.showMySnackBar(content: msg ?? context.local.somethingwentwrong);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
