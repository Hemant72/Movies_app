part of 'movie_bloc.dart';

@immutable
sealed class MovieEvent {}

class FetchMovies extends MovieEvent {}

class ToggleFavorite extends MovieEvent {
  final MovieModel movie;
  ToggleFavorite(this.movie);
}
