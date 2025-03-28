import 'package:flutter/material.dart';

class AllFeedScreen extends StatelessWidget {
  final List<FeedItem> feedItems;
  final String currentUserAvatar;

  const AllFeedScreen({
    super.key,
    required this.feedItems,
    required this.currentUserAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Posts"),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[200],
        child: feedItems.isEmpty
            ? const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 48,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Text(
                  'No posts yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Share your progress with friends',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        )
            : ListView.builder(
          itemCount: feedItems.length,
          itemBuilder: (context, index) {
            final item = feedItems[index];
            return Column(
              children: [
                _buildFeedItem(item),
                if (index < feedItems.length - 1)
                  Divider(
                    height: 0.5,
                    color: Colors.grey[300],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeedItem(FeedItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(item.authorAvatar),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.timeAgo,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // todo Handle post options
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.content,
            style: const TextStyle(fontSize: 14),
          ),
          if (item.imageUrl != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  item.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: item.isLiked ? Colors.red : Colors.grey[600],
                ),
                onPressed: () {
                  // todo Handle like
                },
              ),
              Text(
                '${item.likes}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FeedItem {
  final String authorName;
  final String authorAvatar;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  final int likes;
  final bool isLiked;

  const FeedItem({
    required this.authorName,
    required this.authorAvatar,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    required this.likes,
    this.isLiked = false,
  });
}
