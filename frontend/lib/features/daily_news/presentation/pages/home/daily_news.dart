import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import '../../../domain/entities/article.dart';
import '../../widgets/article_tile.dart';

class DailyNews extends StatelessWidget {
  const DailyNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPage(context);
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Daily News',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        GestureDetector(
          onTap: () => _onShowSavedArticlesViewTapped(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Icon(Icons.bookmark, color: Colors.black),
          ),
        ),
      ],
    );
  }

  /// ✅ Now listens to both Remote & Local Articles
  _buildPage(BuildContext context) {
    return BlocBuilder<RemoteArticlesBloc, RemoteArticlesState>(
      builder: (context, remoteState) {
        return BlocBuilder<LocalArticleBloc, LocalArticlesState>(
          builder: (context, localState) {
            if (remoteState is RemoteArticlesLoading) {
              return Scaffold(
                appBar: _buildAppbar(context),
                body: const Center(child: CupertinoActivityIndicator()),
              );
            }

            if (remoteState is RemoteArticlesError) {
              return Scaffold(
                appBar: _buildAppbar(context),
                body: const Center(child: Icon(Icons.refresh)),
              );
            }

            // ✅ Merge Remote & Submitted Articles
            List<ArticleEntity> articles = [];
            if (remoteState is RemoteArticlesDone) {
              articles.addAll(remoteState.articles ?? []);
            }
            if (localState is LocalArticlesDone) {
              articles.addAll(localState.articles);
            }

            return _buildArticlesPage(context, articles);
          },
        );
      },
    );
  }

  Widget _buildArticlesPage(
      BuildContext context, List<ArticleEntity> articles) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: articles.isEmpty
          ? const Center(child: Text("No articles available."))
          : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ArticleWidget(
                  article: article,
                  onArticlePressed: (article) =>
                      _onArticlePressed(context, article),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/AddArticle');
          if (result == true) {
            // ✅ Refresh articles when returning from AddArticlePage
            context.read<LocalArticleBloc>().add(GetSavedArticles());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }

  void _onShowSavedArticlesViewTapped(BuildContext context) {
    Navigator.pushNamed(context, '/SavedArticles');
  }
}
