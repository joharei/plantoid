import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:plantoid/common/mvi/viewstate.dart';
import 'package:plantoid/models/plant.dart';
import 'package:plantoid/resources/colors.dart';
import 'package:plantoid/resources/dimens.dart';
import 'package:plantoid/resources/localization/localization.dart';
import 'package:plantoid/service/firestoreservice.dart';

import 'intent.dart';
import 'model.dart';
import 'state.dart';

class EditPlantPage extends StatefulWidget {
  final EditPlantIntent intent;
  final EditPlantViewModel model;

  EditPlantPage._({
    Key key,
    @required this.intent,
    @required this.model,
  }) : super(key: key);

  factory EditPlantPage({
    Key key,
    Plant plant,
    EditPlantIntent intent,
    EditPlantViewModel model,
    FirestoreService dataService,
  }) {
    final _plant = plant ??
        Plant(
          reference: null,
          name: null,
          notes: null,
          wateringFrequency: null,
          lastWatered: DateTime.now(),
          photoUrl: null,
        );
    final _intent = intent ?? EditPlantIntent();
    final _model = model ??
        EditPlantViewModel(
          dataService ?? FirestoreService.instance,
          _plant,
          _intent.onWateringFrequencySlide,
          _intent.onSaveClicked,
          _intent.onTakePhotoClicked,
        );

    return EditPlantPage._(key: key, intent: _intent, model: _model);
  }

  @override
  State<StatefulWidget> createState() =>
      _EditPlantState(intent: intent, model: model);
}

class _EditPlantState extends ViewState<EditPlantPage,
    EditPlantViewModel,
    EditPlantIntent,
    EditPlantState> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  final _nameController = new TextEditingController();
  final _notesController = new TextEditingController();

  double _wateringDays = 1.0;

  _EditPlantState({
    @required EditPlantIntent intent,
    @required EditPlantViewModel model,
  }) : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<EditPlantState> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return snapshot.data.join(
              (editingPlant) =>
              _buildEditPlantWidget(editingPlant.plant, editingPlant.photo),
              (saving) => _buildSavingWidget(saving.plant, saving.uploadTask),
              (error) => _buildError(error.error, error.plant, error.photo),
        );
      },
    );
  }

  Widget _buildEditPlantWidget(Plant plant, File photo) {
    _nameController.text = plant.name;
    _notesController.text = plant.notes;
    _wateringDays = plant.wateringFrequency?.toDouble() ?? 1.0;

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(plant),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimens.defaultMargin),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildPhotoButton(photo, plant.photoUrl),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: Localization
                      .of(context)
                      .name,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return Localization
                        .of(context)
                        .cannotBeEmpty;
                  }
                },
              ),
              SizedBox(height: 24.0),
              Text(
                Localization
                    .of(context)
                    .wateringFrequency,
                style: Theme
                    .of(context)
                    .accentTextTheme
                    .subhead
                    .copyWith(
                  color: AppColors.secondaryTextColor,
                ),
              ),
              Slider(
                value: _wateringDays,
                min: 1.0,
                max: 30.0,
                divisions: 29,
                label: Localization.of(context).days(_wateringDays.toInt()),
                onChanged: intent.onWateringFrequencySlide,
              ),
              SizedBox(height: 24.0),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: Localization
                      .of(context)
                      .notes,
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Builder(
          builder: (context) =>
              FloatingActionButton(
                onPressed: () => _save(plant),
                tooltip: Localization
                    .of(context)
                    .save,
                child: Icon(Icons.save),
              )),
    );
  }

  Widget _buildAppBar(Plant plant) {
    return AppBar(
      title: Text(plant.name ?? Localization
          .of(context)
          .addPlant),
    );
  }

  Widget _buildPhotoButton(File photo, String photoUrl) {
    Widget image;
    if (photo != null) {
      image = Image(
        image: FileImage(photo),
        fit: BoxFit.cover,
      );
    } else if (photoUrl != null) {
      image = CachedNetworkImage(
        imageUrl: photoUrl,
        placeholder: Center(child: CircularProgressIndicator()),
        fit: BoxFit.cover,
      );
    } else {
      image = Container(
        padding: EdgeInsets.all(48.0),
        child: FittedBox(
          child: Icon(
            Icons.add_a_photo,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: Dimens.defaultMargin),
      child: AspectRatio(
        aspectRatio: 16.0 / 10,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: image,
              ),
            ),
            Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: Colors.transparent,
              child: InkWell(
                onTap: intent.onTakePhotoClicked,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingWidget(Plant plant, StorageUploadTask uploadTask) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(plant),
      body: StreamBuilder(
        stream: uploadTask.events,
        builder: (BuildContext context,
            AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
          double progress;
          if (asyncSnapshot.hasData) {
            var snapshot = asyncSnapshot.data.snapshot;
            progress = snapshot.bytesTransferred / snapshot.totalByteCount;
          }

          return Container(
            margin: EdgeInsets.symmetric(horizontal: Dimens.defaultMargin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LinearProgressIndicator(
                  value: progress,
                ),
                Padding(padding: EdgeInsets.only(top: Dimens.defaultMargin)),
                Text(Localization
                    .of(context)
                    .saving)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(String error, Plant plant, File photo) {
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text(Localization
              .of(context)
              .failedSavingPlant)));
    });
    return _buildEditPlantWidget(plant, photo);
  }

  _save(Plant oldPlant) {
    if (_formKey.currentState.validate()) {
      Plant plant = Plant(
        reference: oldPlant.reference,
        name: _nameController.text,
        wateringFrequency: _wateringDays.toInt(),
        notes: _notesController.text,
        lastWatered: oldPlant.lastWatered,
        photoUrl: oldPlant.photoUrl,
      );
      intent.onSaveClicked(plant);
    }
  }
}
