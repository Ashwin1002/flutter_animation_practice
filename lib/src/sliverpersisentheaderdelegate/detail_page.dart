import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import '/model/music_model.dart';

const _headerColor = Color(0xFFECECEA);

class AlbumDetailPage extends StatelessWidget {
  const AlbumDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: _AlbumTitleHeader(),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                albumDetail.description,
              ),
            ),
          )
        ],
      ),
    );
  }
}

const _maxHeaderExtent = 350.0;
const _minHeaderExtent = 130.0;

const _maxImageSize = 160.0;
const _minImageSize = 60.0;

const _leftMarginDisc = 150.0;
const _leftMarginHideDisc = 30.0;

const _maxTitleSize = 25.0;
const _maxSubTitleSize = 18.0;

const _minTitleSize = 16.0;
const _minSubTitleSize = 12.0;

const textMovement = .0;

const _maxBottomMargin = 30.0;
const _minBottomMargin = 10.0;

class _AlbumTitleHeader extends SliverPersistentHeaderDelegate {
  // shrink offset maximum value is _maxHeaderExtent and min is 0
  // if shrinkoffset is divided by _maxHeaderExtent we get percent value which ranges from 0 to 1.
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = MediaQuery.sizeOf(context);
    final percent = shrinkOffset / _maxHeaderExtent;

    final currentImageSize = (_maxImageSize * (1 - percent)).clamp(
      _minImageSize,
      _maxImageSize,
    );

    final titleSize = (_maxTitleSize * (1 - percent)).clamp(
      _minTitleSize,
      _maxTitleSize,
    );

    final subTitleSize = (_maxSubTitleSize * (1 - percent)).clamp(
      _minSubTitleSize,
      _maxSubTitleSize,
    );

    final bottomMargin = (_maxBottomMargin * (1 - percent))
        .clamp(_minBottomMargin, _maxBottomMargin);

    final maxMargin = size.width / 4;
    final leftTextMargin = maxMargin + (textMovement * percent);

    // print(percent);
    return Container(
      color: _headerColor,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 70.0,
            left: leftTextMargin,
            height: _maxImageSize,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  albumDetail.title,
                  style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5),
                ),
                Text(
                  albumDetail.subtitle,
                  style: TextStyle(
                    fontSize: subTitleSize,
                    letterSpacing: -0.5,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: bottomMargin,
            left: (_leftMarginDisc * (1 - percent))
                .clamp(_leftMarginHideDisc, _leftMarginDisc),
            height: currentImageSize - 10,
            child: Transform.rotate(
              angle: vector.radians(360 * percent),
              child: Image.asset(albumDetail.discImage),
            ),
          ),
          Positioned(
            bottom: bottomMargin,
            left: 20.0,
            height: currentImageSize,
            child: Image.asset(albumDetail.image),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => _maxHeaderExtent;

  @override
  double get minExtent => _minHeaderExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
