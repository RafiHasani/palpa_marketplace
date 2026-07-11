import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:palpa_marketplace/src/core/configs/alliance_bottom_navigation.dart';
import 'package:palpa_marketplace/src/core/configs/producer_bottom_navigation.dart';
import 'package:palpa_marketplace/src/data/models/category_model.dart';
import 'package:palpa_marketplace/src/data/models/saler_model.dart';
import 'package:palpa_marketplace/src/presentation/pages/auth/change_password_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/auth/otp_verification_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/auth/register_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/auth/signin_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/auth/update_profile_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/auth/user_account_complete_form_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/common/contactus_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/common/error_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/common/others_user_profile_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/common/privacy_policy_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/common/splash_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/common/terms_condition_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/editproduct/producer_edit_product.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/createproduct/producer_add_product_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_category_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_dashboard_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_home_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_orders_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_product_list_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_products_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_settings_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_show_product_details.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/text_editor_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/categories_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/favourite_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/home_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/notifications_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/orders_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/product_list_details_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/product_list_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/search_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/settings_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/shoping_experiance_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final _shellNavigatorOrdersKey = GlobalKey<NavigatorState>(
  debugLabel: 'orders',
);
final _shellNavigatorCategoriesKey = GlobalKey<NavigatorState>(
  debugLabel: 'categories',
);
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shellNavigatorFavouritesKey = GlobalKey<NavigatorState>(
  debugLabel: 'favourites',
);
final _shellNavigatorSettingsKey = GlobalKey<NavigatorState>(
  debugLabel: 'settings',
);

final _producershellNavigatorDashboardKey = GlobalKey<NavigatorState>(
  debugLabel: 'dashboard',
);
final _producershellNavigatorProductsKey = GlobalKey<NavigatorState>(
  debugLabel: 'products',
);
final _producershellNavigatorOrdersKey = GlobalKey<NavigatorState>(
  debugLabel: 'orders',
);
final _producershellNavigatorSettingsKey = GlobalKey<NavigatorState>(
  debugLabel: 'settings',
);

String previousRoute = '';
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: false,
    initialLocation: SplashScreen.path,
    errorBuilder: (context, state) {
      return ErrorPage();
    },

    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ProducerBottomNavigation(navigationShell: navigationShell);
        },
        branches: producerRouteBranches,
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AllianceBottomNavigation(navigationShell: navigationShell);
        },
        branches: userRouteBranches,
      ),
      GoRoute(
        path: ProducerAddProductPage.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          if (state.extra != null) {
            return ProducerAddProductPage();
          }

          return ProducerAddProductPage();
        },
        routes: [
          GoRoute(
            path: TextEditorPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) {
              final extra = state.extra as List<Object>;
              return TextEditorPage(
                title: extra[0] as String,
                quillController: extra[1] as QuillController,
              );
            },
          ),
        ],
      ),

      ...openRoutes,
    ],
  );
});

final openRoutes = [
  GoRoute(
    path: SplashScreen.path,
    builder: (context, state) {
      return SplashScreen();
    },
  ),

  GoRoute(
    path: LoginPage.path,
    builder: (context, state) {
      return LoginPage();
    },
  ),

  GoRoute(
    path: RegisterPage.path,
    builder: (context, state) {
      return RegisterPage();
    },
  ),
  GoRoute(
    path: TermsConditionPage.path,
    builder: (context, state) {
      return TermsConditionPage();
    },
  ),
  GoRoute(
    path: PrivacyPolicyPage.path,
    builder: (context, state) {
      return PrivacyPolicyPage();
    },
  ),
  GoRoute(
    path: OtpVerificationPage.path,
    builder: (context, state) {
      final phoneorEmail = state.extra as String;
      return OtpVerificationPage(phoneorEmail: phoneorEmail);
    },
  ),

  GoRoute(
    path: UserAccountCompleteFormPage.path,
    builder: (context, state) {
      return UserAccountCompleteFormPage();
    },
  ),

  // Global Error page
  GoRoute(path: ErrorPage.path, builder: (context, state) => const ErrorPage()),
];

