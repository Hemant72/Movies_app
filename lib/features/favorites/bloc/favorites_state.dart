part of 'favorites_bloc.dart';

@immutable
class FavoritesState {
  final List<MovieModel> favorites;
  final bool isLoading;

  const FavoritesState({
    this.favorites = const [],
    this.isLoading = false,
  });

  FavoritesState copyWith({
    List<MovieModel>? favorites,
    bool? isLoading,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
