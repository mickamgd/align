import 'package:align/app/history/history_controller.dart';
import 'package:align/app/theme.dart';
import 'package:align/ui/history/widgets/history_card.dart';
import 'package:align/ui/shared/bottom_nav_bar.dart';
import 'package:align/ui/shared/firestore_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(userHistoryProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Historique',
                            style: AppTextStyles.displayMedium,
                          ),
                          const SizedBox(height: 20),

                          Text(
                            'Parties récentes',
                            style: AppTextStyles.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  historyAsync.when(
                    data: (games) {
                      if (games.isEmpty) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.history,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Aucune partie jouée',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final game = games[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: HistoryCard(game: game),
                            );
                          }, childCount: games.length),
                        ),
                      );
                    },
                    loading: () => const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, _) {
                      final msg = historyErrorMessage(error);

                      return SliverFillRemaining(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 56,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  msg.title,
                                  style: AppTextStyles.headlineSmall,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  msg.body,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                OutlinedButton(
                                  onPressed: () =>
                                      ref.invalidate(userHistoryProvider),
                                  child: const Text('Réessayer'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ),
            ),
            const BottomNavBar(currentRoute: '/history'),
          ],
        ),
      ),
    );
  }
}
