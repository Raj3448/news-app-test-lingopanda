import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:newshub/core/constant/app_colors.dart';
import 'package:newshub/core/constant/font_text.dart';
import 'package:newshub/core/services/news_service.dart';
import 'package:newshub/providers/country_code_provider.dart';
import 'package:newshub/ui/home/components/news_component.dart';
import 'package:newshub/ui/widgets/loading_widget.dart';
import 'package:newshub/view_models/news_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool articleLoaded = false;
  bool isFABOpen = false;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _toggleFAB() {
    if (isFABOpen) {
      _fabController.reverse();
    } else {
      _fabController.forward();
    }
    setState(() {
      isFABOpen = !isFABOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'My News',
          style: AppFonts.titleFont.copyWith(color: AppColors.textColorWhite),
        ),
        actions: [
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.textColorWhite),
              Selector<CountryCodeProvider, String>(
                selector: (countryCode, countryProvider) =>
                    countryProvider.countryCode,
                builder: (context, countryCode, child) {
                  return Text(
                    countryCode.toUpperCase(),
                    style: AppFonts.titleFont.copyWith(
                        color: AppColors.textColorWhite, fontSize: 18),
                  );
                },
              )
            ],
          ),
          const SizedBox(
            width: 10,
          )
        ],
        backgroundColor: AppColors.primaryColor,
      ),
      body: FutureBuilder(
        future: articleLoaded ? null : NewsService.fetchTopHeadlines(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingWidget(
                showShadow: false,
              ),
            );
          }
          if (snapshot.hasError ||
              (snapshot.data?.isLeft() ?? true) ||
              !snapshot.hasData) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          final List<Article> articles = snapshot.data!.getOrElse((l) => []);
          if (articles.isEmpty) {
            return const Center(
              child: Text("Don't have articles"),
            );
          }
          articleLoaded = true;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 0)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 20, bottom: 10),
                      child: Text(
                        'Top Headlines',
                        style: AppFonts.bodyFont.copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  NewsComponent(article: article),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (isFABOpen) ...[
          _buildSmallFAB('assets/animations/saved.json', 'Saved', 1, () {}),
          _buildSmallFAB(
              'assets/animations/favorite.json', 'Favorite', 2, () {}),
        ],
        FloatingActionButton(
          onPressed: _toggleFAB,
          backgroundColor: AppColors.primaryColor,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _fabController,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallFAB(
      String imagePath, String label, int position, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.only(bottom: (position * 70.0)),
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _fabController,
          curve: Curves.easeInOut,
        ),
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: AppColors.primaryColor,
          heroTag: label,
          child: LottieBuilder.asset(
            imagePath,
            repeat: false,
          ),
        ),
      ),
    );
  }
}
