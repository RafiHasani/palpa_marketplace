import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/configs/theme_data.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_home_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/home_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/auth_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_elevated_button.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  static const String path = '/changepasswordpage';
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController currentPasswordControler = TextEditingController();
  TextEditingController newPasswordControler = TextEditingController();
  TextEditingController confirmPasswordControler = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (pre, next) {
      if (next.authState == .updatingPasswordSuccess) {
        if (next.user?.isProducer ?? false) {
          navigateToProducerDashboard();
        } else {
          navigateToHome();
        }
      } else if (next.authState == .updatingPasswordFailed) {
        showSnackbar(msg: next.errorMessage?.error);
      }
    });

    final theme = ref.read(appThemeDataProvider);
    final authStat = ref.watch(authProvider);

    return LoadingWidget(
      isLoading: (authStat.authState == .updatingPassword),
      child: Scaffold(
        appBar: AppbarPageWidget(
          hideSearch: true,
          title: context.local.edit_user_password,
          titleOnly: false,
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: .all(24.w),
              child: Column(
                mainAxisSize: .min,
                mainAxisAlignment: .start,
                crossAxisAlignment: .start,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      spacing: 24.h,
                      children: [
                        Column(
                          children: [
                            Row(
                              spacing: 4.w,
                              children: [
                                Text(
                                  context.local.current_password,
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
                              controller: currentPasswordControler,
                              validator: (value) {
                                String str = value ?? '';
                                if (str.isEmpty) {
                                  return context.local.password_required;
                                } else {
                                  return null;
                                }
                              },
                              decoration:
                                  InputDecoration(
                                    hintText:
                                        context.local.confirm_password_hint,
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
                                  context.local.new_password,
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
                              controller: newPasswordControler,
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
                                    hintText: context.local.enter_password_hint,
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
                              controller: confirmPasswordControler,
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
                                    hintText:
                                        context.local.confirm_password_hint,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: .min,
            children: [
              Padding(
                padding: .all(24.w),
                child: Row(
                  mainAxisSize: .max,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        isDisabled: authStat.authState == .loadingProfile,
                        title: context.local.confirm,
                        onPressed: () async {
                          final isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (isValid) {
                            if (isValid) {
                              final provider = ref.read(authProvider.notifier);

                              final body = {
                                "current_password": currentPasswordControler
                                    .text
                                    .trim(),
                                "new_password": newPasswordControler.text
                                    .trim(),
                                "new_password_confirmation":
                                    confirmPasswordControler.text.trim(),
                              };

                              await provider.changePassword(body);
                              await ref
                                  .read(authProvider.notifier)
                                  .getAuthedUser();
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToHome() {
    context.go(HomePage.path);
  }

  void navigateToProducerDashboard() {
    context.go(ProducerHomePage.path);
  }

  void showSnackbar({String? msg}) {
    context.showMySnackBar(content: msg ?? context.local.somethingwentwrong);
  }

  @override
  void dispose() {
    currentPasswordControler.dispose();
    newPasswordControler.dispose();
    confirmPasswordControler.dispose();
    super.dispose();
  }
}
