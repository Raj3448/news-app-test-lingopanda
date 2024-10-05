// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:newshub/core/constant/app_colors.dart';
import 'package:newshub/core/constant/font_text.dart';
import 'package:newshub/view_models/news_model.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class NewsDetailsViewPage extends StatefulWidget {
  final Article article;
  bool isFav;
  NewsDetailsViewPage({
    Key? key,
    required this.article,
    required this.isFav,
  }) : super(key: key);

  @override
  State<NewsDetailsViewPage> createState() => _NewsDetailsViewPageState();
}

class _NewsDetailsViewPageState extends State<NewsDetailsViewPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _savedController;
  bool isSaved = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _savedController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    if (widget.isFav) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _savedController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
              color: AppColors.primaryColor,
            )),
        centerTitle: true,
        title: Text('News Details', style: AppFonts.titleFont),
        actions: [
          GestureDetector(
            onTap: () {
              isSaved = !isSaved;

              if (isSaved) {
                _savedController.forward();
              } else {
                _savedController.reverse();
              }
            },
            child: LottieBuilder.asset(
              controller: _savedController,
              'assets/animations/saved.json',
              height: 50,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: widget.article.publishedAt,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            widget.article.urlToImage ??
                                'https://t3.ftcdn.net/jpg/03/27/55/60/360_F_327556002_99c7QmZmwocLwF7ywQ68ChZaBry1DbtD.jpg',
                            height: 200,
                            fit: BoxFit.cover,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: CustomPaint(
                              size: const Size(15, 15),
                              painter: DotPainter(color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (widget.article.author?.length ?? 46) > 45
                                      ? 'Raj Chavan'
                                      : widget.article.author!,
                                  style: AppFonts.bodyFont.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                                Text(
                                  DateFormat('E, dd/MM/yyyy')
                                      .format(widget.article.publishedAt),
                                  style: AppFonts.bodyFont.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              if (widget.isFav) {
                                _controller.forward();
                              } else {
                                _controller.reverse();
                              }
                              setState(() {
                                widget.isFav = !widget.isFav;
                              });
                            },
                            child: LottieBuilder.asset(
                              'assets/animations/favorite.json',
                              height: 65,
                              fit: BoxFit.cover,
                              controller: _controller,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        widget.article.title!,
                        style: AppFonts.bodyFont.copyWith(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      widget.article.description??'',
                      style: AppFonts.bodyFont,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: ElevatedButton(
                onPressed: _launchURL,
                style: const ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(Size(300, 70)),
                    backgroundColor:
                        WidgetStatePropertyAll(AppColors.primaryColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Read More  ',
                      style: AppFonts.buttonFont.copyWith(color: Colors.white),
                    ),
                    LottieBuilder.asset(
                      'assets/animations/rocket.json',
                      height: 50,
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }

  _launchURL() async {
    String url = widget.article.url!;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class DotPainter extends CustomPainter {
  final Color color;

  DotPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
