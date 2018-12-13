import 'dart:async';
import 'dart:io';

import 'package:plantoid/common/exceptionprint.dart';
import 'package:plantoid/common/mvi/viewmodel.dart';
import 'package:plantoid/models/plant.dart';
import 'package:plantoid/pages/editplant/camera/camerapage.dart';
import 'package:plantoid/service/firestoreservice.dart';

import 'state.dart';

class EditPlantViewModel extends BaseViewModel<EditPlantState> {
  Plant _plant;
  File _photo;
  final FirestoreService _dataService;

  EditPlantViewModel(this._dataService,
    this._plant,
    Stream<double> onWateringFrequencySlide,
    Stream<Plant> onSaveClicked,
    Stream<Null> onTakePhotoClicked,
  ) {
    onWateringFrequencySlide.listen(_wateringFrequencyChanged);
    onSaveClicked.listen(_savePlant);
    onTakePhotoClicked.listen(_takePhoto);
  }

  @override
  EditPlantState initialState() => EditPlantState.editingPlant(_plant);

  _wateringFrequencyChanged(double wateringFrequency) {
    _plant = _plant.copy(wateringFrequency: wateringFrequency.toInt());
    setState(EditPlantState.editingPlant(_plant));
  }

  _savePlant(Plant plant) async {
    try {
      await for (var uploadTask in _dataService.savePlant(plant, _photo)) {
        setState(EditPlantState.saving(plant, uploadTask));
      }

      pop();
    } catch (error, stackTrace) {
      setState(EditPlantState.error(error.toString(), plant, _photo));
      printException(error, stackTrace, "Error saving plant");
    }
  }

  _takePhoto(Null event) async {
    String imageFilePath = await pushNamed(CAMERA_PAGE_ROUTE);
    _photo = File(imageFilePath);

    setState(EditPlantState.editingPlant(_plant, _photo));
  }
}
