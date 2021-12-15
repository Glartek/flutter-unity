#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_unity.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_unity'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for embedding Unity projects in Flutter projects.'
  s.description      = <<-DESC
A Flutter plugin for embedding Unity projects in Flutter projects.
                       DESC
  s.homepage         = 'https://github.com/Glartek/flutter-unity'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Pedro Godinho' => 'pmcgbox@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'
  s.frameworks = 'UnityFramework'

  # Added vendored properties to help locate the name of the framework
  s.vendored_frameworks = 'UnityFramework.framework'
  s.vendored_libraries = 'UnityFramework'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }

  s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "${PODS_CONFIGURATION_BUILD_DIR}"', 'OTHER_LDFLAGS' => '$(inherited) -framework UnityFramework' }
end
