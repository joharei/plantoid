abstract class State {
  @override
  bool operator ==(other) =>
      identical(this, other) || runtimeType == other.runtimeType;

  @override
  int get hashCode => super.hashCode;
}
