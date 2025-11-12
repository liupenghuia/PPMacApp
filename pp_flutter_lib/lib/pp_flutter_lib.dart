
import 'pp_flutter_lib_platform_interface.dart';

class PpFlutterLib {
  Future<String?> getPlatformVersion() {
    return PpFlutterLibPlatform.instance.getPlatformVersion();
  }
}
