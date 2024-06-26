#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint chat_bottom_container.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'chat_bottom_container'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.vendored_frameworks = 'Frameworks/FSAChatBottomContainer.xcframework'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'
  s.prepare_command = <<-CMD
    VERSION="0.0.1"
    IOS_FRAMEWORK_PATH=Frameworks
    IOS_ZIP=ios_${VERSION}.zip
    IOS_ZIP_PATH=$IOS_FRAMEWORK_PATH/$IOS_ZIP
    rm -rf $IOS_FRAMEWORK_PATH
    mkdir -p $IOS_FRAMEWORK_PATH
    curl -L -o $IOS_ZIP_PATH "https://github.com/LinXunFeng/flutter_chat_packages_pub/releases/download/chat_bottom_container/${IOS_ZIP}"
    unzip $IOS_ZIP_PATH -d $IOS_FRAMEWORK_PATH
    rm $IOS_ZIP_PATH
  CMD

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
