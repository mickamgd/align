import 'package:align/app/router.dart';
import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = const [
    OnboardingPage(
      image: 'assets/images/on_boarding/align.png',
      title: 'Alignes pour gagner',
      subtitle: 'Créé des alignements stratégiques pour remporter la victoire',
    ),
    OnboardingPage(
      image: 'assets/images/on_boarding/bots.png',
      title: 'Défies nos robots pour t\'entrainer',
      subtitle:
          'Affrontes nos robots pour t\'entrainer ou joues contre tes amis',
    ),
    OnboardingPage(
      image: 'assets/images/on_boarding/podium.png',
      title: 'Deviens le meilleur joueur',
      subtitle:
          'Suis tes parties et deviens le meilleur joueur au fil du temps !',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    if (_pageController.page != null) {
      final page = _pageController.page!.round();
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PageView Images en haut
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: AppSpacing.paddingHorizontalXXL,
                    child: Image.asset(
                      _pages[index].image,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: AppSpacing.paddingHorizontalXXL,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: AppColors.pink,
                  dotColor: AppColors.black,
                  dotHeight: AppSpacing.sm,
                  dotWidth: AppSpacing.sm,
                  expansionFactor: 4,
                  spacing: AppSpacing.sm,
                ),
              ),
            ),

            AppSpacing.verticalXXXL,

            Padding(
              padding: AppSpacing.paddingHorizontalXXL,
              child: AnimatedSwitcher(
                duration: AppDurations.medium,
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Column(
                  key: ValueKey<int>(_currentPage),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _pages[_currentPage].title,
                      style: AppTextStyles.displayMedium,
                      textAlign: TextAlign.left,
                    ),

                    AppSpacing.verticalLG,

                    // Sous-titre
                    Text(
                      _pages[_currentPage].subtitle,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.verticalXXXL,

            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                AppSpacing.xxl,
                AppSpacing.xxl,
                AppSpacing.massive,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => context.go(Routes.login),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.radiusMassive,
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Commencer', style: AppTextStyles.labelLarge),
                      AppSpacing.horizontalSM,
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String image;
  final String title;
  final String subtitle;

  const OnboardingPage({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}
