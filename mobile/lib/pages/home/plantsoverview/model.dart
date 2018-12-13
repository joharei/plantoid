import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:plantoid/common/mvi/viewmodel.dart';
import 'package:plantoid/models/plant.dart';
import 'package:plantoid/pages/editplant/edit_plant.dart';
import 'package:plantoid/resources/constants.dart';
import 'package:plantoid/resources/localization/localization.dart';
import 'package:plantoid/service/firestoreservice.dart';
import 'package:tuple/tuple.dart';

import 'state.dart';

class PlantsOverviewViewModel extends BaseViewModel<PlantsOverviewState> {
  final FirestoreService _dataService;
  StreamSubscription<List<Plant>> _plantsSubscription;

  PlantsOverviewViewModel(
    this._dataService,
    Stream<Plant> onPlantClicked,
    Stream<Tuple2<ScaffoldState, Plant>> onWateredSwiped,
    Stream<Tuple2<ScaffoldState, Plant>> onDeleteSwiped,
  ) {
    onPlantClicked.listen(_plantClicked);
    onWateredSwiped.listen(_setWatered);
    onDeleteSwiped.listen(_deletePlant);
  }

  @override
  PlantsOverviewState initialState() => PlantsOverviewState.loading();

  @override
  Stream<PlantsOverviewState> bind(BuildContext context) {
    _bindToUpdates();

    return super.bind(context);
  }

  @override
  unbind() {
    _plantsSubscription?.cancel();
    _plantsSubscription = null;

    super.unbind();
  }

  _bindToUpdates() {
    _plantsSubscription?.cancel();
    _plantsSubscription = _dataService.listenForPlants().listen(_onNewPlants);
  }

  _onNewPlants(List<Plant> newPlants) async {
    if (newPlants == null || newPlants.isEmpty) {
      setState(PlantsOverviewState.empty());
    } else {
      List<PlantsOverviewItem> items = await _buildItemList(newPlants);
      setState(PlantsOverviewState.load(items));
    }
  }

  Future<List<PlantsOverviewItem>> _buildItemList(List<Plant> plants) async {
    Map<bool, List<Plant>> groups = groupBy(plants, (Plant plant) {
      DateTime timeToWater =
      plant.lastWatered.add(Duration(days: plant.wateringFrequency));
      bool needsWatering = timeToWater.isBefore(DateTime.now());
      return needsWatering;
    });

    List<Plant> plantsToWater = groups[true] ?? [];
    List<Plant> wateredPlants = groups[false] ?? [];

    return plantsToWater
        .map((plant) => PlantListItem(plant))
        .cast<PlantsOverviewItem>()
        .toList()
      ..add(ExpansionListItem(
        Localization
            .of(getBuildContext())
            .doneForNow +
            " (${wateredPlants.length})",
        wateredPlants.map((plant) => PlantListItem(plant)).toList(),
      ));
  }

  _plantClicked(Plant plant) async {
    pushRoute(MaterialPageRoute(
      builder: (_) => EditPlantPage(plant: plant),
      fullscreenDialog: true,
    ));
  }

  _setWatered(Tuple2<ScaffoldState, Plant> statePlantPair) async {
    ScaffoldState scaffoldState = statePlantPair.item1;
    BuildContext context = scaffoldState.context;
    Plant plant = statePlantPair.item2;

    DocumentSnapshot snapshot = await plant.reference.get();

    await plant.reference.updateData({
      FirestoreConstants.LAST_WATERED: DateTime.now(),
      FirestoreConstants.NOTIFICATION_SENT: false,
    });

    scaffoldState.showSnackBar(SnackBar(
      content: Text(Localization
          .of(context)
          .wasWatered),
      duration: Constants.undoSnackBarDuration,
      action: SnackBarAction(
        label: Localization
            .of(context)
            .undo,
        onPressed: () => plant.reference.updateData({
          FirestoreConstants.LAST_WATERED:
          snapshot[FirestoreConstants.LAST_WATERED]
            }),
      ),
    ));
  }

  _deletePlant(Tuple2<ScaffoldState, Plant> statePlantPair) async {
    ScaffoldState scaffoldState = statePlantPair.item1;
    BuildContext context = scaffoldState.context;
    Plant plant = statePlantPair.item2;

    DocumentSnapshot snapshot = await plant.reference.get();

    await plant.reference.delete();

    Timer deletePhoto =
    Timer(Constants.undoSnackBarDuration + Duration(seconds: 1), () {
      FirebaseStorage.instance.ref().child(plant.reference.documentID).delete();
    });

    scaffoldState.showSnackBar(SnackBar(
      content: Text(Localization
          .of(context)
          .deleted),
      duration: Constants.undoSnackBarDuration,
      action: SnackBarAction(
        label: Localization
            .of(context)
            .undo,
        onPressed: () {
          deletePhoto.cancel();
          Firestore.instance
              .collection(FirestoreConstants.PLANTS)
              .document(snapshot.reference.documentID)
              .setData(snapshot.data);
        },
      ),
    ));
  }
}

abstract class PlantsOverviewItem {}

class ExpansionListItem implements PlantsOverviewItem {
  final String title;
  final List<PlantListItem> plantItems;

  ExpansionListItem(this.title, this.plantItems);
}

class PlantListItem implements PlantsOverviewItem {
  final Plant plant;

  PlantListItem(this.plant);
}
