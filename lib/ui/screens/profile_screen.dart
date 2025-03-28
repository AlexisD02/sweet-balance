import 'package:flutter/material.dart';
import 'package:sweet_balance/ui/screens/all_feed_screen.dart';

import '../../models/friend_model.dart';
import '../widgets/infoCards/account_info_card.dart';
import '../widgets/collapsible_header.dart';
import '../widgets/infoCards/feed_info_card.dart';
import '../widgets/infoCards/friends_info_card.dart';
import '../widgets/popup_menu.dart';
import '../widgets/profile_visibility.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(250.0);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: CustomScrollView(
        controller: _scrollController,
        slivers: const [
          CollapsibleHeader(
            title: "My Page",
            actions: [
              PopupMenuWidget(),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: ProfileVisibilityCard(),
            ),
          ),

          AccountInfoCard(
            height: 200,
            userName: 'Jane Smith',
            userEmail: 'jane.smith@example.com',
            userPhone: '+1 234 567 8901',
            userAddress: '1234 Elm Street, Springfield, USA',
            avatarUrl: 'https://i.pravatar.cc/300',
          ),

          FriendsCard(
            friends: [
              Friend(
                name: 'John Doe',
                avatarUrl: 'https://i.pravatar.cc/150?img=1',
                status: 'Online',
              ),
              Friend(
                name: 'Sarah Johnson',
                avatarUrl: 'https://i.pravatar.cc/150?img=2',
                status: 'Last seen 2h ago',
              ),
              Friend(
                name: 'Sarah Johnson',
                avatarUrl: 'https://i.pravatar.cc/150?img=2',
                status: 'Last seen 2h ago',
              ),
            ],
          ),

          FeedCard(
            feedItems: [
              FeedItem(
                authorName: 'Jane Smith',
                authorAvatar: 'https://i.pravatar.cc/300',
                timeAgo: '2 hours ago',
                content: 'Maintained my sugar levels under 140 for a whole week! 🎉',
                likes: 24,
                isLiked: true,
              ),
              FeedItem(
                authorName: 'Jane Smith',
                authorAvatar: 'https://i.pravatar.cc/300',
                timeAgo: 'Yesterday',
                content: 'Started using a new glucose meter today. Really liking it so far!',
                likes: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
