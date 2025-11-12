import 'package:flutter_test/flutter_test.dart';
import 'package:pp_flutter_lib/pp_flutter_lib.dart';
import 'package:pp_flutter_lib/pp_flutter_lib_platform_interface.dart';
import 'package:pp_flutter_lib/pp_flutter_lib_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPpFlutterLibPlatform
    with MockPlatformInterfaceMixin
    implements PpFlutterLibPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PpFlutterLibPlatform initialPlatform = PpFlutterLibPlatform.instance;

  test('$MethodChannelPpFlutterLib is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPpFlutterLib>());
  });

  test('getPlatformVersion', () async {
    PpFlutterLib ppFlutterLibPlugin = PpFlutterLib();
    MockPpFlutterLibPlatform fakePlatform = MockPpFlutterLibPlatform();
    PpFlutterLibPlatform.instance = fakePlatform;

    expect(await ppFlutterLibPlugin.getPlatformVersion(), '42');
  });
}
