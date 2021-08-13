// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// @dart=2.9
import 'package:flutter/material.dart';


AppBar buildAppBar(BuildContext context,String title) {
      return AppBar(
        leading: IconButton(
          tooltip: "openAppDrawerTooltip",
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text(
          title,
        ),
        actions: [
          IconButton(
            tooltip:  "starterAppTooltipFavorite",
            icon: const Icon(
              Icons.favorite,
            ),
            onPressed: () {},
          ),
          IconButton(
            tooltip: "starterAppTooltipSearch",
            icon: const Icon(
              Icons.search,
            ),
            onPressed: () {},
          ),
          PopupMenuButton<Text>(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text(
                     "demoNavigationRailFirst",
                  ),
                ),
                PopupMenuItem(
                  child: Text(
                     "demoNavigationRailSecond",
                  ),
                ),
                PopupMenuItem(
                  child: Text(
                     "demoNavigationRailThird",
                  ),
                ),
              ];
            },
          )
        ],
      );

  }
