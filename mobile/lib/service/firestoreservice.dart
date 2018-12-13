import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:plantoid/common/networkexception.dart';
import 'package:plantoid/models/plant.dart';
import 'package:plantoid/resources/constants.dart';

abstract class FirestoreService {
  static final FirestoreService instance =
  _FirestoreServiceImpl(Firestore.instance);

  Future<void> initUser(FirebaseUser currentUser);

  Stream<List<Plant>> listenForPlants();

  /// Yields a [StorageUploadTask] when starting to upload photo
  Stream<StorageUploadTask> savePlant(Plant plant, File photo);
}

const _DEFAULT_TIMEOUT = Duration(seconds: 10);

class _FirestoreServiceImpl implements FirestoreService {
  final Firestore _firestore;

  DocumentSnapshot _userDoc;
  DocumentSnapshot _houseDoc;

  _FirestoreServiceImpl(this._firestore);

  @override
  Future<void> initUser(FirebaseUser currentUser) async {
    _userDoc = await _setUpUserDetails(currentUser).timeout(
      _DEFAULT_TIMEOUT,
      onTimeout: () =>
          Future.error(NetworkException(
              "Unable to connect to Firebase. Please check your network connection.")),
    );

    _houseDoc = await _setUpHouse(_userDoc).timeout(
      _DEFAULT_TIMEOUT,
      onTimeout: () =>
          Future.error(NetworkException(
              "Unable to connect to Firebase. Please check your network connection.")),
    );
  }

  Future<DocumentSnapshot> _setUpUserDetails(FirebaseUser user) async {
    final DocumentReference ref =
    _firestore.collection("users").document(user.uid);

    DocumentSnapshot doc = await ref.get();

    String fcmToken = await _getFirebaseMessagingToken();

    if (doc == null || !doc.exists) {
      debugPrint("Creating document reference for id ${user.uid}");

      await ref.setData({
        "id": user.uid,
        "mail": user.email,
        "created_at": DateTime.now(),
        "fcm_token": fcmToken,
      });

      doc = await ref.get();
      if (doc == null) {
        throw Exception("Unable to create user document");
      }
    } else if (fcmToken != null && fcmToken != doc.data["fcm_token"]) {
      await ref.updateData({"fcm_token": fcmToken});
    }

    return doc;
  }

  Future<DocumentSnapshot> _setUpHouse(DocumentSnapshot userDoc) async {
    QuerySnapshot query = await _firestore
        .collection("houses")
        .where("users", arrayContains: userDoc.reference)
        .getDocuments();
    return query.documents.first;
  }

  Future<String> _getFirebaseMessagingToken() async =>
      await FirebaseMessaging().getToken();

  _assertServiceInitialized() {
    if (_userDoc == null) {
      throw Exception("User is not initialized");
    }

    if (_houseDoc == null) {
      throw Exception("House is not initialized");
    }
  }

  @override
  Stream<List<Plant>> listenForPlants() {
    _assertServiceInitialized();

    return _firestore
        .collection(FirestoreConstants.PLANTS)
        .where(FirestoreConstants.HOUSE_ID, isEqualTo: _houseDoc.documentID)
        .orderBy(FirestoreConstants.LAST_WATERED)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((snapshot) => Plant.fromSnapshot(snapshot))
            .toList());
  }

  @override
  Stream<StorageUploadTask> savePlant(Plant plant, File photo) async* {
    var reference = Firestore.instance
        .collection(FirestoreConstants.PLANTS)
        .document(plant.reference?.documentID);

    String photoUrl;
    if (photo != null) {
      StorageReference storageReference =
      FirebaseStorage.instance.ref().child(reference.documentID);

      await storageReference.updateMetadata(StorageMetadata(
        cacheControl: 'public,max-age=31536000',
        contentType: lookupMimeType(photo.path),
      ));

      StorageUploadTask uploadTask = storageReference.putFile(photo);

      yield uploadTask;

      await uploadTask.onComplete;

      photoUrl = await storageReference.getDownloadURL();

      await photo.delete();
    }

    await reference.setData(
      {
        FirestoreConstants.NAME: plant.name,
        FirestoreConstants.WATERING_FREQUENCY: plant.wateringFrequency,
        FirestoreConstants.NOTES: plant.notes,
        FirestoreConstants.LAST_WATERED: plant.lastWatered,
        FirestoreConstants.PHOTO_URL: photoUrl ?? plant.photoUrl,
        FirestoreConstants.HOUSE_ID: _houseDoc.documentID
      },
      merge: true,
    );
  }
}
