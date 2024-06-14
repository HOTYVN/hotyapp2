// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v13.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, unnecessary_import
// ignore_for_file: avoid_relative_lib_imports
import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;
import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:image_picker_ios/src/messages.g.dart';

class _TestHostImagePickerApiCodec extends StandardMessageCodec {
  const _TestHostImagePickerApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is MaxSize) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is MediaSelectionOptions) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is SourceSpecification) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return MaxSize.decode(readValue(buffer)!);
      case 129:
        return MediaSelectionOptions.decode(readValue(buffer)!);
      case 130:
        return SourceSpecification.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class TestHostImagePickerApi {
  static TestDefaultBinaryMessengerBinding? get _testBinaryMessengerBinding =>
      TestDefaultBinaryMessengerBinding.instance;
  static const MessageCodec<Object?> codec = _TestHostImagePickerApiCodec();

  Future<String?> pickImage(SourceSpecification source, MaxSize maxSize,
      int? imageQuality, bool requestFullMetadata);

  Future<List<String?>> pickMultiImage(
      MaxSize maxSize, int? imageQuality, bool requestFullMetadata);

  Future<String?> pickVideo(
      SourceSpecification source, int? maxDurationSeconds);

  /// Selects images and videos and returns their paths.
  Future<List<String?>> pickMedia(MediaSelectionOptions mediaSelectionOptions);

  static void setup(TestHostImagePickerApi? api,
      {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.image_picker_ios.ImagePickerApi.pickImage', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.image_picker_ios.ImagePickerApi.pickImage was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final SourceSpecification? arg_source =
              (args[0] as SourceSpecification?);
          assert(arg_source != null,
              'Argument for dev.flutter.pigeon.image_picker_ios.ImagePickerApi.pickImage was null, expected non-null SourceSpecification.');
          final MaxSize? arg_maxSize = (args[1] as MaxSize?);
          assert(arg_maxSize != null,
              'Argument for dev.flutter.pigeon.image_picker_ios.ImagePickerApi.pickImage was null, expected non-null MaxSize.');
          final int? arg_imageQuality = (args[2] as int?);
          final bool? arg_requestFullMetadata = (args[3] as bool?);
          assert(arg_requestFullMetadata != null,
              'Argument for dev.flutter.pigeon.image_picker_ios.ImagePickerApi.pickImage was null, expected non-null bool.');
          try {
            final String? output = await api.pickImage(arg_source!,
                arg_maxSize!, arg_imageQuality, arg_requestFullMetadata!);
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          } catch (e) {
            return wrapResponse(
                error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.image_picker_ios.ImagePickerApi.pickMultiImage',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.image_picker_ios.ImagePickerApi.pickMultiImage was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final MaxSize? arg_maxSize = (args[0] as MaxSize?);
          assert(arg_maxSize != null,
              'Argument for dev.flutter.pigeon.image_picker_ios.ImagePickerApi.pickMultiImage was null, expected non-null MaxSize.');
          final int? arg_imageQuality = (args[1] as int?);
          final bool? arg_requestFullMetadata = (args[2] as bool?);
          assert(arg_requestFullMetadata != null,
              'Argument for dev.flutter.pigeon.image_picker_ios.ImagePickerApi.pickMultiImage was null, expected non-null bool.');
          try {
            final List<String?> output = await api.pickMultiImage(
                arg_maxSize!, arg_imageQuality, arg_requestFullMetadata!);
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          } catch (e) {
            return wrapResponse(
                error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.image_picker_ios.ImagePickerApi.pickVideo', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.image_picker_ios.ImagePickerApi.pickVideo was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final SourceSpecification? arg_source =
              (args[0] as SourceSpecification?);
          assert(arg_source != null,
              'Argument for dev.flutter.pigeon.image_picker_ios.ImagePickerApi.pickVideo was null, expected non-null SourceSpecification.');
          final int? arg_maxDurationSeconds = (args[1] as int?);
          try {
            final String? output =
                await api.pickVideo(arg_source!, arg_maxDurationSeconds);
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          } catch (e) {
            return wrapResponse(
                error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.image_picker_ios.ImagePickerApi.pickMedia', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.image_picker_ios.ImagePickerApi.pickMedia was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final MediaSelectionOptions? arg_mediaSelectionOptions =
              (args[0] as MediaSelectionOptions?);
          assert(arg_mediaSelectionOptions != null,
              'Argument for dev.flutter.pigeon.image_picker_ios.ImagePickerApi.pickMedia was null, expected non-null MediaSelectionOptions.');
          try {
            final List<String?> output =
                await api.pickMedia(arg_mediaSelectionOptions!);
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          } catch (e) {
            return wrapResponse(
                error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
  }
}