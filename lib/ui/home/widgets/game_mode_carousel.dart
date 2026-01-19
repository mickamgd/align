import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Provider pour l'index de la page sélectionnée
final selectedCarouselIndexProvider =
    NotifierProvider<_SelectedIndexNotifier, int>(_SelectedIndexNotifier.new);

class _SelectedIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

class GameModeCard {
  const GameModeCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.image,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final Color color;
  final String image;
  final VoidCallback? onTap;
}

class GameModeCarousel extends ConsumerStatefulWidget {
  const GameModeCarousel({
    required this.cards,
    super.key,
    this.height = 260,
    this.viewportFraction = 0.80,
  });

  final List<GameModeCard> cards;
  final double height;
  final double viewportFraction;

  @override
  ConsumerState<GameModeCarousel> createState() => _GameModeCarouselState();
}

class _GameModeCarouselState extends ConsumerState<GameModeCarousel> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: widget.viewportFraction);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.cards.length,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                ref
                    .read(selectedCarouselIndexProvider.notifier)
                    .setIndex(index);
              },
              itemBuilder: (context, index) => _CarouselCard(
                card: widget.cards[index],
                controller: _controller,
                index: index,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 20.0),
            child: SmoothPageIndicator(
              controller: _controller,
              count: widget.cards.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: AppColors.pink,
                spacing: 5.0,
                dotColor: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget pour une carte individuelle avec animation
class _CarouselCard extends StatelessWidget {
  const _CarouselCard({
    required this.card,
    required this.controller,
    required this.index,
  });

  final GameModeCard card;
  final PageController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scrollOffset = _getScrollOffset();

        final distance = scrollOffset.abs().clamp(0.0, 1.0);

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateZ(_calculateRotation(-scrollOffset))
            ..translateByDouble(0.0, _calculateTranslateY(distance), 0.0, 1.0)
            ..scaleByDouble(
              _calculateScale(distance),
              _calculateScale(distance),
              1.0,
              1.0,
            ),
          child: Opacity(opacity: _calculateOpacity(distance), child: child),
        );
      },
      child: _CardContent(card: card),
    );
  }

  /// Calcule la position de scroll de cette carte (-1.0 = avant, 0.0 = centre, 1.0 = après)
  double _getScrollOffset() {
    if (!controller.hasClients) {
      return 0.0;
    }

    final page = controller.page ?? controller.initialPage.toDouble();
    return page - index;
  }

  /// Translation verticale (cartes latérales descendent légèrement)
  double _calculateTranslateY(double distance) {
    return distance * 20.0; // Max 20px de décalage
  }

  /// Scale (cartes latérales rétrécissent)
  double _calculateScale(double distance) {
    return 1.0 - (distance * 0.1); // Max 10% de réduction
  }

  /// Opacité (cartes latérales s'assombrissent)
  double _calculateOpacity(double distance) {
    return 1.0 - (distance * 0.3); // Max 30% de transparence
  }

  /// Rotation sur l'axe Y (effet de profondeur 3D)
  double _calculateRotation(double scrollOffset) {
    // Rotation positive pour cartes à droite, négative pour cartes à gauche
    // Max ~11.5° (0.2 radians) pour un effet subtil de perspective
    return scrollOffset * 0.08;
  }
}

/// Contenu visuel d'une carte
class _CardContent extends StatelessWidget {
  const _CardContent({required this.card});

  final GameModeCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: card.color,
        borderRadius: BorderRadius.circular(50),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            bottom: -105,
            left: -80,
            child: SizedBox(
              width: 400,
              child: Image.asset(card.image, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    card.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    AppSpacing.horizontalSM,
                    Text(
                      card.subtitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    onPressed: card.onTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Jouer', style: AppTextStyles.labelMedium),
                        AppSpacing.horizontalSM,
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
