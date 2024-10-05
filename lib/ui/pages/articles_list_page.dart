import 'package:flutter/material.dart';
import 'package:newshub/core/constant/app_colors.dart';
import 'package:newshub/core/constant/font_text.dart';
import 'package:newshub/core/services/news_service.dart';
import 'package:newshub/ui/home/components/news_component.dart';
import 'package:newshub/ui/widgets/loading_widget.dart';
import 'package:newshub/view_models/news_model.dart';

class ArticlesListPage extends StatelessWidget {
  final bool showSaved;
  const ArticlesListPage({
    required this.showSaved,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'My ${showSaved ? 'Saved' : 'Favorite'} News',
          style: AppFonts.titleFont.copyWith(color: AppColors.textColorWhite),
        ),
      ),
      body: FutureBuilder(
        future: showSaved
            ? NewsService().fetchSavedArticles()
            : NewsService().fetchFavArticles(),
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
            return Center(
              child: Text(
                  "You don't have ${showSaved ? 'saved' : 'favorite'} articles"),
            );
          }
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
                        showSaved ? 'Saved News' : 'Favorite News',
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
    );
  }
}
