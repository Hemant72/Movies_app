import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/favorites/bloc/favorites_bloc.dart';
import 'package:movies_app/features/movies/bloc/movie_bloc.dart';
import 'package:movies_app/features/movies/model/movie_model.dart';
import 'package:movies_app/features/movies/widgets/movie_card.dart';
import 'package:shimmer/shimmer.dart';

class MovieGrid extends StatelessWidget {
  final List<MovieModel> movies;
  final bool isLoading;
  final ScrollController scrollController;
  final bool isFavoritesScreen;

  const MovieGrid({
    super.key,
    required this.movies,
    required this.scrollController,
    this.isLoading = false,
    this.isFavoritesScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: movies.length + (isLoading ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= movies.length) {
          return _buildShimmerCard();
        }

        return BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, favoritesState) {
            final movie = movies[index];
            movie.isFavorite =
                favoritesState.favorites.any((m) => m.id == movie.id);
            return MovieCard(
              movie: movie,
              onFavoritePressed: () {
                if (movie.isFavorite) {
                  context.read<FavoritesBloc>().add(RemoveFromFavorites(movie));
                } else {
                  context.read<FavoritesBloc>().add(AddToFavorites(movie));
                }

                context.read<MovieBloc>().add(ToggleFavorite(movie));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      movie.isFavorite
                          ? 'Removed from favorites'
                          : 'Added to favorites',
                    ),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Theme.of(context).primaryColor,
                    action: SnackBarAction(
                      label: 'UNDO',
                      textColor: Colors.white,
                      onPressed: () {
                        if (movie.isFavorite) {
                          context
                              .read<FavoritesBloc>()
                              .add(AddToFavorites(movie));
                        } else {
                          context
                              .read<FavoritesBloc>()
                              .add(RemoveFromFavorites(movie));
                        }
                        context.read<MovieBloc>().add(ToggleFavorite(movie));
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[800]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
