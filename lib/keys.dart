import 'dart:collection';

import 'package:flutter/foundation.dart';

class Keys {
  static const UNDO_BUTTON = const ValueKey("undoButton");
  static const START_BUTTON = const ValueKey("startButon");
  // ignore: non_constant_identifier_names
  static UnmodifiableListView<ValueKey> get CELLS =>
      UnmodifiableListView<ValueKey>([
        for (var gameY = 0; gameY < 3; gameY++)
          for (var gameX = 0; gameX < 3; gameX++)
            for (var cellY = 0; cellY < 3; cellY++)
              for (var cellX = 0; cellX < 3; cellX++)
                ValueKey("cell$gameX$gameY$cellX$cellY"),
      ]);
}
