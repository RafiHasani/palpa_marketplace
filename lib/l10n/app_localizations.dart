import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_ps.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
    Locale('ps'),
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @orders2.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders2;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @favourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favourites;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @search_items.
  ///
  /// In en, this message translates to:
  /// **'Search itmes'**
  String get search_items;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @somethingwentwrong.
  ///
  /// In en, this message translates to:
  /// **'Someting went wrong, Please try again'**
  String get somethingwentwrong;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inActive.
  ///
  /// In en, this message translates to:
  /// **'InActive'**
  String get inActive;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @signin_info.
  ///
  /// In en, this message translates to:
  /// **'Use your username and password to sign in'**
  String get signin_info;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signup;

  /// No description provided for @bysignintokaraniz.
  ///
  /// In en, this message translates to:
  /// **'By signing in to Karaniz, '**
  String get bysignintokaraniz;

  /// No description provided for @termsconditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsconditions;

  /// No description provided for @usingkaranizand.
  ///
  /// In en, this message translates to:
  /// **' Using Karniz and '**
  String get usingkaranizand;

  /// No description provided for @privacypolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacypolicy;

  /// No description provided for @youacceptit.
  ///
  /// In en, this message translates to:
  /// **'You accept!'**
  String get youacceptit;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @lastname.
  ///
  /// In en, this message translates to:
  /// **'LastName'**
  String get lastname;

  /// No description provided for @confirmpassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmpassword;

  /// No description provided for @enterusername.
  ///
  /// In en, this message translates to:
  /// **'Please enter username!'**
  String get enterusername;

  /// No description provided for @enterpassword.
  ///
  /// In en, this message translates to:
  /// **'Please input password!'**
  String get enterpassword;

  /// No description provided for @enternamehint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enternamehint;

  /// No description provided for @entername.
  ///
  /// In en, this message translates to:
  /// **'Please Enter your name'**
  String get entername;

  /// No description provided for @name_length_error.
  ///
  /// In en, this message translates to:
  /// **'Name must be greater than 4 characters'**
  String get name_length_error;

  /// No description provided for @name_max_length_error.
  ///
  /// In en, this message translates to:
  /// **'Name must be less than 50 characters'**
  String get name_max_length_error;

  /// No description provided for @lastname_length_error.
  ///
  /// In en, this message translates to:
  /// **'Last name must be greater than 4 characters'**
  String get lastname_length_error;

  /// No description provided for @lastname_max_length_error.
  ///
  /// In en, this message translates to:
  /// **'Last name must be less than 20 characters'**
  String get lastname_max_length_error;

  /// No description provided for @enter_lastname.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enter_lastname;

  /// No description provided for @username_length_error.
  ///
  /// In en, this message translates to:
  /// **'Username must be greater than 5 characters'**
  String get username_length_error;

  /// No description provided for @username_required.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get username_required;

  /// No description provided for @enter_username_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enter_username_hint;

  /// No description provided for @password_length_error.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get password_length_error;

  /// No description provided for @password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get password_required;

  /// No description provided for @enter_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enter_password_hint;

  /// No description provided for @confirm_password_mismatch.
  ///
  /// In en, this message translates to:
  /// **'Confirm password does not match password'**
  String get confirm_password_mismatch;

  /// No description provided for @confirm_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your confirm password'**
  String get confirm_password_hint;

  /// No description provided for @edit_user_password.
  ///
  /// In en, this message translates to:
  /// **'Edit User Password'**
  String get edit_user_password;

  /// No description provided for @current_password.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get current_password;

  /// No description provided for @current_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get current_password_hint;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @new_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get new_password_hint;

  /// No description provided for @password_max_length_error.
  ///
  /// In en, this message translates to:
  /// **'Password must be less than 50 characters'**
  String get password_max_length_error;

  /// No description provided for @edit_user_info.
  ///
  /// In en, this message translates to:
  /// **'Edit User Information'**
  String get edit_user_info;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @phone_number_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get phone_number_invalid;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get email_invalid;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @address_max_length_error.
  ///
  /// In en, this message translates to:
  /// **'Address must be less than 50 characters'**
  String get address_max_length_error;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @product_info_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter some information about your product'**
  String get product_info_required;

  /// No description provided for @complete_user_account.
  ///
  /// In en, this message translates to:
  /// **'Complete User Account'**
  String get complete_user_account;

  /// No description provided for @date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get date_of_birth;

  /// No description provided for @dob_required.
  ///
  /// In en, this message translates to:
  /// **'Date of birth is required'**
  String get dob_required;

  /// No description provided for @dob_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your date of birth'**
  String get dob_hint;

  /// No description provided for @i_am_producer.
  ///
  /// In en, this message translates to:
  /// **'I am a producer'**
  String get i_am_producer;

  /// No description provided for @upload_company_logo.
  ///
  /// In en, this message translates to:
  /// **'Please upload your company logo'**
  String get upload_company_logo;

  /// No description provided for @upload_logo.
  ///
  /// In en, this message translates to:
  /// **'Upload Logo'**
  String get upload_logo;

  /// No description provided for @bio_length_error.
  ///
  /// In en, this message translates to:
  /// **'Bio must be greater than 20 characters'**
  String get bio_length_error;

  /// No description provided for @bio_max_length_error.
  ///
  /// In en, this message translates to:
  /// **'Bio must be less than 500 characters'**
  String get bio_max_length_error;

  /// No description provided for @bio_hint.
  ///
  /// In en, this message translates to:
  /// **'Write a few sentences about your company'**
  String get bio_hint;

  /// No description provided for @confirm_info.
  ///
  /// In en, this message translates to:
  /// **'Confirm Information'**
  String get confirm_info;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// No description provided for @contact_methods_info.
  ///
  /// In en, this message translates to:
  /// **'Let’s stay in touch through these ways'**
  String get contact_methods_info;

  /// No description provided for @unexpected_error.
  ///
  /// In en, this message translates to:
  /// **'Well, this is unexpected'**
  String get unexpected_error;

  /// No description provided for @go_back.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get go_back;

  /// No description provided for @seller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get seller;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @no_favourites_yet.
  ///
  /// In en, this message translates to:
  /// **'You haven’t created any favourites yet'**
  String get no_favourites_yet;

  /// No description provided for @no_favourites_list.
  ///
  /// In en, this message translates to:
  /// **'You haven’t created a favourites list yet'**
  String get no_favourites_list;

  /// No description provided for @go_explore_market.
  ///
  /// In en, this message translates to:
  /// **'Let\'s explore the market'**
  String get go_explore_market;

  /// No description provided for @all_categories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get all_categories;

  /// No description provided for @afghani.
  ///
  /// In en, this message translates to:
  /// **'Afghani'**
  String get afghani;

  /// No description provided for @best_sellers.
  ///
  /// In en, this message translates to:
  /// **'Best Sellers'**
  String get best_sellers;

  /// No description provided for @most_loved.
  ///
  /// In en, this message translates to:
  /// **'Most Loved'**
  String get most_loved;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @no_notifications_yet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get no_notifications_yet;

  /// No description provided for @latest_notifications_info.
  ///
  /// In en, this message translates to:
  /// **'We show the latest notifications here'**
  String get latest_notifications_info;

  /// No description provided for @order_placed_success.
  ///
  /// In en, this message translates to:
  /// **'Order placed successfully'**
  String get order_placed_success;

  /// No description provided for @order_canceled_success.
  ///
  /// In en, this message translates to:
  /// **'Order canceled successfully'**
  String get order_canceled_success;

  /// No description provided for @order_count_label.
  ///
  /// In en, this message translates to:
  /// **'Number of Orders '**
  String get order_count_label;

  /// No description provided for @no_orders_yet.
  ///
  /// In en, this message translates to:
  /// **'You don’t have any orders yet!'**
  String get no_orders_yet;

  /// No description provided for @time_to_explore_market.
  ///
  /// In en, this message translates to:
  /// **'It’s a good time to start exploring the market.'**
  String get time_to_explore_market;

  /// No description provided for @your_cart_summary.
  ///
  /// In en, this message translates to:
  /// **'Your Cart Summary'**
  String get your_cart_summary;

  /// No description provided for @change_order_pending.
  ///
  /// In en, this message translates to:
  /// **'You can change order state only if it is in pending state!'**
  String get change_order_pending;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @submit_review.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submit_review;

  /// No description provided for @submit_rating_and_review.
  ///
  /// In en, this message translates to:
  /// **'Submit Rating and Review'**
  String get submit_rating_and_review;

  /// No description provided for @review_text_hint.
  ///
  /// In en, this message translates to:
  /// **'Review Text'**
  String get review_text_hint;

  /// No description provided for @comment_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter your comment'**
  String get comment_required;

  /// No description provided for @share_comment_hint.
  ///
  /// In en, this message translates to:
  /// **'Share your comment about this item'**
  String get share_comment_hint;

  /// No description provided for @star_rating_required.
  ///
  /// In en, this message translates to:
  /// **'Please give a star rating from 1 to 5'**
  String get star_rating_required;

  /// No description provided for @producer.
  ///
  /// In en, this message translates to:
  /// **'Producer'**
  String get producer;

  /// No description provided for @purchase_experiences.
  ///
  /// In en, this message translates to:
  /// **'Purchase Experiences'**
  String get purchase_experiences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logout_failed.
  ///
  /// In en, this message translates to:
  /// **'Logout Failed'**
  String get logout_failed;

  /// No description provided for @edit_review.
  ///
  /// In en, this message translates to:
  /// **'Edit Review'**
  String get edit_review;

  /// No description provided for @delete_review.
  ///
  /// In en, this message translates to:
  /// **'Delete Review'**
  String get delete_review;

  /// No description provided for @your_search_history.
  ///
  /// In en, this message translates to:
  /// **'Your Search History'**
  String get your_search_history;

  /// No description provided for @product_in_category.
  ///
  /// In en, this message translates to:
  /// **'Product in Category '**
  String get product_in_category;

  /// No description provided for @remaining_in_stock.
  ///
  /// In en, this message translates to:
  /// **'Remaining in Stock'**
  String get remaining_in_stock;

  /// No description provided for @user_reviews.
  ///
  /// In en, this message translates to:
  /// **'User Reviews'**
  String get user_reviews;

  /// No description provided for @specifications.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get specifications;

  /// No description provided for @introduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get introduction;

  /// No description provided for @buyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get buyer;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @add_to_order_list.
  ///
  /// In en, this message translates to:
  /// **'Add to Order List'**
  String get add_to_order_list;

  /// No description provided for @cannot_order_own_product.
  ///
  /// In en, this message translates to:
  /// **'You cannot order your own product!'**
  String get cannot_order_own_product;

  /// No description provided for @product_quantity_min.
  ///
  /// In en, this message translates to:
  /// **'Product quantity should be at least 1 or greater'**
  String get product_quantity_min;

  /// No description provided for @karaniz.
  ///
  /// In en, this message translates to:
  /// **'Karaniz'**
  String get karaniz;

  /// No description provided for @product_name_dari.
  ///
  /// In en, this message translates to:
  /// **'Product Name (Dari)'**
  String get product_name_dari;

  /// No description provided for @product_name_dari_min_length.
  ///
  /// In en, this message translates to:
  /// **'Product name (Dari) must be greater than 8 characters'**
  String get product_name_dari_min_length;

  /// No description provided for @enter_product_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter the product name'**
  String get enter_product_name;

  /// No description provided for @product_name_pashto.
  ///
  /// In en, this message translates to:
  /// **'Product Name (Pashto)'**
  String get product_name_pashto;

  /// No description provided for @product_name_pashto_min_length.
  ///
  /// In en, this message translates to:
  /// **'Product name (Pashto) must be greater than 8 characters'**
  String get product_name_pashto_min_length;

  /// No description provided for @product_name_max_length_error.
  ///
  /// In en, this message translates to:
  /// **'Product name must be less than 200 characters'**
  String get product_name_max_length_error;

  /// No description provided for @product_name_english.
  ///
  /// In en, this message translates to:
  /// **'Product Name (English)'**
  String get product_name_english;

  /// No description provided for @product_name_english_min_length.
  ///
  /// In en, this message translates to:
  /// **'Product name (English) must be greater than 8 characters'**
  String get product_name_english_min_length;

  /// No description provided for @select_category.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get select_category;

  /// No description provided for @select_category_hint.
  ///
  /// In en, this message translates to:
  /// **'Select the relevant category'**
  String get select_category_hint;

  /// No description provided for @category_required.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get category_required;

  /// No description provided for @select_subcategory.
  ///
  /// In en, this message translates to:
  /// **'Select Subcategory'**
  String get select_subcategory;

  /// No description provided for @subcategory_required.
  ///
  /// In en, this message translates to:
  /// **'Please select a sub category'**
  String get subcategory_required;

  /// No description provided for @specifications_dari.
  ///
  /// In en, this message translates to:
  /// **'Specifications (Dari)'**
  String get specifications_dari;

  /// No description provided for @specifications_pashto.
  ///
  /// In en, this message translates to:
  /// **'Specifications (Pashto)'**
  String get specifications_pashto;

  /// No description provided for @specifications_english.
  ///
  /// In en, this message translates to:
  /// **'Specifications (English)'**
  String get specifications_english;

  /// No description provided for @introduction_dari.
  ///
  /// In en, this message translates to:
  /// **'Introduction (Dari)'**
  String get introduction_dari;

  /// No description provided for @introduction_pashto.
  ///
  /// In en, this message translates to:
  /// **'Introduction (Pashto)'**
  String get introduction_pashto;

  /// No description provided for @introduction_english.
  ///
  /// In en, this message translates to:
  /// **'Introduction (English)'**
  String get introduction_english;

  /// No description provided for @accept_terms.
  ///
  /// In en, this message translates to:
  /// **'I have read and accept the product sale and publication rules'**
  String get accept_terms;

  /// No description provided for @product_image.
  ///
  /// In en, this message translates to:
  /// **'Product Image'**
  String get product_image;

  /// No description provided for @upload_product_images_hint.
  ///
  /// In en, this message translates to:
  /// **'Please upload images of the product'**
  String get upload_product_images_hint;

  /// No description provided for @upload_product_image.
  ///
  /// In en, this message translates to:
  /// **'Upload Product Image'**
  String get upload_product_image;

  /// No description provided for @province.
  ///
  /// In en, this message translates to:
  /// **'Province'**
  String get province;

  /// No description provided for @province_required.
  ///
  /// In en, this message translates to:
  /// **'Please select province!'**
  String get province_required;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @price_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter the price for the product'**
  String get price_required;

  /// No description provided for @price_hint.
  ///
  /// In en, this message translates to:
  /// **'Product Price'**
  String get price_hint;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @kilogram.
  ///
  /// In en, this message translates to:
  /// **'Kilogram'**
  String get kilogram;

  /// No description provided for @unit_required.
  ///
  /// In en, this message translates to:
  /// **'Please select a unit for the product'**
  String get unit_required;

  /// No description provided for @in_stock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get in_stock;

  /// No description provided for @in_stock_required.
  ///
  /// In en, this message translates to:
  /// **'In-stock product amount is required'**
  String get in_stock_required;

  /// No description provided for @in_stock_hint.
  ///
  /// In en, this message translates to:
  /// **'Available Quantity'**
  String get in_stock_hint;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @continue_next.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_next;

  /// No description provided for @product_specs_dari_required.
  ///
  /// In en, this message translates to:
  /// **'Product specs (Dari) are required. Please enter at least 100 characters'**
  String get product_specs_dari_required;

  /// No description provided for @product_specs_pashto_required.
  ///
  /// In en, this message translates to:
  /// **'Product specs (Pashto) are required. Please enter at least 100 characters'**
  String get product_specs_pashto_required;

  /// No description provided for @product_specs_english_required.
  ///
  /// In en, this message translates to:
  /// **'Product specs (English) are required. Please enter at least 100 characters'**
  String get product_specs_english_required;

  /// No description provided for @product_intro_dari_required.
  ///
  /// In en, this message translates to:
  /// **'Product introduction (Dari) is required. Please enter at least 100 characters'**
  String get product_intro_dari_required;

  /// No description provided for @product_intro_pashto_required.
  ///
  /// In en, this message translates to:
  /// **'Product introduction (Pashto) is required. Please enter at least 100 characters'**
  String get product_intro_pashto_required;

  /// No description provided for @product_intro_english_required.
  ///
  /// In en, this message translates to:
  /// **'Product introduction (English) is required. Please enter at least 100 characters'**
  String get product_intro_english_required;

  /// No description provided for @product_image_required.
  ///
  /// In en, this message translates to:
  /// **'Please upload at least one image of your product'**
  String get product_image_required;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @date_label.
  ///
  /// In en, this message translates to:
  /// **'Date: '**
  String get date_label;

  /// No description provided for @quantity_label.
  ///
  /// In en, this message translates to:
  /// **'Quantity: '**
  String get quantity_label;

  /// No description provided for @new_orders.
  ///
  /// In en, this message translates to:
  /// **'New Orders'**
  String get new_orders;

  /// No description provided for @average_rating.
  ///
  /// In en, this message translates to:
  /// **'Average Ratings'**
  String get average_rating;

  /// No description provided for @no_internet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection found!'**
  String get no_internet;

  /// No description provided for @other_orders.
  ///
  /// In en, this message translates to:
  /// **'Orders from Others'**
  String get other_orders;

  /// No description provided for @my_orders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get my_orders;

  /// No description provided for @my_products.
  ///
  /// In en, this message translates to:
  /// **'My Products'**
  String get my_products;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @sales_experiences.
  ///
  /// In en, this message translates to:
  /// **'Sales Experiences'**
  String get sales_experiences;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @dari.
  ///
  /// In en, this message translates to:
  /// **'Dari'**
  String get dari;

  /// No description provided for @pashto.
  ///
  /// In en, this message translates to:
  /// **'Pashto'**
  String get pashto;

  /// No description provided for @only.
  ///
  /// In en, this message translates to:
  /// **'Only'**
  String get only;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @submit_rating_review.
  ///
  /// In en, this message translates to:
  /// **'Submit Rating and Review'**
  String get submit_rating_review;

  /// No description provided for @review_text.
  ///
  /// In en, this message translates to:
  /// **'Review Text'**
  String get review_text;

  /// No description provided for @seller_label.
  ///
  /// In en, this message translates to:
  /// **'Seller: '**
  String get seller_label;

  /// No description provided for @publish_product.
  ///
  /// In en, this message translates to:
  /// **'Publish Product'**
  String get publish_product;

  /// No description provided for @user_input_guide.
  ///
  /// In en, this message translates to:
  /// **'Only letters, numbers, ., _ and - are allowed'**
  String get user_input_guide;

  /// No description provided for @max_200_words_allowed.
  ///
  /// In en, this message translates to:
  /// **'Minimum 1 word and maximum 200 words are allowed.'**
  String get max_200_words_allowed;

  /// No description provided for @login_required_to_order.
  ///
  /// In en, this message translates to:
  /// **'Please log in first to place an order.'**
  String get login_required_to_order;

  /// No description provided for @login_required.
  ///
  /// In en, this message translates to:
  /// **'Please log in first !'**
  String get login_required;

  /// No description provided for @confirm_order.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirm_order;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa', 'ps'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'ps':
      return AppLocalizationsPs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
