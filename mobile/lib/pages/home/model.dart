import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plantoid/common/exceptionprint.dart';
import 'package:plantoid/common/mvi/viewmodel.dart';
import 'package:plantoid/pages/editplant/edit_plant.dart';
import 'package:plantoid/pages/home/state.dart';
import 'package:plantoid/pages/login/loginpage.dart';
import 'package:plantoid/service/authenticationservice.dart';
import 'package:plantoid/service/firestoreservice.dart';

class HomeViewModel extends BaseViewModel<HomeState> {
  final AuthenticationService _authService;
  final FirestoreService _dataService;

  HomeViewModel(this._authService,
      this._dataService,
      Stream<void> onShowAddPlantPageButtonPressed,
      Stream<void> onPlantsPageItemPressed,
      Stream<void> onHousePageItemPressed,) {
    onShowAddPlantPageButtonPressed.listen(_showAddPlantPage);
    onPlantsPageItemPressed.listen(_showPlantsPage);
    onHousePageItemPressed.listen(_showHousePage);
  }

  @override
  HomeState initialState() => HomeState.authenticating();

  @override
  Stream<HomeState> bind(BuildContext context) {
    _loadData();

    return super.bind(context);
  }

  _loadData() async {
    try {
      setState(HomeState.authenticating());

      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        pushReplacementNamed(LOGIN_PAGE_ROUTE);
        return;
      }

      setState(HomeState.loading());

      await _dataService.initUser(currentUser);

      setState(HomeState.plantsPage());
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error loading home");

      setState(HomeState.error(e.toString()));
    }
  }

  _showPlantsPage(void event) {
    setState(HomeState.plantsPage());
  }

  _showHousePage(void event) {
    setState(HomeState.housePage());
  }

  _showAddPlantPage(void event) {
    pushRoute(MaterialPageRoute(
      builder: (_) => EditPlantPage(),
      fullscreenDialog: true,
    ));
  }
}
