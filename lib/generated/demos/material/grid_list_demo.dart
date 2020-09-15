// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';


// BEGIN gridListsDemo

enum GridListDemoType {
  imageOnly,
  header,
  footer,
}

class GridListDemo extends StatelessWidget {
  const GridListDemo({Key key, }) : super(key: key);

  

  List<_Photo> _photos(BuildContext context) {
    return [
      _Photo(
        assetName: 'places/india_chennai_flower_market.png',
        title: 'Chennai',
        subtitle: 'Flower market',
      ),
      _Photo(
        assetName: 'places/india_tanjore_bronze_works.png',
        title: 'Tanjore',
        subtitle: 'Bronze works',
      ),
      _Photo(
        assetName: 'places/india_tanjore_market_merchant.png',
        title: 'Tanjore',
        subtitle: 'Market',
      ),
      _Photo(
        assetName: 'places/india_tanjore_thanjavur_temple.png',
        title: 'Tanjore',
        subtitle: 'Thanjavur Temple',
      ),
      _Photo(
        assetName: 'places/india_tanjore_thanjavur_temple_carvings.png',
        title: 'Tanjore',
        subtitle: 'Thanjavur Temple',
      ),
      _Photo(
        assetName: 'places/india_pondicherry_salt_farm.png',
        title: 'Pondicherry',
        subtitle: 'Salt farm',
      ),
      _Photo(
        assetName: 'places/india_chennai_highway.png',
        title: 'Chennai',
        subtitle: 'Scooters',
      ),
      _Photo(
        assetName: 'places/india_chettinad_silk_maker.png',
        title: 'Chettinad',
        subtitle: 'Silk maker',
      ),
      _Photo(
        assetName: 'places/india_chettinad_produce.png',
        title: 'Chettinad',
        subtitle: 'Lunch prep',
      ),
      _Photo(
        assetName: 'places/india_tanjore_market_technology.png',
        title: 'Tanjore',
        subtitle: 'Market',
      ),
      _Photo(
        assetName: 'places/india_pondicherry_beach.png',
        title: 'Pondicherry',
        subtitle: 'Beach',
      ),
      _Photo(
        assetName: 'places/india_pondicherry_fisherman.png',
        title: 'Pondicherry',
        subtitle: 'Fisherman',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Grid lists'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        childAspectRatio: 1,
        children: _photos(context).map<Widget>((photo) {
          return _GridDemoPhotoItem(
            photo: photo,
            tileStyle: GridListDemoType.alert,
          );
        }).toList(),
      ),
    );
  }
}

class _Photo {
  _Photo({
    this.assetName,
    this.title,
    this.subtitle,
  });

  final String assetName;
  final String title;
  final String subtitle;
}

/// Allow the text size to shrink to fit in the space
class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Text(text),
    );
  }
}

class _GridDemoPhotoItem extends StatelessWidget {
  _GridDemoPhotoItem({
    Key key,
    @required this.photo,
    @required this.tileStyle,
  }) : super(key: key);

  final _Photo photo;
  final GridListDemoType tileStyle;

  @override
  Widget build(BuildContext context) {
    final Widget image = Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        photo.assetName,
        package: 'flutter_gallery_assets',
        fit: BoxFit.cover,
      ),
    );

    switch (tileStyle) {
      case GridListDemoType.imageOnly:
        return image;
      case GridListDemoType.header:
        return GridTile(
          header: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
              title: _GridTitleText(photo.title),
              backgroundColor: Colors.black45,
            ),
          ),
          child: image,
        );
      case GridListDemoType.footer:
        return GridTile(
          footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
              backgroundColor: Colors.black45,
              title: _GridTitleText(photo.title),
              subtitle: _GridTitleText(photo.subtitle),
            ),
          ),
          child: image,
        );
    }
    return null;
  }
}

// END
// The following code allows the demo to be run
// as a standalone app.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GridListDemo(),
    );
  }
}

