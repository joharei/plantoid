import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plantoid/common/mvi/viewstate.dart';
import 'package:plantoid/common/widgets/erroroccurredwidget.dart';
import 'package:plantoid/common/widgets/loadingwidget.dart';
import 'package:plantoid/models/plant.dart';
import 'package:plantoid/resources/localization/localization.dart';
import 'package:plantoid/service/firestoreservice.dart';
import 'package:timeago/timeago.dart';
import 'package:tuple/tuple.dart';

import 'intent.dart';
import 'model.dart';
import 'state.dart';

class PlantsOverviewPage extends StatefulWidget {
  final PlantsOverviewIntent intent;
  final PlantsOverviewViewModel model;
  final GlobalKey<ScaffoldState> scaffoldKey;

  PlantsOverviewPage._({
    Key key,
    @required this.intent,
    @required this.model,
    @required this.scaffoldKey,
  }) : super(key: key);

  factory PlantsOverviewPage({
    Key key,
    @required GlobalKey<ScaffoldState> scaffoldKey,
    PlantsOverviewIntent intent,
    PlantsOverviewViewModel model,
    FirestoreService dataService,
  }) {
    final _intent = intent ?? PlantsOverviewIntent();
    final _model = model ??
        PlantsOverviewViewModel(
          dataService ?? FirestoreService.instance,
          _intent.plantClicked,
          _intent.onWateredSwiped,
          _intent.onDeleteSwiped,
        );

    return PlantsOverviewPage._(
      key: key,
      intent: _intent,
      model: _model,
      scaffoldKey: scaffoldKey,
    );
  }

  @override
  State<StatefulWidget> createState() => _PlantsOverviewPageState(
    intent: intent,
    model: model,
  );
}

class _PlantsOverviewPageState extends ViewState<PlantsOverviewPage,
    PlantsOverviewViewModel, PlantsOverviewIntent, PlantsOverviewState> {
  _PlantsOverviewPageState({
    @required PlantsOverviewIntent intent,
    @required PlantsOverviewViewModel model,
  }) : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder:
          (BuildContext context, AsyncSnapshot<PlantsOverviewState> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return snapshot.data.join(
              (loading) => _buildLoadingWidget(),
              (load) => _buildLoadWidget(items: load.items),
              (empty) => _buildEmptyWidget(),
              (error) => _buildErrorWidget(error: error.error),
        );
      },
    );
  }

  Widget _buildPage(Widget body) {
    return CustomScrollView(
      slivers: <Widget>[
        _buildHeader(),
        SliverFillRemaining(child: body),
      ],
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          Localization
              .of(context)
              .plants,
          style: TextStyle(
            fontFamily: "Google Sans",
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        collapseMode: CollapseMode.pin,
      ),
      floating: true,
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      expandedHeight: 80.0,
    );
  }

  Widget _buildLoadingWidget() {
    return _buildPage(
      Container(
        padding: EdgeInsets.only(top: 10.0, bottom: 25.0),
        child: LoadingWidget(),
      ),
    );
  }

  Widget _buildErrorWidget({@required String error}) =>
      _buildPage(ErrorOccurredWidget(error: error));

  Widget _buildEmptyWidget() {
    return _buildPage(
      Image.asset(
        'assets/icons/yellow_flower.webp',
      ),
    );
  }

  Widget _buildLoadWidget({@required List<PlantsOverviewItem> items}) {
    return CustomScrollView(
      slivers: <Widget>[
        _buildHeader(),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              if (index == items.length) {
                return Padding(padding: EdgeInsets.only(bottom: 32.0));
              }

              if (items[index] is PlantListItem) {
                return _buildPlantTile(
                  context,
                  (items[index] as PlantListItem).plant,
                  index !=
                      items.lastIndexWhere((item) => item is PlantListItem),
                );
              }
              ExpansionListItem expansionItem = items[index];
              return ExpansionTile(
                title: Text(
                  expansionItem.title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "Google Sans",
                  ),
                ),
                backgroundColor: Colors.transparent,
                children: expansionItem.plantItems
                    .map((item) =>
                    _buildPlantTile(
                      context,
                      item.plant,
                      item != expansionItem.plantItems.last,
                    ))
                    .toList(),
              );
            },
            childCount: items.length + 1,
          ),
        ),
      ],
    );
  }

  Widget _buildPlantTile(BuildContext context, Plant plant, bool addDivider) {
    Widget image;
    if (plant.photoUrl != null) {
      image = ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: 60.0,
          child: AspectRatio(
            aspectRatio: 4.0 / 3,
            child: CachedNetworkImage(
              imageUrl: plant.photoUrl,
              placeholder: Image.asset('assets/icons/yellow_flower.webp'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    Widget listTile = ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: image,
      title: Text(plant.name),
      subtitle: Text(
          Localization.of(context).lastWatered(timeAgo(plant.lastWatered))),
      onTap: () => intent.plantClicked(plant),
    );

    var dismissible = Dismissible(
      key: ObjectKey(plant),
      child: listTile,
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          intent
              .onWateredSwiped(Tuple2(widget.scaffoldKey.currentState, plant));
        } else if (direction == DismissDirection.endToStart) {
          intent.onDeleteSwiped(Tuple2(widget.scaffoldKey.currentState, plant));
        }
      },
      background: _buildDismissibleBackground(
          Colors.blue,
          Image.asset('assets/icons/watering_can.webp', color: Colors.white),
          true),
      secondaryBackground: _buildDismissibleBackground(
          Colors.red, Icon(Icons.delete, color: Colors.white), false),
    );

    return addDivider
        ? Column(children: <Widget>[
      dismissible,
      Divider(indent: image != null ? 114.0 : 0.0, height: 0.0)
    ])
        : dismissible;
  }

  Widget _buildDismissibleBackground(Color color, Widget icon, bool left) {
    return Container(
      padding:
      EdgeInsets.only(left: left ? 24.0 : 0.0, right: left ? 0.0 : 24.0),
      alignment: left ? Alignment.centerLeft : Alignment.centerRight,
      child: icon,
      color: color,
    );
  }
}
