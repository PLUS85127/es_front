void initChurch(GetIt sl) {
  sl.registerLazySingleton<ChurchRemoteDataSource>(
    () => ChurchRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ChurchRepository>(
    () => ChurchRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => CreateChurchUseCase(sl()));
  sl.registerFactory(() => ChurchProvider(createChurchUseCase: sl()));
}
