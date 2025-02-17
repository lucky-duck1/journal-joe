import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/article.dart';

class ArticleWidget extends StatelessWidget {
  final ArticleEntity? article;
  final bool? isRemovable;
  final void Function(ArticleEntity article)? onRemove;
  final void Function(ArticleEntity article)? onArticlePressed;

  const ArticleWidget({
    Key? key,
    this.article,
    this.onArticlePressed,
    this.isRemovable = false,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrapping the Card with InkWell gives us the ripple effect while keeping the material look.
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip
          .antiAlias, // Ensures the ripple effect is confined within the card.
      child: InkWell(
        onTap: _onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          height: MediaQuery.of(context).size.width / 2.2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(context),
              const SizedBox(width: 12),
              Expanded(child: _buildTitleAndDescription()),
              _buildRemovableArea(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final imageUrl = article?.urlToImage;
    final imageWidth = MediaQuery.of(context).size.width / 3;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: imageWidth,
            height: double.infinity,
            color: Colors.grey.withOpacity(0.1),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.withOpacity(0.1),
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
        );
      } else if (imageUrl.startsWith('data:')) {
        final parts = imageUrl.split(',');
        if (parts.length == 2) {
          final bytes = base64Decode(parts[1]);
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: imageWidth,
              height: double.infinity,
              child: Image.memory(bytes, fit: BoxFit.cover),
            ),
          );
        }
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: imageWidth,
        height: double.infinity,
        color: Colors.grey.withOpacity(0.1),
        child: const Icon(Icons.image, color: Colors.grey),
      ),
    );
  }

  Widget _buildTitleAndDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article?.title ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Butler',
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Text(
            article?.description ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              article?.publishedAt ?? '',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRemovableArea(BuildContext context) {
    if (isRemovable == true) {
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Colors.red[400],
            size: 24,
          ),
          onPressed: () => _onRemove(context),
        ),
      );
    }
    return Container();
  }

  void _onTap() {
    if (onArticlePressed != null && article != null) {
      onArticlePressed!(article!);
    }
  }

  void _onRemove(BuildContext context) {
    if (onRemove != null && article != null) {
      onRemove!(article!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Article removed")),
      );
    }
  }
}
