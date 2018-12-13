import 'package:plantoid/common/mvi/state.dart';
import 'package:sealed_unions/sealed_unions.dart';

class HomeState extends Union5Impl<HomeStateAuthenticating,
    HomeStateLoading,
    HomeStatePlantsPage,
    HomeStateHousePage,
    HomeStateError> {
  static final Quintet<
      HomeStateAuthenticating,
      HomeStateLoading,
      HomeStatePlantsPage,
      HomeStateHousePage,
      HomeStateError> factory = const Quintet();

  HomeState._(Union5<HomeStateAuthenticating,
      HomeStateLoading,
      HomeStatePlantsPage,
      HomeStateHousePage,
      HomeStateError>
          union)
      : super(union);

  factory HomeState.authenticating() =>
      HomeState._(factory.first(HomeStateAuthenticating()));

  factory HomeState.loading() =>
      HomeState._(factory.second(HomeStateLoading()));

  factory HomeState.plantsPage() =>
      HomeState._(factory.third(HomeStatePlantsPage()));

  factory HomeState.housePage() =>
      HomeState._(factory.fourth(HomeStateHousePage()));

  factory HomeState.error(String error) =>
      HomeState._(factory.fifth(HomeStateError(error)));
}

class HomeStateAuthenticating extends State {}

class HomeStateLoading extends State {}

class HomeStatePlantsPage extends State {}

class HomeStateHousePage extends State {}

class HomeStateError extends State {
  final String error;

  HomeStateError(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeStateError &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => super.hashCode ^ error.hashCode;
}
