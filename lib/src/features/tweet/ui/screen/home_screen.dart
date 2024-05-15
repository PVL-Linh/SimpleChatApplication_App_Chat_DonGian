import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tweet_app/src/features/tweet/store/home_store.dart';
import 'package:tweet_app/src/features/tweet/submodules/feed/feed_module.dart';
import 'package:tweet_app/src/features/tweet/submodules/search/search_module.dart';
import 'package:tweet_app/src/features/tweet/ui/components/custom_drawer.dart';

import '../../submodules/listChat/ListChat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeStore homeStore;

  @override
  void initState() {
    homeStore = Modular.get<HomeStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[900],
        automaticallyImplyLeading: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchModule(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Modular.to.pushNamed('/tweet/addTweet/');
        },
        child: const Icon(Icons.add),
      ),
      body: Observer(
        builder: (_) => PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: homeStore.pageViewController,
          children: [
            FeedModule(),
            SearchModule(),
            ChatUsersList(),
          ],
        ),
      ),
      bottomNavigationBar: Observer(
        builder: (_) => BottomNavigationBar(
          currentIndex: homeStore.currentPage,
          onTap: (index) {
            homeStore.changeCurrentPage(index);
          },
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_rounded),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              label: 'Chat',
            ),
          ],
        ),
      ),
    );
  }

}