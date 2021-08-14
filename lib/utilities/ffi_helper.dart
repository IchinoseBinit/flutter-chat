import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

typedef EncryptFunction = Pointer<Utf8> Function(Pointer<Utf8> message);
typedef EncryptFunctionDart = Pointer<Utf8> Function(Pointer<Utf8> message);

typedef DecryptFunction = Pointer<Utf8> Function(Pointer<Utf8> message);
typedef DecryptFunctionDart = Pointer<Utf8> Function(Pointer<Utf8> message);

class FFIHelper {
  late DynamicLibrary dynamicLibrary;

  FFIHelper() {
    dynamicLibrary = Platform.isAndroid
        ? DynamicLibrary.open("libcryptor.so")
        : DynamicLibrary.process();
  }

  encryptString(String message) {
    final messageToUtf8 = message.toNativeUtf8();
    final getEncryptedString = dynamicLibrary
        .lookupFunction<EncryptFunction, EncryptFunctionDart>('encrypt');
    final messageString = getEncryptedString(messageToUtf8);

    print(messageString.toDartString());
    // Error occurs in this part
    // tyo uta bata aako value actual ma encrypted string hunna!!!
    // Baaki tyo method call garna chei milxa if Int datatype thyovane call garera chalaunani milxa

    malloc.free(messageToUtf8);
    return messageString.toDartString();
  }

  decryptString(String message) {
    final messageToUtf8 = message.toNativeUtf8();

    final getDecryptedString = dynamicLibrary
        .lookupFunction<EncryptFunction, EncryptFunctionDart>('decrypt');
    final messageString = getDecryptedString(messageToUtf8).toDartString();
    malloc.free(messageToUtf8);
    return messageString;
  }
}
