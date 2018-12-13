import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:plantoid/resources/constants.dart';

class Plant {
  final DocumentReference reference;
  final String name;
  final String notes;
  final int wateringFrequency;
  final DateTime lastWatered;
  final String photoUrl;

  Plant({
    @required this.reference,
    @required this.name,
    @required this.notes,
    @required this.wateringFrequency,
    @required this.lastWatered,
    @required this.photoUrl,
  });

  Plant.fromSnapshot(DocumentSnapshot snapshot)
      : this(
    reference: snapshot.reference,
      name: snapshot[FirestoreConstants.NAME],
      notes: snapshot[FirestoreConstants.NOTES],
      wateringFrequency: snapshot[FirestoreConstants.WATERING_FREQUENCY],
      lastWatered: snapshot[FirestoreConstants.LAST_WATERED],
      photoUrl: snapshot[FirestoreConstants.PHOTO_URL]
  );

  Plant copy({
    DocumentReference reference,
    String name,
    String notes,
    int wateringFrequency,
    DateTime lastWatered,
    String photoUrl,
  }) {
    return Plant(
      reference: reference ?? this.reference,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      wateringFrequency: wateringFrequency ?? this.wateringFrequency,
      lastWatered: lastWatered ?? this.lastWatered,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  bool operator ==(other) =>
      identical(this, other) ||
          other is Plant &&
              runtimeType == other.runtimeType &&
              reference == other.reference &&
              name == other.name &&
              notes == other.notes &&
              wateringFrequency == other.wateringFrequency &&
              lastWatered == other.lastWatered &&
              photoUrl == other.photoUrl;

  @override
  int get hashCode =>
      reference.hashCode ^
      name.hashCode ^
      notes.hashCode ^
      wateringFrequency.hashCode ^
      lastWatered.hashCode ^
      photoUrl.hashCode;
}
