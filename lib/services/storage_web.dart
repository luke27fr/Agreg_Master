import 'storage_service.dart';

/// Creates the platform-appropriate StorageService (web).
StorageService createStorageService() => WebStorageService();