final userRoutes = [
  OrdersPage.path,
  CategoriesPage.path,
  HomePage.path,
  NotificationsPage.path,
  SearchPage.path,
  ProductListPage.path,
  FavouritePage.path,
  ProductListDetailsPage.path,
  SettingsPage.path,
  ContactusPage.path,
  UpdateProfilePage.path,
  ShopingExperiancePage.path,
];

final userRouteBranches = [
  // ORDERS BRANCH
  StatefulShellBranch(
    navigatorKey: _shellNavigatorOrdersKey,
    routes: [
      GoRoute(
        path: OrdersPage.path,
        builder: (context, state) => const OrdersPage(),
        routes: [
          GoRoute(
            path: ProductListDetailsPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) {
              final slug = state.extra as String;
              return ProductListDetailsPage(slug: slug);
            },
          ),
        ],
      ),
    ],
  ),

  // CATEGORIES BRANCH
  StatefulShellBranch(
    navigatorKey: _shellNavigatorCategoriesKey,
    routes: [
      GoRoute(
        path: CategoriesPage.path,
        builder: (context, state) => const CategoriesPage(),
        routes: [
          GoRoute(
            path: SearchPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) {
              return SearchPage();
            },
            routes: [
              GoRoute(
                path: ProductListDetailsPage.path,
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) {
                  final slug = state.extra as String;
                  return ProductListDetailsPage(slug: slug);
                },
                routes: [
                  GoRoute(
                    path: OthersUserProfilePage.path,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final profile = state.extra as SalerModel;
                      return OthersUserProfilePage(salerModel: profile);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: ProductListPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) {
              final categoryModel = state.extra as CategoryModel;
              return ProductListPage(categoryModel: categoryModel);
            },

            routes: [
              GoRoute(
                path: SearchPage.path,
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) {
                  return SearchPage();
                },
                routes: [
                  GoRoute(
                    path: ProductListDetailsPage.path,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final slug = state.extra as String;
                      return ProductListDetailsPage(slug: slug);
                    },
                    routes: [
                      GoRoute(
                        path: OthersUserProfilePage.path,
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) {
                          final profile = state.extra as SalerModel;
                          return OthersUserProfilePage(salerModel: profile);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: ProductListDetailsPage.path,
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) {
                  final slug = state.extra as String;
                  return ProductListDetailsPage(slug: slug);
                },
                routes: [
                  GoRoute(
                    path: OthersUserProfilePage.path,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final profile = state.extra as SalerModel;
                      return OthersUserProfilePage(salerModel: profile);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),

  // HOME BRANCH
  StatefulShellBranch(
    navigatorKey: _shellNavigatorHomeKey,
    routes: [
      GoRoute(
        path: HomePage.path,
        builder: (context, state) => HomePage(),
        routes: [
          GoRoute(
            path: NotificationsPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const NotificationsPage(),
          ),

          GoRoute(
            path: SearchPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const SearchPage(),
            routes: [
              GoRoute(
                path: ProductListDetailsPage.path,
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) {
                  final slug = state.extra as String;
                  return ProductListDetailsPage(slug: slug);
                },
                routes: [
                  GoRoute(
                    path: OthersUserProfilePage.path,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final profile = state.extra as SalerModel;
                      return OthersUserProfilePage(salerModel: profile);
                    },
                  ),
                ],
              ),
            ],
          ),

          GoRoute(
            path: ProductListPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) {
              final categoryModel = state.extra as CategoryModel;
              return ProductListPage(categoryModel: categoryModel);
            },
            routes: [
              GoRoute(
                path: ProductListDetailsPage.path,
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) {
                  final slug = state.extra as String;
                  return ProductListDetailsPage(slug: slug);
                },

                routes: [
                  GoRoute(
                    path: OthersUserProfilePage.path,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final profile = state.extra as SalerModel;
                      return OthersUserProfilePage(salerModel: profile);
                    },
                  ),
                ],
              ),

              GoRoute(
                path: SearchPage.path,
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) {
                  return SearchPage();
                },
                routes: [
                  GoRoute(
                    path: ProductListDetailsPage.path,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final slug = state.extra as String;
                      return ProductListDetailsPage(slug: slug);
                    },

                    routes: [
                      GoRoute(
                        path: OthersUserProfilePage.path,
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) {
                          final profile = state.extra as SalerModel;
                          return OthersUserProfilePage(salerModel: profile);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          GoRoute(
            path: ProductListDetailsPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) {
              final slug = state.extra as String;
              return ProductListDetailsPage(slug: slug);
            },

            routes: [
              GoRoute(
                path: OthersUserProfilePage.path,
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) {
                  final profile = state.extra as SalerModel;
                  return OthersUserProfilePage(salerModel: profile);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ),

  // FAVOURITES BRANCH
  StatefulShellBranch(
    navigatorKey: _shellNavigatorFavouritesKey,
    routes: [
      GoRoute(
        path: FavouritePage.path,
        builder: (context, state) => const FavouritePage(),
        routes: [
          GoRoute(
            path: ProductListDetailsPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) {
              final slug = state.extra as String;
              return ProductListDetailsPage(slug: slug);
            },
          ),
        ],
      ),
    ],
  ),

  // SETTINGS BRANCH
  StatefulShellBranch(
    navigatorKey: _shellNavigatorSettingsKey,
    routes: [
      GoRoute(
        path: SettingsPage.path,
        builder: (context, state) => const SettingsPage(),
        routes: [
          GoRoute(
            path: ContactusPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const ContactusPage(),
          ),
          GoRoute(
            path: UpdateProfilePage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const UpdateProfilePage(),
          ),

          GoRoute(
            path: ShopingExperiancePage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const ShopingExperiancePage(),
          ),

          GoRoute(
            path: ChangePasswordPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const ChangePasswordPage(),
          ),
        ],
      ),
    ],
  ),
];
final producerRouteBranches = [
  // Home BRANCH
  StatefulShellBranch(
    navigatorKey: _producershellNavigatorDashboardKey,
    routes: [
      GoRoute(
        path: ProducerHomePage.path,
        builder: (context, state) => const ProducerHomePage(),
        routes: [
          GoRoute(
            path: SearchPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const SearchPage(),
            routes: [
              GoRoute(
                path: ProductListDetailsPage.path,
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) {
                  final slug = state.extra as String;
                  return ProductListDetailsPage(slug: slug);
                },

                routes: [
                  GoRoute(
                    path: OthersUserProfilePage.path,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final profile = state.extra as SalerModel;
                      return OthersUserProfilePage(salerModel: profile);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: ProducerCategoryPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const ProducerCategoryPage(),
            routes: [
              GoRoute(
                path: ProducerProductListPage.path,
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) {
                  final categoryModel = state.extra as CategoryModel;
                  return ProducerProductListPage(categoryModel: categoryModel);
                },
                routes: [
                  GoRoute(
                    path: SearchPage.path,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const SearchPage(),
                    routes: [
                      GoRoute(
                        path: ProductListDetailsPage.path,
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) {
                          final slug = state.extra as String;
                          return ProductListDetailsPage(slug: slug);
                        },

                        routes: [
                          GoRoute(
                            path: OthersUserProfilePage.path,
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) {
                              final profile = state.extra as SalerModel;
                              return OthersUserProfilePage(salerModel: profile);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: ProductListDetailsPage.path,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final slug = state.extra as String;
                      return ProductListDetailsPage(slug: slug);
                    },

                    routes: [
                      GoRoute(
                        path: OthersUserProfilePage.path,
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) {
                          final profile = state.extra as SalerModel;
                          return OthersUserProfilePage(salerModel: profile);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: SearchPage.path,
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) => const SearchPage(),
                routes: [
                  GoRoute(
                    path: ProductListDetailsPage.path,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final slug = state.extra as String;
                      return ProductListDetailsPage(slug: slug);
                    },

                    routes: [
                      GoRoute(
                        path: OthersUserProfilePage.path,
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) {
                          final profile = state.extra as SalerModel;
                          return OthersUserProfilePage(salerModel: profile);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          GoRoute(
            path: ProductListDetailsPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) {
              final slug = state.extra as String;
              return ProductListDetailsPage(slug: slug);
            },

            routes: [
              GoRoute(
                path: OthersUserProfilePage.path,
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) {
                  final profile = state.extra as SalerModel;
                  return OthersUserProfilePage(salerModel: profile);
                },
              ),
            ],
          ),
          GoRoute(
            path: ProducerProductListPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) {
              final categoryModel = state.extra as CategoryModel;
              return ProducerProductListPage(categoryModel: categoryModel);
            },
            routes: [
              GoRoute(
                path: SearchPage.path,
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) => const SearchPage(),
                routes: [
                  GoRoute(
                    path: ProductListDetailsPage.path,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final slug = state.extra as String;
                      return ProductListDetailsPage(slug: slug);
                    },
                    routes: [
                      GoRoute(
                        path: OthersUserProfilePage.path,
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) {
                          final saler = state.extra as SalerModel;
                          return OthersUserProfilePage(salerModel: saler);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: ProductListDetailsPage.path,
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) {
                  final slug = state.extra as String;
                  return ProductListDetailsPage(slug: slug);
                },

                routes: [
                  GoRoute(
                    path: OthersUserProfilePage.path,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final profile = state.extra as SalerModel;
                      return OthersUserProfilePage(salerModel: profile);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),

  // products
  StatefulShellBranch(
    navigatorKey: _producershellNavigatorProductsKey,
    routes: [
      GoRoute(
        path: ProducerProductsPage.path,
        builder: (context, state) => const ProducerProductsPage(),
        routes: [
          GoRoute(
            path: ProducerShowProductDetails.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) {
              final slug = state.extra as String;
              return ProducerShowProductDetails(slug: slug);
            },
          ),

          GoRoute(
            path: ProducerEditProduct.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) {
              final slug = state.extra as String;
              return ProducerEditProduct(slug: slug);
            },
            routes: [
              GoRoute(
                path: TextEditorPage.path,
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) {
                  final extra = state.extra as List<Object>;
                  final title = extra[0] as String;
                  return TextEditorPage(
                    title: title,
                    quillController: extra[1] as QuillController,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ),

  // Orders BRANCH
  StatefulShellBranch(
    navigatorKey: _producershellNavigatorOrdersKey,
    routes: [
      GoRoute(
        path: ProducerOrdersPage.path,
        builder: (context, state) => const ProducerOrdersPage(),
      ),
    ],
  ),

  // SETTINGS BRANCH
  StatefulShellBranch(
    navigatorKey: _producershellNavigatorSettingsKey,
    routes: [
      GoRoute(
        path: ProducerSettingsPage.path,
        builder: (context, state) => const ProducerSettingsPage(),
        routes: [
          GoRoute(
            path: ProducerDashboardPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const ProducerDashboardPage(),
          ),

          GoRoute(
            path: UpdateProfilePage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const UpdateProfilePage(),
          ),

          GoRoute(
            path: ContactusPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const ContactusPage(),
          ),

          GoRoute(
            path: ChangePasswordPage.path,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const ChangePasswordPage(),
          ),
        ],
      ),
    ],
  ),
];

final freeRoutes = [
  SplashScreen.path,
  HomePage.path,
  SettingsPage.path,
  LoginPage.path,
  RegisterPage.path,
  SearchPage.path,
  TermsConditionPage.path,
  ContactusPage.path,
  PrivacyPolicyPage.path,
  OtpVerificationPage.path,
  UserAccountCompleteFormPage.path,
  ErrorPage.path,
];

final producerRoutes = [
  ProducerAddProductPage.path,
  ProducerHomePage.path,
  ProducerOrdersPage.path,
  ProducerProductsPage.path,
  ProducerSettingsPage.path,
  UpdateProfilePage.path,
  ProducerEditProduct.path,
  TextEditorPage.path,
  ProducerCategoryPage.path,
  SearchPage.path,
  ProducerProductListPage.path,
  ProductListDetailsPage.path,
];
