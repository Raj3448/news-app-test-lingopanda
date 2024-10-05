import 'package:flutter/material.dart';
import 'package:newshub/core/constant/app_colors.dart';
import 'package:newshub/core/constant/font_text.dart';
import 'package:newshub/core/services/news_service.dart';
import 'package:newshub/providers/country_code_provider.dart';
import 'package:newshub/ui/home/components/news_component.dart';
import 'package:newshub/ui/widgets/loading_widget.dart';
import 'package:newshub/view_models/news_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              Selector<CountryCodeProvider,String>(
                selector: (countryCode, countryProvider) => countryProvider.countryCode,
                builder: (context,countryCode,child) {
                  return Text(
                    countryCode.toUpperCase(),
                    style: AppFonts.titleFont
                        .copyWith(color: AppColors.textColorWhite, fontSize: 18),
                  );
                }
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
          future: NewsService.fetchTopHeadlines(context),
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
            final List<Article> articles = snapshot.data!.getOrElse(
              (l) => [],
            );
            if (articles.isEmpty) {
              return const Center(
                child: Text("Don't have articles"),
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
          }),
    );
  }
}
