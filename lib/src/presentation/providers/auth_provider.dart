import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palpa_marketplace/src/core/configs/appconfig.dart';
import 'package:palpa_marketplace/src/core/constants/contants.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/user.dart';
import 'package:palpa_marketplace/src/data/repository_impl/auth_repo_impl.dart';
import 'package:palpa_marketplace/src/domain/repositories/auth_repo.dart';
import 'package:palpa_marketplace/src/presentation/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthProviderState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthProviderState> {
  late AuthRepo repo;
  late SharedPreferences? prefs;

  @override
  AuthProviderState build() {
    prefs = ref.watch(sharedPreferencesProvider);
    repo = ref.read(authRepoImplProvider);
    return const AuthProviderState.initial();
  }

  Future<void> logout() async {
    state = state.copyWith(authState: .loggingOut);

    final response = await repo.logout();

    return response.fold(
      (error) {
        state = state.copyWith(errorMessage: error, authState: .logOutFailed);
      },
      (response) {
        logoutStateUpdate();
      },
    );
  }

  Future<void> loginWithUsernamePassword(
    String username,
    String password,
  ) async {
    try {
      state = state.copyWith(authState: .loggingin);

      final response = await repo.loginWithUsernamePassword(
        username: username,
        password: password,
      );

      return response.fold(
        (error) {
          state = state.copyWith(errorMessage: error, authState: .loginFailed);
        },
        (response) async {
          final user = response.user;
          final token = response.token;
          await storeToLocal(user: user!, token: token!);
          Appconfig().user = user;
          Appconfig().token = token;
          state = state.copyWith(
            authState: .loginSuccess,
            isAuthenticated: true,
            user: user,
            authToken: token,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        authState: .loginFailed,
      );
    }
  }

  Future<void> register({
    required String name,
    required String lastname,
    required String username,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = state.copyWith(authState: .registering);

    try {
      final response = await repo.register(
        name: name,
        lastname: lastname,
        username: username,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            authState: .registerFailed,
          );
        },
        (response) async {
          Appconfig().user = response.user;
          Appconfig().token = response.token;

          await storeToLocal(user: response.user!, token: response.token!);
          state = state = state.copyWith(
            authState: .registerSuccess,
            user: Appconfig().user,
            authToken: Appconfig().token,
            isAuthenticated: true,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(error: e.toString(), statusCode: 400),
        authState: .registerFailed,
      );
    }
  }

  Future<void> logoutStateUpdate() async {
    Appconfig().user = null;
    Appconfig().token = null;

    final keys = prefs?.getKeys() ?? {};
    if (keys.isNotEmpty) {
      for (String key in keys) {
        if (key != Constants.appLanguage) {
          await prefs?.remove(key);
        }
      }
    }
    state = state.copyWith(
      authState: .logoutSuccess,
      isAuthenticated: false,
      user: null,
    );
  }

  Future<void> loginWithNumber(String phone) async {
    try {
      state = state.copyWith(authState: .gettingOtp);

      final response = await repo.login({"phone": phone});

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            authState: .gettingOtpFaild,
          );
        },
        (response) {
          state = state.copyWith(authState: .getOtpSuccess);
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        authState: .gettingOtpFaild,
      );
    }
  }

  Future<void> verifyCode(String phone, String otp) async {
    try {
      state = state.copyWith(authState: .verifyingCode);

      final response = await repo.verifyCode({"phone": phone, "otp": otp});

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            authState: .verifyCodeFaild,
          );
        },
        (response) async {
          Appconfig().user = response.user;
          Appconfig().token = response.token;

          await storeToLocal(user: response.user!, token: response.token!);
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        authState: .verifyCodeFaild,
      );
    }
  }

  Future<void> getAuthedUser() async {
    try {
      state = state.copyWith(authState: .loadingProfile);

      final response = await repo.getAuthedUser();

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            authState: .loadingProfileFaild,
          );
        },
        (response) async {
          if (response.user != null) {
            Appconfig().user = response.user;
            await storeAuthinLocalStorage(Appconfig().token!, response.user!);
            state = state = state.copyWith(
              authState: .loadingProfileSuccess,
              user: response.user!,
              authToken: Appconfig().token,
            );
          }
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        authState: .loadingProfileFaild,
      );
    }
  }

  Future<void> storeToLocal({required User user, required String token}) async {
    await storeAuthinLocalStorage(token, user);
  }

  Future<void> changeStateToAuth({
    required User user,
    required String token,
  }) async {
    await storeAuthinLocalStorage(token, user);
    Appconfig().user = user;
    Appconfig().token = token;
    state = state = state.copyWith(
      user: Appconfig().user,
      authToken: Appconfig().token,
      isAuthenticated: true,
    );
  }

  Future<void> storeAuthinLocalStorage(String authToken, User user) async {
    await prefs?.setString(Constants.authToken, authToken);

    final userMap = user.toJson();
    final userJson = jsonEncode(userMap);
    await prefs?.setString(Constants.user, userJson);
  }

  void getAuthFromLocalStorage() {
    final token = prefs?.getString(Constants.authToken);
    final json = prefs?.getString(Constants.user);
    final appLang = prefs?.getString(Constants.appLanguage);
    Appconfig().appLang = appLang;

    if (json != null && token != null) {
      final userMap = jsonDecode(json);
      final user = User.fromJson(userMap);

      Appconfig().user = user;
      Appconfig().token = token;
    }
  }

  Future<void> updateProfile(Map<String, Object?> body) async {
    try {
      state = state.copyWith(authState: .updatingProfile);

      final response = await repo.updateProfile(body);

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            authState: .updatingFailed,
          );
        },
        (response) async {
          await storeToLocal(user: response.user!, token: Appconfig().token!);

          state = state.copyWith(
            authState: .updatingSuccess,
            user: response.user,
            authToken: Appconfig().token,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        authState: .updatingFailed,
      );
    }
  }

  Future<void> changePassword(Map<String, Object?> body) async {
    try {
      state = state.copyWith(authState: .updatingPassword);

      final response = await repo.changePassword(body);

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            authState: .updatingPasswordFailed,
          );
        },
        (response) async {
          state = state.copyWith(authState: .updatingPasswordSuccess);
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        authState: .updatingPasswordFailed,
      );
    }
  }
}

