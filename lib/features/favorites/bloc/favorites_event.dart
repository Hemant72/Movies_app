part of 'favorites_bloc.dart';

@immutable
sealed class FavoritesEvent {}

class LoadFavorites extends FavoritesEvent {}

class AddToFavorites extends FavoritesEvent {
  final MovieModel movie;
  AddToFavorites(this.movie);
}

class RemoveFromFavorites extends FavoritesEvent {
  final MovieModel movie;
  RemoveFromFavorites(this.movie);
}
