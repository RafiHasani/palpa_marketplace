import 'package:flutter/services.dart';

Future<Uint8List> getImageBytesFromAsset(String assetPath) async {
  ByteData byteData = await rootBundle.load(assetPath);
  return byteData.buffer.asUint8List();
}
