import 'package:flutter/material.dart';
import 'package:flutter_animation_practice/src/animated_tabbar_scroll/model/music_category.dart';
import 'package:flutter_animation_practice/src/animated_tabbar_scroll/music_controller.dart';

class CustomScrollableTabBar extends StatefulWidget {
  const CustomScrollableTabBar({super.key});

  @override
  State<CustomScrollableTabBar> createState() => _CustomScrollableTabBarState();
}

class _CustomScrollableTabBarState extends State<CustomScrollableTabBar>
    with SingleTickerProviderStateMixin {
  final _controller = MusicControlelr();

  @override
  void initState() {
    super.initState();
    _controller.init(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => SafeArea(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                height: 60,
                child: TabBar(
                  onTap: _controller.onCategorySelected,
                  controller: _controller.tabController,
                  isScrollable: true,
                  indicatorWeight: .1,
                  indicatorColor: Colors.transparent,
                  tabs: _controller.tabs
                      .map((e) => _TabBarWidgetView(tabCategory: e))
                      .toList(),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _controller.items.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  controller: _controller.scrollController,
                  itemBuilder: (context, index) {
                    final item = _controller.items[index];
                    if (item.isCategory) {
                      return _MusicCategoryItem(
                        category: item.category!,
                      );
                    } else {
                      return _MusicListItem(
                        albumDetail: item.albumDetail!,
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _MusicCategoryItem extends StatelessWidget {
  const _MusicCategoryItem({required this.category});

  final MusicCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: categoryHeight,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
      ),
      child: Text(
        category.name,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _MusicListItem extends StatelessWidget {
  const _MusicListItem({required this.albumDetail});

  final AlbumDetail albumDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: albumHeight,
      color: Colors.white24,
      child: Card(
        elevation: 6,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Image.asset(
                albumDetail.image,
                height: 80,
                width: 80,
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      albumDetail.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      albumDetail.description,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 10.0,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      '\$${albumDetail.price}',
                      style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBarWidgetView extends StatelessWidget {
  const _TabBarWidgetView({required this.tabCategory});

  final MusicTabCategory tabCategory;
  @override
  Widget build(BuildContext context) {
    final selected = tabCategory.selected;
    return Opacity(
      opacity: selected ? 1 : .5,
      child: Card(
        elevation: selected ? 6 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tabCategory.category.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
