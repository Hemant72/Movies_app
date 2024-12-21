import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/routes/app_routes.dart';
import 'package:movies_app/core/storage/storage_service.dart';
import 'package:movies_app/core/theme/app_theme.dart';
import 'package:movies_app/features/favorites/bloc/favorites_bloc.dart';
import 'package:movies_app/features/movies/bloc/movie_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = StorageService();
  await storageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MovieBloc()),
        BlocProvider(create: (context) => FavoritesBloc()),
      ],
      child: MaterialApp.router(
        title: 'Flutter Movie',
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
