import 'package:flutter/material.dart';
import 'package:flutter_book_manager/data/app_database.dart';
import 'package:flutter_book_manager/presentation/pages/book_list_page.dart';
import 'package:flutter_book_manager/data/repositories/book_repository.dart';
import 'package:flutter_book_manager/domain/repositories/book_repository.dart';
import 'package:flutter_book_manager/data/local/local_data_source.dart';
import 'package:flutter_book_manager/data/remote/remote_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localDataSourceProvider = Provider(
  (ref) {
    final database = ref.watch(databaseProvider).database;
    return LocalDataSource(database: database);
  },
);

final remoteDataSourceProvider = Provider((ref) => RemoteDataSource());

final bookRepositoryProvider = Provider<BookRepository>(
  (ref) {
    final localDataSource = ref.watch(localDataSourceProvider);
    final remoteDataSource = ref.watch(remoteDataSourceProvider);
    return BookRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );
  },
);

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDatabase = AppDatabase();
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(appDatabase),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Book Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookListPage(),
    );
  }
}
