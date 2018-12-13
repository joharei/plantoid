import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:plantoid/common/mvi/state.dart';
import 'package:plantoid/models/plant.dart';
import 'package:sealed_unions/sealed_unions.dart';

class EditPlantState extends Union3Impl<EditPlantStateEditingPlant,
    EditPlantStateSaving,
    EditPlantStateError> {
  static final Triplet<EditPlantStateEditingPlant,
      EditPlantStateSaving,
      EditPlantStateError> factory = Triplet();

  EditPlantState._(Union3<EditPlantStateEditingPlant,
      EditPlantStateSaving,
      EditPlantStateError>
  union)
      : super(union);

  factory EditPlantState.editingPlant(Plant plant, [File photo]) =>
      EditPlantState._(factory.first(EditPlantStateEditingPlant(plant, photo)));

  factory EditPlantState.saving(Plant plant, StorageUploadTask uploadTask) =>
      EditPlantState._(factory.second(EditPlantStateSaving(plant, uploadTask)));

  factory EditPlantState.error(String error, Plant plant, File photo) =>
      EditPlantState._(factory.third(EditPlantStateError(error, plant, photo)));
}

class EditPlantStateEditingPlant extends State {
  final Plant plant;
  final File photo;

  EditPlantStateEditingPlant(this.plant, this.photo);

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is EditPlantStateEditingPlant &&
            runtimeType == other.runtimeType &&
            plant == other.plant &&
            photo == other.photo;
  }

  @override
  int get hashCode => super.hashCode ^ plant.hashCode ^ photo.hashCode;
}

class EditPlantStateSaving extends State {
  final Plant plant;
  final StorageUploadTask uploadTask;

  EditPlantStateSaving(this.plant, this.uploadTask);

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is EditPlantStateSaving &&
            runtimeType == other.runtimeType &&
            plant == other.plant &&
            uploadTask == other.uploadTask;
  }

  @override
  int get hashCode => super.hashCode ^ plant.hashCode ^ uploadTask.hashCode;
}

class EditPlantStateError extends State {
  final String error;
  final Plant plant;
  final File photo;

  EditPlantStateError(this.error, this.plant, this.photo);

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is EditPlantStateError &&
            runtimeType == other.runtimeType &&
            error == other.error &&
            photo == other.photo;
  }

  @override
  int get hashCode => super.hashCode ^ error.hashCode ^ photo.hashCode;
}
