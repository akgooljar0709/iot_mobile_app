import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/weather_remote_datasource.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/repositories/weather_repository_impl.dart';

/// Provider for HTTP client instance
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

/// Provider for weather remote data source
final weatherRemoteDataSourceProvider =
    Provider<WeatherRemoteDataSource>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  return WeatherRemoteDataSourceImpl(httpClient: httpClient);
});

/// Provider for weather repository (singleton)
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final remoteDataSource = ref.watch(weatherRemoteDataSourceProvider);
  return WeatherRepositoryImpl(remoteDataSource: remoteDataSource);
});
