import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pp_flutter_lib_method_channel.dart';

abstract class PpFlutterLibPlatform extends PlatformInterface {
  /// Constructs a PpFlutterLibPlatform.
  PpFlutterLibPlatform() : super(token: _token);

  static final Object _token = Object();

  static PpFlutterLibPlatform _instance = MethodChannelPpFlutterLib();

  /// The default instance of [PpFlutterLibPlatform] to use.
  ///
  /// Defaults to [MethodChannelPpFlutterLib].
  static PpFlutterLibPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PpFlutterLibPlatform] when
  /// they register themselves.
  static set instance(PpFlutterLibPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