class AuthProviderState extends Equatable {
  final String? authToken;
  final User? user;
  final bool isAuthenticated;
  final AuthState authState;
  final ErrorModel? errorMessage;

  const AuthProviderState({
    this.authToken,
    this.user,
    this.isAuthenticated = false,
    this.authState = AuthState.idle,
    this.errorMessage,
  });

  const AuthProviderState.initial()
    : authState = .idle,
      isAuthenticated = false,
      user = null,
      authToken = null,
      errorMessage = null;

  AuthProviderState copyWith({
    String? authToken,
    User? user,
    bool? isAuthenticated,
    AuthState? authState,
    ErrorModel? errorMessage,
  }) {
    return AuthProviderState(
      authToken: authToken ?? this.authToken,
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      authState: authState ?? this.authState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isAuthenticated,
    user,
    authState,
    errorMessage,
    authToken,
  ];
}

enum AuthState {
  idle,
  getOtpSuccess,
  gettingOtp,
  gettingOtpFaild,
  verifyingCodeSuccess,
  verifyingCode,
  verifyCodeFaild,
  errorMessage,

  loadingProfile,
  loadingProfileFaild,
  loadingProfileSuccess,

  // logout
  loggingOut,
  logOutFailed,
  logoutSuccess,
  //login
  loggingin,
  loginFailed,
  loginSuccess,

  updatingProfile,
  updatingFailed,
  updatingSuccess,
  // register
  registering,
  registerFailed,
  registerSuccess,

  //change password
  updatingPassword,
  updatingPasswordFailed,
  updatingPasswordSuccess,
}
