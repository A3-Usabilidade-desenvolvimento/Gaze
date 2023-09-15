import 'package:dartz/dartz.dart';
import 'package:gaze/core/errors/exceptions.dart';
import 'package:gaze/core/errors/failures.dart';
import 'package:gaze/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:gaze/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:gaze/features/auth/domain/models/user_model.dart';
import 'package:gaze/features/auth/domain/repositories/auth_repo.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRemoteDataSource remoteDataSource;
  late AuthRepo repo;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repo = AuthRepoImpl(remoteDataSource);
  });

  const tUser = UserModel.empty();
  const tEmail = 'email';
  const tPassword = 'password';
  const tServerException = ServerException(message: '', statusCode: '');

  group('signIn', () {
    test(
      'should call [AuthRemoteDataSource.signIn] and return [UserModel] '
      'when call to remote source is successful',
      () async {
        when(
          () => remoteDataSource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => tUser);

        final result = await repo.signIn(
          email: tEmail,
          password: tPassword,
        );

        expect(result, const Right<dynamic, UserModel>(tUser));
        verify(
          () => remoteDataSource.signIn(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
    test(
        'should call [AuthRemoteDataSource.signIn] and return [ServerFailure] '
        'when the call is unsuccessful', () async {
      when(
        () => remoteDataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(tServerException);

      final result = await repo.signIn(
        email: tEmail,
        password: tPassword,
      );

      expect(
        result,
        Left<ServerFailure, dynamic>(
          ServerFailure.fromException(tServerException),
        ),
      );
      verify(
        () => remoteDataSource.signIn(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
