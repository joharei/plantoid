import 'package:flutter_stream_friends/flutter_stream_friends.dart';
import 'package:plantoid/models/plant.dart';

class EditPlantIntent {
  final ValueStreamCallback<double> onWateringFrequencySlide;
  final ValueStreamCallback<Plant> onSaveClicked;
  final VoidStreamCallback onTakePhotoClicked;

  EditPlantIntent({
    final ValueStreamCallback<double> onWateringFrequencySlide,
    final ValueStreamCallback<Plant> onSaveClicked,
    final VoidStreamCallback onTakePhotoClicked,
  })  : this.onWateringFrequencySlide =
            onWateringFrequencySlide ?? ValueStreamCallback(),
        this.onSaveClicked = onSaveClicked ?? ValueStreamCallback(),
        this.onTakePhotoClicked = onTakePhotoClicked ?? VoidStreamCallback();
}
