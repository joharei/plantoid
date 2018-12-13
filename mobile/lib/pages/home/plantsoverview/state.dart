import 'package:plantoid/common/mvi/state.dart';
import 'package:sealed_unions/sealed_unions.dart';

import 'model.dart';

class PlantsOverviewState extends Union4Impl<
    PlantsOverviewStateLoading,
    PlantsOverviewStateLoad,
    PlantsOverviewStateEmpty,
    PlantsOverviewStateError> {
  static final Quartet<PlantsOverviewStateLoading, PlantsOverviewStateLoad,
          PlantsOverviewStateEmpty, PlantsOverviewStateError> factory =
      Quartet<PlantsOverviewStateLoading, PlantsOverviewStateLoad,
          PlantsOverviewStateEmpty, PlantsOverviewStateError>();

  PlantsOverviewState._(
      Union4<PlantsOverviewStateLoading, PlantsOverviewStateLoad,
              PlantsOverviewStateEmpty, PlantsOverviewStateError>
          union)
      : super(union);

  factory PlantsOverviewState.loading() =>
      PlantsOverviewState._(factory.first(PlantsOverviewStateLoading()));

  factory PlantsOverviewState.load(List<PlantsOverviewItem> items) =>
      PlantsOverviewState._(factory.second(PlantsOverviewStateLoad(items)));

  factory PlantsOverviewState.empty() =>
      PlantsOverviewState._(factory.third(PlantsOverviewStateEmpty()));

  factory PlantsOverviewState.error(String error) =>
      PlantsOverviewState._(factory.fourth(PlantsOverviewStateError(error)));
}

class PlantsOverviewStateLoading extends State {}

class PlantsOverviewStateLoad extends State {
  final List<PlantsOverviewItem> items;

  PlantsOverviewStateLoad(this.items);

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is PlantsOverviewStateLoad &&
            runtimeType == other.runtimeType &&
            items == other.items;
  }

  @override
  int get hashCode => super.hashCode ^ items.hashCode;
}

class PlantsOverviewStateEmpty extends State {}

class PlantsOverviewStateError extends State {
  final String error;

  PlantsOverviewStateError(this.error);

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        runtimeType == other.runtimeType && error == other.error;
  }

  @override
  int get hashCode => super.hashCode ^ error.hashCode;
}
