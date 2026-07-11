import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/configs/appconfig.dart';
import 'package:palpa_marketplace/src/core/configs/theme_data.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/string_extension.dart';
import 'package:palpa_marketplace/src/core/utils/image_compressore.dart';
import 'package:palpa_marketplace/src/core/utils/image_picker.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_home_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/home_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/auth_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/checkbox_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_date_picker_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_elevated_button.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';

class UserAccountCompleteFormPage extends ConsumerStatefulWidget {
  static const String path = '/useraccountcompleteformpage';
  const UserAccountCompleteFormPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserAccountCompleteFormPage();
}

class _UserAccountCompleteFormPage
    extends ConsumerState<UserAccountCompleteFormPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (mounted && ref.watch(authProvider).isAuthenticated) {
      final user = Appconfig().user;
      firstNameControler.text = user?.name ?? '';
      lastNameControler.text = user?.lastName ?? '';
    }
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameControler = TextEditingController();
  TextEditingController lastNameControler = TextEditingController();
  TextEditingController dobControler = TextEditingController();
  TextEditingController bioControler = TextEditingController();

  XFile? imagePicked;
  Jalali birthdayJalali = Jalali.now();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (pre, next) {
      final user = next.user;

      if (next.authState == .updatingSuccess && (user?.isProducer ?? false)) {
        navigateToProducerPage();
      } else if (next.authState == .updatingSuccess &&
          !(user?.isProducer ?? false)) {
        navigateToHome();
      } else if (next.authState == .updatingFailed) {
        showSnackbar(msg: next.errorMessage?.error);
      }
    });
    final state = ref.watch(authProvider);

    final theme = ref.read(appThemeDataProvider);
    final local = ref.read(appLangProvider);

    return LoadingWidget(
      isLoading: state.authState == .updatingProfile,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBody: true,
        appBar: AppbarPageWidget(
          hideSearch: true,
          title: context.local.complete_user_account,
          titleOnly: true,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: .all(24.w),
              child: Column(
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
                              controller: firstNameControler,
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
                                    hintText: context.local.entername,
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
                                  'نام خانوادگی',
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
                              controller: lastNameControler,
                              validator: (value) {
                                String str = value ?? '';
                                if (str.length < 4) {
                                  return 'last name must be greater than 4 characters';
                                } else if (str.length > 50) {
                                  return 'last name must be less than 50 characters';
                                } else {
                                  return null;
                                }
                              },
                              decoration:
                                  InputDecoration(
                                    hintText: 'نام خانوادگی خود را وارد کنید',
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
                                  context.local.date_of_birth,
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
                            InkWell(
                              onTap: () async {
                                final date = await selectDate(context, local);
                                birthdayJalali = date ?? birthdayJalali;

                                dobControler.text = date?.fomated(local) ?? '';
                              },
                              child: TextFormField(
                                validator: (value) {
                                  String str = value ?? '';
                                  if (str.isEmpty) {
                                    return context.local.dob_required;
                                  } else {
                                    return null;
                                  }
                                },
                                controller: dobControler,
                                enabled: false,
                                style: theme.textTheme.bodyMedium,
                                decoration:
                                    InputDecoration(
                                      hintText: context.local.dob_hint,
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
                                      disabledBorder: AppTheme
                                          .inputTextFeildThemeLightRadiu10
                                          .enabledBorder,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: .start,
                          children: [
                            CustomCheckBoxWidget(
                              intialValue: isChecked,
                              state: (value) {
                                setState(() {
                                  isChecked = value;
                                });
                              },
                            ),

                            Text(
                              context.local.i_am_producer,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.black2,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          width: .maxFinite,
                          padding: .symmetric(vertical: 24.h),
                          decoration: BoxDecoration(
                            borderRadius: .circular(10.r),
                            border: .all(color: AppColors.cardBorderColor),
                            color: AppColors.whiteColor,
                          ),
                          child: Row(
                            mainAxisAlignment: .spaceEvenly,
                            children: [
                              if (imagePicked != null)
                                CircleAvatar(
                                  radius: 44.r,
                                  backgroundImage: Image.file(
                                    File(imagePicked!.path),
                                  ).image,
                                ),
                              Column(
                                spacing: 8.h,
                                mainAxisSize: .max,
                                mainAxisAlignment: .center,
                                crossAxisAlignment: .center,
                                children: [
                                  Text(
                                    context.local.upload_company_logo,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.subTitileTextColor,
                                    ),
                                  ),

                                  OutlinedButton.icon(
                                    onPressed: () async {
                                      final response = await pickImage();

                                      response.fold(
                                        (error) {
                                          context.showMySnackBar(
                                            content: error.toString(),
                                          );
                                        },
                                        (image) {
                                          imagePicked = image;
                                          setState(() {});
                                        },
                                      );
                                    },
                                    label: Text(
                                      context.local.upload_logo,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            color: AppColors.primaryColor,
                                          ),
                                    ),
                                    icon: SvgIcon(
                                      assetName: 'assets/icons/upload_icon.svg',
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: .all(.circular(10.r)),
                                      ),
                                      side: BorderSide(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        isChecked
                            ? Column(
                                spacing: 16.h,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        spacing: 4.w,
                                        children: [
                                          Text(
                                            context.local.about,
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                          Text(
                                            '*',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  color: AppColors.red,
                                                ),
                                          ),
                                        ],
                                      ),
                                      8.verticalSpace,
                                      TextFormField(
                                        maxLines: 4,
                                        maxLength: 100,
                                        controller: bioControler,
                                        validator: (value) {
                                          String str = value ?? '';
                                          if (str.length < 20) {
                                            return context
                                                .local
                                                .bio_length_error;
                                          } else if (str.length > 500) {
                                            return context
                                                .local
                                                .bio_max_length_error;
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration:
                                            InputDecoration(
                                              counterText: '',
                                              hintText: context.local.bio_hint,
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
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: .all(24.r),
            child: Column(
              mainAxisAlignment: .center,
              mainAxisSize: .min,
              children: [
                Row(
                  mainAxisSize: .max,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        isDisabled: state.authState == .updatingProfile,
                        title: context.local.confirm_info,
                        onPressed: () async {
                          final isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (isValid) {
                            final date = birthdayJalali.toGregorian();
                            final year = date.formatter.yyyy;
                            final month = date.formatter.mm;
                            final day = date.formatter.dd;
                            final dob = '$year-$month-$day';
                            final body = {
                              'name': firstNameControler.text.trim(),
                              'last_name': lastNameControler.text.trim(),
                              'dob': dob,
                              'is_producer': isChecked,
                            };

                            if (isChecked) {
                              body['bio'] = bioControler.text.trim();
                            }

                            if (imagePicked != null) {
                              final imageCompress =
                                  await ImageCompressionService.compressImages([
                                    imagePicked!,
                                  ]);

                              body['avatar'] = (imageCompress.isNotEmpty)
                                  ? imageCompress.first.path
                                  : imagePicked?.path ?? '';
                            }

                            final provider = ref.read(authProvider.notifier);

                            await provider.updateProfile(body);
                            await ref
                                .read(authProvider.notifier)
                                .getAuthedUser();
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

  void navigateToHome() {
    context.go(HomePage.path);
  }

  void navigateToProducerPage() {
    context.go(ProducerHomePage.path);
  }

  void showSnackbar({String? msg}) {
    context.showMySnackBar(content: msg ?? context.local.somethingwentwrong);
  }

  Future<Jalali?> selectDate(BuildContext context, Locale locale) async {
    final result = await showModalBottomSheet<Jalali>(
      useRootNavigator: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return CustomDatePickerWidget(
          callback: (Jalali date) {
            context.pop(date);
          },
        );
      },
    );

    return result;
  }

  @override
  void dispose() {
    firstNameControler.dispose();
    lastNameControler.dispose();
    dobControler.dispose();
    bioControler.dispose();
    super.dispose();
  }
}
