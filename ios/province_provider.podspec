#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'province_provider'
  s.version          = '0.0.2'
  s.summary          = 'Province Picker'
  s.description      = <<-DESC
Province Picker
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.resource_bundles = {
      'Assets' => ["Classes/**/*.xib","Assets/**/*.xib","Assets/**/*.json"]
  }
  s.dependency 'Flutter'

  s.ios.deployment_target = '8.0'
end

