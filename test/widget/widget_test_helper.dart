// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_info_provider.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/frequency.dart';
import 'package:bnoggles/utils/gamelogic/lettter_sequence.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:ui' as ui;

import 'package:mockito/mockito.dart';

Widget testableRow({List<Widget> children}) => MaterialApp(
      home: Material(
        child: Row(
          children: children,
        ),
      ),
    );

Widget testableWidget({Widget child}) => MaterialApp(
      home: Material(
        child: child,
      ),
    );

Widget testableConstrainedWidget({Widget child, double width, double height}) =>
    testableWidgetWithMediaQuery(
      child: Center(
        child: Container(
          width: width,
          height: height,
          child: UnconstrainedBox(
            child: child,
          ),
        ),
      ),
      width: width,
      height: height,
    );

Widget testableWidgetWithMediaQuery(
        {Widget child, double width, double height}) =>
    MaterialApp(
      home: Material(
        child: MediaQuery(
          data: MediaQueryData.fromWindow(ui.window).copyWith(
            size: Size(width, height),
          ),
          child: child,
        ),
      ),
    );

Widget testableWidgetWithProvider({Widget child, GameInfo info}) {
  return testableWidget(
    child: GameInfoProvider(
      gameInfo: info ?? createGameInfo(),
      child: child,
    ),
  );
}

class MockBoard extends Mock implements Board {}

class MockChain extends Mock implements Chain {}

class MockParameters extends Mock implements GameParameters {}

class MockRandomLetterGenerator extends Mock implements SequenceGenerator {}

class MockSolution extends Mock implements Solution {}

GameInfo createGameInfo({
  List<String> words = const ['abc'],
  int numberOfPlayers = 1,
  bool hasTimeLimit = true,
  bool hints = true,
  int minimalWordLength = 2,
}) {
  var mockParameters = createMockParameters(
    numberOfPlayers: numberOfPlayers,
    hasTimeLimit: hasTimeLimit,
    hints: hints,
  );
  var mockBoard = createMockBoard();
  var vua = ValueNotifier(UserAnswer.start());
  var mockSolution = createMockSolution(words, minimalWordLength);

  return GameInfo(
    parameters: mockParameters,
    board: mockBoard,
    solution: mockSolution,
    userAnswer: vua,
  );
}

MockParameters createMockParameters({
  int numberOfPlayers = 1,
  bool hasTimeLimit = true,
  bool hints = false,
}) {
  var mockParameters = MockParameters();

  when(mockParameters.hints).thenReturn(hints);
  when(mockParameters.minimalWordLength).thenReturn(2);
  when(mockParameters.boardWidth).thenReturn(3);
  when(mockParameters.languageCode).thenReturn('nl');
  when(mockParameters.hasTimeLimit).thenReturn(hasTimeLimit);
  when(mockParameters.time).thenReturn(150);
  when(mockParameters.numberOfPlayers).thenReturn(numberOfPlayers);

  return mockParameters;
}

MockSolution createMockSolution(List<String> words, int minimalLength) {
  var mockSolution = MockSolution();

  when(mockSolution.uniqueWords()).thenReturn(words.toSet());
  when(mockSolution.uniqueWordsSorted()).thenReturn(List.from(words)..sort());
  when(mockSolution.minimalLength).thenReturn(minimalLength);
  when(mockSolution.isCorrect(argThat(inList(words)))).thenReturn(true);
  when(mockSolution.isCorrect(argThat(isNot(inList(words))))).thenReturn(false);
  when(mockSolution.frequency).thenReturn(Frequency.fromStrings(words));

  var mockChain = MockChain();
  when(mockChain.text).thenReturn('abc');
  when(mockChain.chain).thenReturn([
    Coordinate(0, 0),
    Coordinate(0, 1),
    Coordinate(0, 2),
  ]);
  when(mockSolution.chains).thenReturn(Set.from(<Chain>[mockChain]));

  return mockSolution;
}

Matcher inList(List<String> strings) => _InList(strings);

class _InList extends Matcher {
  _InList(this.strings);

  final List<String> strings;

  @override
  Description describe(Description description) => description.add('inlist ');

  @override
  bool matches(dynamic item, Map matchState) => strings.contains(item);
}

Board createMockBoard() {
  var allCoordinates = [
    Coordinate(0, 0),
    Coordinate(0, 1),
    Coordinate(0, 2),
    Coordinate(1, 0),
    Coordinate(1, 1),
    Coordinate(1, 2),
    Coordinate(2, 0),
    Coordinate(2, 1),
    Coordinate(2, 2),
  ];

  var rlg = MockRandomLetterGenerator();
  when(rlg.next()).thenAnswer((s) => 'a');
  Board realBoard = Board(
    width: 3,
    generator: rlg,
  );

  var mockBoard = MockBoard();
  when(mockBoard[allCoordinates[0]]).thenReturn('a');
  when(mockBoard[allCoordinates[1]]).thenReturn('b');
  when(mockBoard[allCoordinates[2]]).thenReturn('c');
  when(mockBoard[allCoordinates[3]]).thenReturn('d');
  when(mockBoard[allCoordinates[4]]).thenReturn('e');
  when(mockBoard[allCoordinates[5]]).thenReturn('f');
  when(mockBoard[allCoordinates[6]]).thenReturn('g');
  when(mockBoard[allCoordinates[7]]).thenReturn('h');
  when(mockBoard[allCoordinates[8]]).thenReturn('i');

  when(mockBoard.width).thenReturn(3);

  when(mockBoard.allCoordinates()).thenReturn(allCoordinates);

  when(mockBoard.mapNeighbours()).thenReturn(realBoard.mapNeighbours());

  return mockBoard;
}
