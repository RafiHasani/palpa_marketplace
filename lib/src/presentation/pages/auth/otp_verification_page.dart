import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/presentation/pages/auth/user_account_complete_form_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/home_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_home_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/auth_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/timer_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_elevated_button.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationPage extends ConsumerStatefulWidget {
  static const String path = '/otpverificationpage';
  const OtpVerificationPage({super.key, required this.phoneorEmail});
  final String phoneorEmail;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtpVerificationPage();
}

class _OtpVerificationPage extends ConsumerState<OtpVerificationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (pre, next) {
      // final user = next.user;
      // if (next.authState == .verifyingCodeSuccess &&
      //     (user?.hasCompletedProfile ?? false)) {
      //   if (user?.isProducer ?? false) {
      //     navigateToProducerDashboard();
      //   } else {
      //     navigateToHomepage();
      //   }
      // } else if (next.authState == .verifyingCodeSuccess &&
      //     !(user?.hasCompletedProfile ?? false)) {
      //   navigateToCompleteAccountDetailpage();
      // } else if (next.authState == .verifyCodeFaild) {
      //   showSnack(msg: next.errorMessage?.error);
      // }
    });
    final theme = ref.read(appThemeDataProvider);
    final local = ref.read(appLangProvider);
    final timer = ref.watch(timerProvider);

    final state = ref.read(authProvider);

    final defaultPinTheme = PinTheme(
      width: 52.w,
      height: 52.h,
      textStyle: theme.textTheme.bodyLarge,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.cardBorderColor, width: 1.w),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primaryColor, width: 1.w),
      borderRadius: BorderRadius.circular(10.r),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppColors.whiteColor,
      ),
    );

    return LoadingWidget(
      isLoading: state.authState == .verifyingCode,
      child: Scaffold(
        extendBody: true,
        appBar: AppbarPageWidget(hideSearch: true),
        body: SafeArea(
          child: Padding(
            padding: .symmetric(horizontal: 24.w),
            child: Column(
              mainAxisSize: .max,
              crossAxisAlignment: .start,
              spacing: 8.h,
              children: [
                Text(
                  'کد تایید را وارید نمایید',
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  'کد تایید برای شماره'
                  '  ${widget.phoneorEmail}  '
                  'ارسال شده',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.subTitileTextColor,
                  ),
                ),

                Form(
                  key: _formKey,
                  child: Align(
                    alignment: .topCenter,
                    child: Directionality(
                      textDirection: .ltr,
                      child: Pinput(
                        controller: _codeController,
                        length: 6,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        showCursor: true,
                        validator: (value) {
                          final val = value ?? '';
                          if (val.isEmpty) {
                            return 'Please enter pin sent to ${widget.phoneorEmail}';
                          }
                          return null;
                        },
                        onCompleted: (pin) => debugPrint(pin),
                      ),
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),

        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: .all(24.r),
            child: Column(
              spacing: 16.h,
              mainAxisSize: .min,
              children: [
                Align(
                  alignment: .bottomCenter,
                  child: timer.canSendAgain
                      ? Row(
                          mainAxisAlignment: .center,
                          crossAxisAlignment: .center,
                          mainAxisSize: .max,
                          children: [
                            TextButton(
                              onPressed: () async {
                                _codeController.clear();
                                ref.read(timerProvider.notifier).reset();
                                await ref
                                    .read(authProvider.notifier)
                                    .loginWithNumber(
                                      widget.phoneorEmail.trim(),
                                    );
                              },
                              child: Text(
                                'ارسال مجدد کد ',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: .center,
                          mainAxisSize: .max,
                          children: [
                            Text(
                              'ارسال مجدد کد تا',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textFieldHintColor,
                              ),
                            ),
                            Text(
                              '  ${timer.secondsLeft.toMinutesSeconds(local)}  ',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textFieldHintColor,
                              ),
                            ),
                            Text(
                              'ثانیه دیگر',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textFieldHintColor,
                              ),
                            ),
                          ],
                        ),
                ),

                Row(
                  mainAxisSize: .max,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        isDisabled: state.authState == .verifyingCode,
                        title: 'تایید',
                        onPressed: () async {
                          final isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (isValid) {
                            final provider = ref.read(authProvider.notifier);

                            await provider.verifyCode(
                              widget.phoneorEmail,
                              _codeController.text.trim(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                24.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateToCompleteAccountDetailpage() {
    context.go(UserAccountCompleteFormPage.path);
  }

  void navigateToHomepage() {
    context.go(HomePage.path);
  }

  void navigateToProducerDashboard() {
    context.go(ProducerHomePage.path);
  }

  void showSnack({String? msg}) {
    context.showMySnackBar(content: msg ?? 'Error verifing Otp');
  }
}
