import 'dart:io'; // ✅ Import to handle local images
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.only(
            start: 14, end: 14, bottom: 7, top: 7),
        height: MediaQuery.of(context).size.width / 2.2,
        child: Row(
          children: [
            _buildImage(context),
            _buildTitleAndDescription(),
            _buildRemovableArea(context),
          ],
        ),
      ),
    );
  }

  // ✅ Modified _buildImage to support both local and URL images
  Widget _buildImage(BuildContext context) {
    final imageUrl = article!.urlToImage;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      // Check if the image URL is a local file path or a remote URL
      if (imageUrl.startsWith('http')) {
        // If it's a URL, use CachedNetworkImage
        return CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) => Padding(
            padding: const EdgeInsetsDirectional.only(end: 14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.08),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
              ),
            ),
          ),
          progressIndicatorBuilder: (context, url, downloadProgress) => Padding(
            padding: const EdgeInsetsDirectional.only(end: 14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: double.maxFinite,
                child: CupertinoActivityIndicator(),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.08),
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Padding(
            padding: const EdgeInsetsDirectional.only(end: 14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: double.maxFinite,
                child: Icon(Icons.error),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.08),
                ),
              ),
            ),
          ),
        );
      } else {
        // If it's a local file path, use FileImage
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 14),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              height: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.08),
                image: DecorationImage(
                  image: FileImage(File(imageUrl)), // ✅ Handle local file
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      }
    } else {
      // If there's no image, show a placeholder
      return Padding(
        padding: const EdgeInsetsDirectional.only(end: 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
            height: double.maxFinite,
            color: Colors.grey.withOpacity(0.2), // Placeholder color
            child: Icon(Icons.image), // Placeholder icon
          ),
        ),
      );
    }
  }

  Widget _buildTitleAndDescription() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              article!.title ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Butler',
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),

            // Description
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  article!.description ?? '',
                  maxLines: 2,
                ),
              ),
            ),

            // Datetime
            Row(
              children: [
                const Icon(Icons.timeline_outlined, size: 16),
                const SizedBox(width: 4),
                Text(
                  article!.publishedAt!,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemovableArea(BuildContext context) {
    if (isRemovable == true) {
      return GestureDetector(
        onTap: () => _onRemove(context), // ✅ Pass context explicitly
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.remove_circle_outline, color: Colors.red),
        ),
      );
    }
    return Container();
  }

  void _onTap() {
    if (onArticlePressed != null) {
      onArticlePressed!(article!);
    }
  }

  void _onRemove(BuildContext context) {
    if (onRemove != null) {
      onRemove!(article!); // ✅ Call the remove function

      // ✅ Show a confirmation message when article is removed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Article removed")),
      );
    }
  }
}
