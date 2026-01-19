import 'package:align/app/auth/auth_controller.dart';
import 'package:align/app/profile/profile_controller.dart';
import 'package:align/ui/auth/login_screen.dart';
import 'package:align/ui/auth/onboarding_screen.dart';
import 'package:align/ui/auth/signup_flow/signup_flow_screen.dart';
import 'package:align/ui/game/game_screen.dart';
import 'package:align/ui/history/history_screen.dart';
import 'package:align/ui/home/home_screen.dart';
import 'package:align/ui/online/online_lobby_screen.dart';
import 'package:align/ui/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Notifier pour rafraîchir le router quand l'état d'auth ou profil change
class _GoRouterRefreshNotifier extends ChangeNotifier {
  _GoRouterRefreshNotifier(this._ref) {
    // Écouter auth ET profile
    _subAuth = _ref.listen(authControllerProvider, (_, _) => notifyListeners());
    _subProfile = _ref.listen(
      profileControllerProvider,
      (_, _) => notifyListeners(),
    );
  }

  late final ProviderSubscription _subAuth;
  late final ProviderSubscription _subProfile;

  final Ref _ref;

  @override
  void dispose() {
    _subAuth.close();
    _subProfile.close();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _GoRouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: Routes.onboarding,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final profileState = ref.read(profileControllerProvider);

      final loc = state.matchedLocation;

      final isAuthRoute =
          loc == Routes.onboarding ||
          loc == Routes.login ||
          loc == Routes.signup;

      // Auth encore en chargement -> ne rien faire
      if (authState.isLoading) return null;

      // Non authentifié -> onboarding (sauf si déjà sur une route auth)
      if (!authState.isAuthenticated) {
        return isAuthRoute ? null : Routes.onboarding;
      }

      // Auth OK, profil en chargement -> attendre
      if (profileState.isLoading) return null;

      final hasProfile = profileState.profile != null;

      // Auth OK mais profil manquant -> forcer signup (profile completion)
      if (!hasProfile) {
        return loc == Routes.signup ? null : Routes.signup;
      }

      // 5) Auth + profil OK -> si sur une route auth, renvoyer sur home
      if (isAuthRoute) return Routes.home;

      return null;
    },
    routes: [
      GoRoute(
        path: Routes.onboarding,
        name: RouteNames.onboarding,
        pageBuilder: (context, state) =>
            const MaterialPage(child: OnboardingScreen()),
      ),
      GoRoute(
        path: Routes.login,
        name: RouteNames.login,
        pageBuilder: (context, state) =>
            const MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        path: Routes.signup,
        name: RouteNames.signup,
        pageBuilder: (context, state) =>
            const MaterialPage(child: SignupFlowScreen()),
      ),
      GoRoute(
        path: Routes.home,
        name: RouteNames.home,
        pageBuilder: (context, state) =>
            const MaterialPage(child: HomeScreen()),
        routes: [
          // Routes enfants qui se pushent par-dessus
          GoRoute(
            path: Routes.game,
            name: RouteNames.game,
            pageBuilder: (context, state) =>
                const MaterialPage(child: GameScreen()),
          ),
          GoRoute(
            path: Routes.onlineLobby,
            name: RouteNames.onlineLobby,
            pageBuilder: (context, state) {
              final size = state.uri.queryParameters['size'];
              return MaterialPage(
                child: OnlineLobbyScreen(
                  selectedSize: int.tryParse(size ?? '3') ?? 3,
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: Routes.history,
        name: RouteNames.history,
        pageBuilder: (context, state) =>
            const MaterialPage(child: HistoryScreen()),
      ),
      GoRoute(
        path: Routes.settings,
        name: RouteNames.settings,
        pageBuilder: (context, state) =>
            const MaterialPage(child: SettingsScreen()),
      ),
    ],
  );
});

abstract final class Routes {
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const history = '/history';
  static const settings = '/settings';

  // nested
  static const game = 'game';
  static const onlineLobby = 'online-lobby';
}

abstract final class RouteNames {
  static const onboarding = 'onboarding';
  static const login = 'login';
  static const signup = 'signup';
  static const home = 'home';
  static const game = 'game';
  static const onlineLobby = 'online-lobby';
  static const history = 'history';
  static const settings = 'settings';
}
