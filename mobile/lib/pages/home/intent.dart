import 'package:flutter_stream_friends/flutter_stream_friends.dart';

class HomeIntent {
  final VoidStreamCallback showAddPlantPage;
  final VoidStreamCallback plantsMenuItemClicked;
  final VoidStreamCallback houseMenuItemClicked;

  HomeIntent({
    final VoidStreamCallback showAddPlantPage,
    final VoidStreamCallback plantsMenuItemClicked,
    final VoidStreamCallback houseMenuItemClicked,
  })
      : this.showAddPlantPage = showAddPlantPage ?? VoidStreamCallback(),
        this.plantsMenuItemClicked =
            plantsMenuItemClicked ?? VoidStreamCallback(),
        this.houseMenuItemClicked =
            houseMenuItemClicked ?? VoidStreamCallback();
}
