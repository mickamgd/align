import 'package:align/app/game/game_config.dart';
import 'package:align/app/game/game_controller.dart';
import 'package:align/app/home/home_providers.dart';
import 'package:align/app/online/online_game_controller.dart';
import 'package:align/app/profile/profile_controller.dart';
import 'package:align/app/router.dart';
import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:align/domain/profile/emoji_catalog.dart';
import 'package:align/ui/home/widgets/game_mode_carousel.dart';
import 'package:align/ui/home/widgets/size_selector.dart';
import 'package:align/ui/shared/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSize = ref.watch(selectedSizeProvider);

    // Cartes de modes de jeu
    final gameCards = [
      GameModeCard(
        title: 'Multijoueur',
        subtitle: '8.472 Online',
        color: const Color(0xFFF4A23A),
        image: 'assets/images/games_background/pvp-online.png',
        onTap: () {
          // Navigate to online lobby with selected size
          context.push(
            '${Routes.home}/${Routes.onlineLobby}?size=$selectedSize',
          );
        },
      ),
      GameModeCard(
        title: 'Local',
        subtitle: 'Même appareil',
        color: AppColors.purple,
        image: 'assets/images/games_background/pvp-local.png',
        onTap: () {
          // Reset online controller before starting local game
          ref.read(onlineGameControllerProvider.notifier).reset();

          final newGameConfig = GameConfig(
            size: selectedSize,
            mode: GameMode.pvp,
            difficulty: BotDifficulty.easy,
          );
          ref.read(gameControllerProvider.notifier).startNewGame(newGameConfig);
          context.push('${Routes.home}/${Routes.game}');
        },
      ),
      GameModeCard(
        title: 'Bot Facile',
        subtitle: 'Entraînez-vous',
        color: AppColors.greenLight,
        image: 'assets/images/games_background/easy-bot.png',
        onTap: () {
          // Reset online controller before starting local game
          ref.read(onlineGameControllerProvider.notifier).reset();

          final newGameConfig = GameConfig(
            size: selectedSize,
            mode: GameMode.pve,
            difficulty: BotDifficulty.easy,
          );
          ref.read(gameControllerProvider.notifier).startNewGame(newGameConfig);
          context.push('${Routes.home}/${Routes.game}');
        },
      ),
      GameModeCard(
        title: 'Bot Moyen',
        subtitle: 'Entraînez-vous',
        color: Colors.orangeAccent,
        image: 'assets/images/games_background/medium-bot.png',
        onTap: () {
          // Reset online controller before starting local game
          ref.read(onlineGameControllerProvider.notifier).reset();

          final newGameConfig = GameConfig(
            size: selectedSize,
            mode: GameMode.pve,
            difficulty: BotDifficulty.medium,
          );
          ref.read(gameControllerProvider.notifier).startNewGame(newGameConfig);
          context.push('${Routes.home}/${Routes.game}');
        },
      ),
      GameModeCard(
        title: 'Bot Hardcore',
        subtitle: 'Entraînez-vous',
        color: Colors.redAccent,
        image: 'assets/images/games_background/hardcore-bot.png',
        onTap: () {
          // Reset online controller before starting local game
          ref.read(onlineGameControllerProvider.notifier).reset();

          final newGameConfig = GameConfig(
            size: selectedSize,
            mode: GameMode.pve,
            difficulty: BotDifficulty.hard,
          );
          ref.read(gameControllerProvider.notifier).startNewGame(newGameConfig);
          context.push('${Routes.home}/${Routes.game}');
        },
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            _buildHeader(context, ref),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choisissez\nun mode',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.black,
                      height: 1.0,
                      letterSpacing: -2,
                    ),
                  ),
                  const Spacer(),
                  SizeSelector(selectedSize: selectedSize),
                ],
              ),
            ),

            // Carousel de modes de jeu
            Expanded(child: GameModeCarousel(cards: gameCards)),

            // Bottom Navigation Bar
            const BottomNavBar(currentRoute: '/home'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppBorderRadius.radiusXXL,
            boxShadow: AppShadows.standard,
          ),
          child: Padding(
            padding: AppSpacing.paddingSM,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.purple,
                  radius: 17.0,
                  child: Text(
                    emojiCatalog[ref
                            .watch(profileControllerProvider)
                            .profile
                            ?.emojiIndex ??
                        0],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    ref.watch(profileControllerProvider).profile?.displayName ??
                        'Utilisateur',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),

        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppBorderRadius.radiusXXL,
            boxShadow: AppShadows.standard,
          ),
          child: const Padding(
            padding: AppSpacing.paddingSM,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    '#1',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: AppColors.draw,
                  radius: 17.0,
                  child: Icon(Icons.leaderboard),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
