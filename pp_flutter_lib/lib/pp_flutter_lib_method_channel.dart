import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pp_flutter_lib_platform_interface.dart';

/// An implementation of [PpFlutterLibPlatform] that uses method channels.
class MethodChannelPpFlutterLib extends PpFlutterLibPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pp_flutter_lib');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
