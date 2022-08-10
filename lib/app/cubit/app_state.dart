part of 'app_cubit.dart';

/// App State of all screen page
abstract class AppState extends Equatable {
  /// Called on every app state
  const AppState(this.user);

  /// User of the app
  final User? user;

  @override
  List<Object?> get props => [user];
}

/// Initial state of the app
class AppInitial extends AppState {
  /// Called on app initial state and refresh method
  const AppInitial(super.user);
}

/// Loading state of the app
class AppLoading extends AppState {
  /// Called on refresh method
  const AppLoading(super.user);
}
