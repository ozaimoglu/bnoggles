// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';

import 'package:bnoggles/utils/widget_logic/widget_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final _fontSizeCalculator = Interpolator.fromDataPoints(
  p1: const Point(592, 15),
  p2: const Point(1224, 35),
  min: 10,
  max: 40,
);

final _iconSizeCalculator = Interpolator.fromDataPoints(
  p1: const Point(592, 20),
  p2: const Point(1224, 45),
  min: 15,
  max: 50,
);

/// Screen showing the results for all players.
class ResultMultiPlayerScore extends StatelessWidget {
  ResultMultiPlayerScore({
    Key key,
    @required this.maxScore,
    @required this.scores,
  }) : super(key: key);

  final int maxScore;
  final List<int> scores;

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    double screenHeight = data.size.height;

    double fontSize = _fontSizeCalculator.y(x: screenHeight);
    double iconSize = _iconSizeCalculator.y(x: screenHeight);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.done_all,
              size: iconSize + 5,
              color: Colors.black,
            ),
            Container(
              width: 10,
            ),
            Text(
              maxScore.toString(),
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            )
          ],
        ),
        Container(
          height: 5,
        ),
        Table(
          columnWidths: const {
            0: FixedColumnWidth(50.0),
            1: FixedColumnWidth(50.0),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              Icon(
                Icons.person,
                size: iconSize,
              ),
              Icon(
                Icons.done,
                size: iconSize,
              ),
            ])
          ]..addAll(playerScores(fontSize)),
        )
      ],
    );
  }

  List<TableRow> playerScores(double fontSize) {
    Map<int, int> asMap = scores.asMap();
    return (asMap.keys.toList()..sort((a, b) => asMap[b] - asMap[a]))
        .map((k) => TableRow(
              children: [
                Center(
                  child: Text(
                    (k + 1).toString(),
                    style: TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    asMap[k].toString(),
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ))
        .toList();
  }
}
