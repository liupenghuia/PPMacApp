Pod::Spec.new do |s|
  s.name             = 'FlutterMacOS'
  s.version          = '1.0.0'
  s.summary          = 'Flutter macOS Framework'
  s.homepage         = 'https://flutter.dev'
  s.license          = { :type => 'BSD' }
  s.author           = { 'Flutter' => 'flutter@flutter.dev' }
  s.platform         = :osx, '11.0'
  s.source           = { :path => '../pp_flutter_lib/example/build/macos/Build/Products/Release/' }
  s.vendored_frameworks = 'FlutterMacOS.framework'
  s.requires_arc     = true
end