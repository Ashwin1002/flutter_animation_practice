import 'package:flutter/material.dart';

import 'model/music_category.dart';

const categoryHeight = 55.0;
const albumHeight = 110.0;

class MusicControlelr with ChangeNotifier {
  List<MusicTabCategory> tabs = [];

  List<AlbumItem> items = [];

  late TabController tabController;

  ScrollController scrollController = ScrollController();

  bool _listen = true;

  void init(TickerProvider ticker) {
    tabController = TabController(
      length: musicCategories.length,
      vsync: ticker,
    );

    double offsetFrom = 0.0;
    double offsetTo = 0.0;

    for (int i = 0; i < musicCategories.length; i++) {
      final category = musicCategories[i];

      if (i > 0) {
        offsetFrom += musicCategories[i - 1].albums.length * albumHeight;
      }

      if (i < musicCategories.length - 1) {
        offsetTo =
            offsetFrom + musicCategories[i + 1].albums.length * albumHeight;
      } else {
        offsetTo = double.infinity;
      }

      tabs.add(MusicTabCategory(
        category: category,
        selected: (i == 0),
        offsetFrom: categoryHeight * i + offsetFrom,
        offsetTo: offsetTo,
      ));

      items.add(AlbumItem(category: category));

      for (int j = 0; j < category.albums.length; j++) {
        final album = category.albums[j];
        items.add(AlbumItem(albumDetail: album));
      }
    }

    scrollController.addListener(_onScrollListener);
  }

  void _onScrollListener() {
    if (_listen) {
      for (int i = 0; i < tabs.length; i++) {
        final tab = tabs[i];

        if (scrollController.offset >= tab.offsetFrom &&
            scrollController.offset <= tab.offsetTo &&
            !tab.selected) {
          onCategorySelected(i, isAnimationRequired: false);
          tabController.animateTo(i);
          break;
        }
      }
    }
  }

  void onCategorySelected(int index, {bool isAnimationRequired = true}) async {
    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      final condition = selected.category.name == tabs[i].category.name;
      tabs[i] = tabs[i].copyWith(condition);
    }
    notifyListeners();

    if (isAnimationRequired) {
      _listen = false;
      await scrollController.animateTo(selected.offsetFrom,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    }
    _listen = true;
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}

class MusicTabCategory {
  final MusicCategory category;
  final bool selected;
  final double offsetFrom;
  final double offsetTo;

  MusicTabCategory copyWith(bool selected) => MusicTabCategory(
        category: category,
        selected: selected,
        offsetFrom: offsetFrom,
        offsetTo: offsetTo,
      );

  MusicTabCategory({
    required this.category,
    required this.selected,
    required this.offsetFrom,
    required this.offsetTo,
  });
}

class AlbumItem {
  const AlbumItem({
    this.category,
    this.albumDetail,
  });

  bool get isCategory => category != null;
  final MusicCategory? category;
  final AlbumDetail? albumDetail;
}
