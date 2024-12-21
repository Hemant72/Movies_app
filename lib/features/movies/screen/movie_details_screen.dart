import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/favorites/bloc/favorites_bloc.dart';
import 'package:movies_app/features/movies/bloc/movie_bloc.dart';

class MovieDetailsScreen extends StatelessWidget {
  final String movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MoviesState>(
      builder: (context, state) {
        final movie = state.movies.firstWhere(
          (m) => m.id.toString() == movieId,
        );

        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 400,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Hero(
                          tag: 'movie-poster-${movie.id}',
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    'https://image.tmdb.org/t/p/original${movie.posterPath}',
                                fit: BoxFit.cover,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black45,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                Text(movie.rating.toString()),
                                const Spacer(),
                                BlocBuilder<FavoritesBloc, FavoritesState>(
                                  builder: (context, favoritesState) {
                                    movie.isFavorite = favoritesState.favorites
                                        .any((m) => m.id == movie.id);
                                    return IconButton(
                                      icon: Icon(
                                        movie.isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        if (movie.isFavorite) {
                                          context
                                              .read<FavoritesBloc>()
                                              .add(RemoveFromFavorites(movie));
                                        } else {
                                          context
                                              .read<FavoritesBloc>()
                                              .add(AddToFavorites(movie));
                                        }
                                        context
                                            .read<MovieBloc>()
                                            .add(ToggleFavorite(movie));
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              movie.overview,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
