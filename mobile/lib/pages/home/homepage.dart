import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantoid/common/mvi/viewstate.dart';
import 'package:plantoid/common/widgets/erroroccurredwidget.dart';
import 'package:plantoid/common/widgets/loadingwidget.dart';
import 'package:plantoid/pages/home/house/housepage.dart';
import 'package:plantoid/pages/home/intent.dart';
import 'package:plantoid/pages/home/model.dart';
import 'package:plantoid/pages/home/plantsoverview/plantsoverviewpage.dart';
import 'package:plantoid/pages/home/state.dart';
import 'package:plantoid/resources/localization/localization.dart';
import 'package:plantoid/service/authenticationservice.dart';
import 'package:plantoid/service/firestoreservice.dart';

class HomePage extends StatefulWidget {
  final HomeIntent intent;
  final HomeViewModel model;

  HomePage._({
    Key key,
    @required this.intent,
    @required this.model,
  }) : super(key: key);

  factory HomePage({
    Key key,
    HomeIntent intent,
    HomeViewModel model,
    AuthenticationService authService,
    FirestoreService dataService,
  }) {
    final _intent = intent ?? HomeIntent();
    final _model = model ??
        HomeViewModel(
          authService ?? AuthenticationService.instance,
          dataService ?? FirestoreService.instance,
          _intent.showAddPlantPage,
          _intent.plantsMenuItemClicked,
          _intent.houseMenuItemClicked,
        );

    return HomePage._(key: key, intent: _intent, model: _model);
  }

  @override
  _HomePageState createState() => _HomePageState(intent: intent, model: model);
}

class _HomePageState
    extends ViewState<HomePage, HomeViewModel, HomeIntent, HomeState> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  SystemUiOverlayStyle _systemUiOverlayStyle;

  _HomePageState({@required HomeIntent intent, @required HomeViewModel model})
      : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<HomeState> snapshot) {
        _setSystemUIColors(context);

        if (!snapshot.hasData) {
          return Container();
        }

        return snapshot.data.join(
                (authenticating) => _buildLoadingWidget(),
                (loading) => _buildLoadingWidget(),
                (plantsPage) => _buildPlantsWidget(),
                (housePage) => _buildHouseWidget(),
                (error) => _buildErrorWidget(error: error.error));
      },
    );
  }

  void _setSystemUIColors(BuildContext context) {
    _systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Theme
          .of(context)
          .canvasColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    );

    SystemChrome.setSystemUIOverlayStyle(_systemUiOverlayStyle);
    _updateNavigationBarIconBrightness();
  }

  void _updateNavigationBarIconBrightness() async {
    SystemChannels.lifecycle.setMessageHandler((msg) {
      if (msg == AppLifecycleState.resumed.toString()) {
        SystemChrome.setSystemUIOverlayStyle(_systemUiOverlayStyle);
      }
    });
  }

  Widget _buildLoadingWidget() {
    return Scaffold(body: LoadingWidget());
  }

  Widget _buildErrorWidget({@required String error}) {
    return Scaffold(body: ErrorOccurredWidget(error: error));
  }

  Widget _buildScaffold(Widget body, int currentIndex) {
    return Scaffold(
      key: _scaffoldKey,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/yellow_flower.webp')),
            title: Text(Localization
                .of(context)
                .plants),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(Localization
                .of(context)
                .house),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          if (index == 0) {
            intent.plantsMenuItemClicked();
          } else {
            intent.houseMenuItemClicked();
          }
        },
      ),
      floatingActionButton: currentIndex == 0 ? _buildAddPlantFab() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  FloatingActionButton _buildAddPlantFab() {
    return FloatingActionButton(
      onPressed: intent.showAddPlantPage,
      tooltip: Localization
          .of(context)
          .addPlant,
      child: Icon(Icons.add),
    );
  }

  Widget _buildPlantsWidget() {
    return _buildScaffold(PlantsOverviewPage(scaffoldKey: _scaffoldKey), 0);
  }

  Widget _buildHouseWidget() {
    return _buildScaffold(HousePage(), 1);
  }
}
