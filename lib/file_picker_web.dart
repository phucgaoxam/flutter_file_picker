// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:async';

import 'package:file_picker/file_picker.dart';

abstract class FilePickerInterface {
  FilePickerInterface._();

  static Future<File> getFile({FileType type = FileType.any, List<String> allowedExtensions}) async {
    List<File> files = await _handleGetFile(type, false);
    return files?.first;
  }

  static Future<String> getFilePath({FileType type = FileType.any, List<String> allowedExtensions}) async =>
      throw UnimplementedError('Unsupported');

  static Future<List<File>> getMultiFile({FileType type = FileType.any, List<String> allowedExtensions}) async =>
      _handleGetFile(type, true);

  static Future<Map<String, String>> getMultiFilePath({FileType type = FileType.any, List<String> allowedExtensions}) async =>
      throw UnimplementedError('Unsupported Platform for file_picker_cross');

  static Future<bool> clearTemporaryFiles() async => throw UnimplementedError('Unsupported');

  /// Returns a `List<html.File>` with picked file(s) to be used in a web context.
  /// Allows setting [allowMultiple] for multiple file picking (defaults to `false`).
  ///
  /// **IMPORTANT:** Have in mind that if you specify a type when picking (eg. by not using `var` or `final`),
  /// you should define it as `html.File` by for example importing
  /// ```
  /// import 'dart:html' as html;
  /// ```
  /// otherwise it could be jumbled with Dart IO File object and throw an error.
  static Future<List<File>> _handleGetFile(FileType type, bool allowMultiple) async {
    final Completer<List<File>> pickedFiles = Completer<List<File>>();
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.multiple = allowMultiple;
    uploadInput.click();
    uploadInput.onChange.listen((event) => pickedFiles.complete(uploadInput.files));
    return await pickedFiles.future;
  }
}
