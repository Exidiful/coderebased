import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

// StateNotifierProvider to keep track of the current directory within a repo
final repoDirectoryProvider =
    StateNotifierProvider<RepoDirectoryNotifier, String>((ref) {
  return RepoDirectoryNotifier();
});

class RepoDirectoryNotifier extends StateNotifier<String> {
  RepoDirectoryNotifier() : super('');

  void navigateTo(String directory) {
    if (directory.isEmpty) {
      state = ''; // Reset to root
    } else {
      state = directory;
    }
  }

  void navigateToParent() {
    final segments = state.split('/');
    if (segments.length > 1) {
      segments.removeLast();
      state = segments.join('/');
    } else {
      state = ''; // Reset to root
    }
  }
}

// Provider for the StorageService
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final StateProvider<String> _currentPathProvider;

  StorageService({required StateProvider<String> currentPathProvider})
      : _currentPathProvider = currentPathProvider;

  Future<String> uploadRepoFile(File file, String repoId) async {
    final currentPath = _currentPathProvider.state;
    try {
      final ref = _storage
          .ref()
          .child('/repo/$repoId/$currentPath/${path.basename(file.path)}');
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }

  Future<String> uploadProfileImage(File image) async {
    try {
      final extension = path.extension(image.path);
      final ref = _storage.ref().child('/users/profile.$extension');
      final uploadTask = await ref.putFile(image);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading profile image: $e');
    }
  }

  Future<void> createRepoFolder(String repoId, String folderName) async {
    final currentPath = _currentPathProvider.state;
    try {
      final ref =
          _storage.ref().child('/repo/$repoId/$currentPath/$folderName/.init');
      await ref.putString('');
    } catch (e) {
      throw Exception('Error creating folder: $e');
    }
  }

  Future<void> uploadRepoFiles(
    String repoId,
    List<File> files,
  ) async {
    final currentPath = _currentPathProvider.state;
    try {
      for (final file in files) {
        final fileName = path.basename(file.path);
        final ref =
            _storage.ref().child('/repo/$repoId/$currentPath/$fileName');
        await ref.putFile(file);
      }
    } catch (e) {
      throw Exception('Error uploading repository files: $e');
    }
  }

  Future<void> downloadRepo(String repoId, String localPath) async {
    try {
      final repoRef = _storage.ref().child('/repo/$repoId');
      final listResult = await repoRef.listAll();

      for (final item in listResult.items) {
        final downloadUrl = await item.getDownloadURL();
        // Download file using downloadUrl and save to localPath
      }

      for (final prefix in listResult.prefixes) {
        // Create a directory in localPath
        final subdirectoryName = path.basename(prefix.fullPath);
        // Recursively call downloadRepo to download files in the subdirectory
      }
    } catch (e) {
      throw Exception('Error downloading repository: $e');
    }
  }

  String getFileExtension(String filePath) {
    return path.extension(filePath).toLowerCase();
  }

  Future<void> deleteFile(String filePath) async {
    try {
      final ref = _storage.ref().child(filePath);
      await ref.delete();
    } catch (e) {
      throw Exception('Error deleting file: $e');
    }
  }

  Future<List<Reference>> listFiles(String directoryPath) async {
    try {
      final ref = _storage.ref().child(directoryPath);
      final listResult = await ref.listAll();
      return listResult.items;
    } catch (e) {
      throw Exception('Error listing files: $e');
    }
  }

  Future<String> getDownloadURL(String filePath) async {
    try {
      final ref = _storage.ref().child(filePath);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error getting download URL: $e');
    }
  }
}
