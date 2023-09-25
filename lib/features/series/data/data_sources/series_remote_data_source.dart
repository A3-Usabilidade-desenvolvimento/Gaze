import 'dart:convert';

import 'package:gaze/core/errors/exceptions.dart';
import 'package:gaze/features/series/data/data_sources/interceptor.dart';
import 'package:gaze/features/series/data/models/series_entity.dart';
import 'package:http_interceptor/http_interceptor.dart';

const String kBaseUrl = 'http://api.themoviedb.org/3';
const kGetPopularSeriesEndpoint = '/tv/popular';
const kGetTrendingSeriesEndpoint = '/trending/tv';
const kTmdbApiKey = '24e29501a7520a99e65304fad758b78b';
const kImageBaseUrl = 'https://image.tmdb.org/t/p/w500';

abstract class SeriesRemoteDataSource {
  const SeriesRemoteDataSource();

  Future<List<SeriesEntity>> getPopularSeries();

  Future<List<SeriesEntity>> getTrendingSeries();
}

class SeriesRemoteDataSourceImpl extends SeriesRemoteDataSource {
  SeriesRemoteDataSourceImpl();

  final _client = InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  @override
  Future<List<SeriesEntity>> getPopularSeries() async {
    try {
      final response = await _client.get(
        Uri.parse('$kBaseUrl$kGetPopularSeriesEndpoint?api_key=$kTmdbApiKey'),
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: response.body,
          statusCode: response.statusCode.toString(),
        );
      }

      final data = jsonDecode(response.body)['results'] as List<dynamic>;
      return data
          .map<SeriesEntity>(
            (series) => SeriesEntity.fromJson(series as Map<String, dynamic>),
          )
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<List<SeriesEntity>> getTrendingSeries() async {
    try {
      final response = await _client.get(
        Uri.parse('$kBaseUrl$kGetTrendingSeriesEndpoint?api_key=$kTmdbApiKey'),
        params: {
          'time_window': 'week',
        },
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: response.body,
          statusCode: response.statusCode.toString(),
        );
      }
      final data = jsonDecode(response.body)['results'] as List<dynamic>;
      return data
          .map<SeriesEntity>(
            (series) => SeriesEntity.fromJson(series as Map<String, dynamic>),
          )
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}