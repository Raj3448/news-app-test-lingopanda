import 'package:flutter/material.dart';
import 'package:newshub/core/constant/font_text.dart';
import 'package:newshub/ui/home/pages/news_article_page.dart';
import 'package:newshub/view_models/news_model.dart';

class NewsComponent extends StatelessWidget {
  final Article article;
  const NewsComponent({required this.article, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsDetailsViewPage(article: article, isFav: false,),));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                      child: Text(
                        article.title ?? '',
                        style: AppFonts.bodyFont.copyWith(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 70,
                      child: Text(
                        article.description ?? '',
                        style: AppFonts.bodyFont,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                    fit: BoxFit.cover,
                    width: 110,
                    height: 110,
                    article.urlToImage ??
                        'https://t3.ftcdn.net/jpg/03/27/55/60/360_F_327556002_99c7QmZmwocLwF7ywQ68ChZaBry1DbtD.jpg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
