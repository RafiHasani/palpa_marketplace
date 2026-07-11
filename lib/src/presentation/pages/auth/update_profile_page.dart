import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/presentation/widgets/dismiss_keyboard_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';

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
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_date_picker_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_elevated_button.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';

class UpdateProfilePage extends ConsumerStatefulWidget {
  static const String path = '/updateprofilepage';
  const UpdateProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateProfilePage();
}

class _UpdateProfilePage extends ConsumerState<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameControler = TextEditingController();
  TextEditingController lastNameControler = TextEditingController();
  TextEditingController phoneControler = TextEditingController();
  TextEditingController emailControler = TextEditingController();
  TextEditingController addressControler = TextEditingController();
  TextEditingController bioControler = TextEditingController();

  XFile? imagePicked;

  @override
  void initState() {
    super.initState();

    loadUserData();
  }

  Future<void> loadUserData() async {
    Future.microtask(() async {
      await ref.read(authProvider.notifier).getAuthedUser();
    });

    final user = Appconfig().user;
    firstNameControler.text = user?.name ?? '';
    lastNameControler.text = user?.lastName ?? '';
    phoneControler.text = user?.phone ?? '';
    bioControler.text = user?.bio ?? '';
    addressControler.text = user?.address ?? '';
    emailControler.text = user?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (pre, next) {
      if (next.authState == .updatingSuccess) {
        if (next.user?.isProducer ?? false) {
          navigateToProducerDashboard();
        } else {
          navigateToHome();
        }
      } else if (next.authState == .updatingFailed) {
        showSnackbar(msg: next.errorMessage?.error);
      }
    });

    final theme = ref.read(appThemeDataProvider);
    final authStat = ref.watch(authProvider);

    return DismissKeyboardWidget(
      child: LoadingWidget(
        isLoading: (authStat.authState == .updatingProfile),
        child: Scaffold(
          appBar: AppbarPageWidget(
            hideSearch: true,
            title: context.local.edit_user_info,
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
                    Center(
                      child: SizedBox(
                        height: 100.h,
                        width: 100.h,
                        child: Stack(
                          alignment: .center,
                          children: [
                            Center(
                              child: imagePicked != null
                                  ? CircleAvatar(
                                      radius: 44.r,
                                      backgroundImage: Image.file(
                                        File(imagePicked!.path),
                                      ).image,
                                    )
                                  : Appconfig().user?.avatar != null
                                  ? CircleAvatar(
                                      radius: 44.r,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                            Appconfig().user?.avatar ?? '',
                                            errorListener: (value) {
                                              debugPrint(value.toString());
                                            },
                                          ),
                                    )
                                  : CachedNetworkImageWidget(
                                      image: Appconfig().user?.avatar,
                                      errorWidgetSize: 32.r,
                                    ),
                            ),
                            PositionedDirectional(
                              bottom: 6,
                              height: 28.h,
                              start: 10,
                              end: 10,

                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () async {
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: .only(
                                      topLeft: Radius.circular(8.r),
                                      topRight: Radius.circular(8.r),
                                      bottomLeft: Radius.elliptical(
                                        100.w,
                                        70.h,
                                      ),
                                      bottomRight: Radius.elliptical(
                                        100.w,
                                        70.h,
                                      ),
                                    ),
                                    color: Colors.white.withAlpha(200),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgIcon(
                                        assetName: 'assets/icons/edit.svg',
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        context.local.edit,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        border: .all(color: AppColors.cardBorderColor),
                        borderRadius: .circular(56.r),
                      ),
                      padding: .all(16.r),
                      child: SvgIcon(
                        assetName: 'assets/icons/edit.svg',
                        color: AppColors.backButtonColor,
                        fit: .cover,
                      ),
                    ),
                    16.verticalSpace,

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
                                controller: lastNameControler,
                                validator: (value) {
                                  String str = value ?? '';
                                  if (str.length < 4) {
                                    return context.local.lastname_length_error;
                                  } else if (str.length > 50) {
                                    return context
                                        .local
                                        .lastname_max_length_error;
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
                                    context.local.phone_number,
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
                                keyboardType: .phone,
                                controller: phoneControler,
                                maxLength: 15,
                                validator: (value) {
                                  String str = value ?? '';
                                  if (str.isNotEmpty && !str.isPhone()) {
                                    return context.local.phone_number_invalid;
                                  } else {
                                    return null;
                                  }
                                },
                                decoration:
                                    InputDecoration(
                                      hintText: context.local.phone_number,
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
                                    context.local.email,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              8.verticalSpace,
                              TextFormField(
                                controller: emailControler,
                                validator: (value) {
                                  String str = value ?? '';
                                  if (str.isNotEmpty && !str.isEmail()) {
                                    return context.local.email_invalid;
                                  } else {
                                    return null;
                                  }
                                },
                                decoration:
                                    InputDecoration(
                                      hintText: context.local.email,
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
                                    context.local.address,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              8.verticalSpace,
                              TextFormField(
                                controller: addressControler,
                                validator: (value) {
                                  String str = value ?? '';
                                  if (str.length > 50) {
                                    return context
                                        .local
                                        .address_max_length_error;
                                  } else {
                                    return null;
                                  }
                                },
                                decoration:
                                    InputDecoration(
                                      hintText: context.local.address,
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

                          if (Appconfig().user?.isProducer ?? false)
                            Column(
                              children: [
                                Row(
                                  spacing: 4.w,
                                  children: [
                                    Text(
                                      context.local.about,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                8.verticalSpace,
                                TextFormField(
                                  maxLength: 500,
                                  maxLines: 5,
                                  controller: bioControler,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return context
                                          .local
                                          .product_info_required;
                                    }
                                    return null;
                                  },

                                  decoration:
                                      InputDecoration(
                                        hintText: context.local.about,
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
                                final dob = Appconfig().user?.dob ?? '';

                                final body = {
                                  'name': firstNameControler.text.trim(),
                                  'last_name': lastNameControler.text.trim(),
                                  'dob': dob,
                                  'is_producer': Appconfig().user?.isProducer,
                                  'address': addressControler.text,
                                };

                                if (emailControler.text.trim().isNotEmpty) {
                                  body['email'] = emailControler.text.trim();
                                }
                                if (phoneControler.text.trim().isNotEmpty) {
                                  body['phone'] = phoneControler.text.trim();
                                }

                                if ((Appconfig().user?.isProducer ?? false)) {
                                  body['bio'] =
                                      'The is a fruit proction company, we have different type of fruit from different seasons.'; //bioControler.text.trim();
                                }
                                if (imagePicked != null) {
                                  final imageCompress =
                                      await ImageCompressionService.compressImages(
                                        [imagePicked!],
                                      );
                                  body['avatar'] = (imageCompress.isNotEmpty)
                                      ? imageCompress.first.path
                                      : imagePicked?.path ?? '';
                                }

                                final provider = ref.read(
                                  authProvider.notifier,
                                );

                                await provider.updateProfile(body);
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
    phoneControler.dispose();
    emailControler.dispose();
    addressControler.dispose();
    bioControler.dispose();
    super.dispose();
  }
}
