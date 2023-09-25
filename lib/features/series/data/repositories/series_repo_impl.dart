import 'package:dartz/dartz.dart';
import 'package:gaze/core/errors/exceptions.dart';
import 'package:gaze/core/errors/failures.dart';
import 'package:gaze/core/utils/typedefs.dart';
import 'package:gaze/features/series/data/data_sources/series_remote_data_source.dart';
import 'package:gaze/features/series/domain/models/series_model.dart';
import 'package:gaze/features/series/domain/repositories/series_repo.dart';

class SeriesRepoImpl implements SeriesRepo {
  const SeriesRepoImpl(this._remoteDataSource);

  final SeriesRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<SeriesModel>> getPopularSeries() async {
    try {
      final result = await _remoteDataSource.getPopularSeries();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<SeriesModel>> getTrendingSeries() async {
    try {
      final result = await _remoteDataSource.getTrendingSeries();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}