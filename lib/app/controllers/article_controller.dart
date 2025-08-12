import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/models/article_model.dart';

class ArticleController extends GetxController {
  final _currentArticle = Rxn<Article>();
  Article? get currentArticle => _currentArticle.value;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Article) {
      _currentArticle.value = Get.arguments as Article;
    }
  }

  Future<void> openArticleUrl() async {
    if (currentArticle?.url != null) {
      final url = Uri.parse(currentArticle!.url!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open article URL',
          duration: Duration(seconds: 2),
        );
      }
    }
  }

  void shareArticle() {
    Get.snackbar(
      'Share',
      'Share functionality would be implemented here',
      duration: Duration(seconds: 2),
    );
  }
}
