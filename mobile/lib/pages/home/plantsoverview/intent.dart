import 'package:flutter/material.dart';
import 'package:flutter_stream_friends/flutter_stream_friends.dart';
import 'package:plantoid/models/plant.dart';
import 'package:tuple/tuple.dart';

class PlantsOverviewIntent {
  final ValueStreamCallback<Plant> plantClicked;
  final ValueStreamCallback<Tuple2<ScaffoldState, Plant>> onWateredSwiped;
  final ValueStreamCallback<Tuple2<ScaffoldState, Plant>> onDeleteSwiped;

  PlantsOverviewIntent({
    final ValueStreamCallback<Plant> plantClicked,
    final ValueStreamCallback<Tuple2<ScaffoldState, Plant>> onWateredSwiped,
    final ValueStreamCallback<Tuple2<ScaffoldState, Plant>> onDeleteSwiped,
  })  : this.plantClicked = plantClicked ?? ValueStreamCallback(),
        this.onWateredSwiped = onWateredSwiped ?? ValueStreamCallback(),
        this.onDeleteSwiped = onDeleteSwiped ?? ValueStreamCallback();
}
