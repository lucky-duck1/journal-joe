import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../../injection_container.dart';
import '../../../domain/entities/article.dart';
import '../../bloc/article/local/local_article_bloc.dart';
import '../../bloc/article/local/local_article_event.dart';
import '../../bloc/article/local/local_article_state.dart';
import '../../bloc/article/remote/remote_article_bloc.dart';
import '../../bloc/article/remote/remote_article_state.dart';
import '../../bloc/article/remote/remote_article_event.dart';
import '../../widgets/article_tile.dart';

class SavedArticles extends HookWidget {
  const SavedArticles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<LocalArticleBloc>()..add(const GetSavedArticles()),
        ),
        BlocProvider(
          create: (_) => sl<RemoteArticlesBloc>()..add(const GetArticles()),
        ),
      ],
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: Builder(
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _onBackButtonTapped(context),
          child: const Icon(Ionicons.chevron_back, color: Colors.black),
        ),
      ),
      title:
          const Text('Saved Articles', style: TextStyle(color: Colors.black)),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<RemoteArticlesBloc, RemoteArticlesState>(
      builder: (context, remoteState) {
        return BlocBuilder<LocalArticleBloc, LocalArticlesState>(
          builder: (context, localState) {
            if (remoteState is RemoteArticlesLoading ||
                localState is LocalArticlesLoading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (remoteState is RemoteArticlesDone &&
                localState is LocalArticlesDone) {
              final articles = [
                ...localState.articles,
                ...remoteState.articles!
              ];
              return _buildArticlesList(articles);
            } else if (remoteState is RemoteArticlesError ||
                localState is LocalArticlesError) {
              return const Center(child: Text("Error loading articles"));
            }
            return const Center(child: Text("No articles available"));
          },
        );
      },
    );
  }

  Widget _buildArticlesList(List<ArticleEntity> articles) {
    if (articles.isEmpty) {
      return const Center(
          child: Text(
        'NO SAVED ARTICLES',
        style: TextStyle(color: Colors.black),
      ));
    }

    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return ArticleWidget(
          article: articles[index],
          isRemovable: true,
          onRemove: (article) => _onRemoveArticle(context, article),
          onArticlePressed: (article) => _onArticlePressed(context, article),
        );
      },
    );
  }

  void _onBackButtonTapped(BuildContext context) {
    Navigator.pop(context);
  }

  void _onRemoveArticle(BuildContext context, ArticleEntity article) {
    final bloc = BlocProvider.of<LocalArticleBloc>(context);
    bloc.add(RemoveArticle(article)); // ✅ Remove the article
    bloc.add(GetSavedArticles()); // ✅ Refresh the list dynamically
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }
}
