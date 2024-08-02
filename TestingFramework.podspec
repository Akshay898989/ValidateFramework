Pod::Spec.new do |s|
  s.name             = "TestingFramework"
  s.version          = "0.0.1"
  s.summary          = "The SurveySensum Mobile Feedback SDK for iOS"
  s.homepage         = "https://github.com/Akshay898989/ValidateFramework"
  s.license          = 'MIT'
  s.author           = { "Akshay Gupta" => "akshay@neurosensum.com" }
  s.source           = { :git => "https://github.com/Akshay898989/ValidateFramework.git", :branch => 'feature/akshay' }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  s.requires_arc = true
  s.source_files = 'TestingFramework/Sources/**/*.{h,m,swift}'
  s.vendored_frameworks = 'TestingFramework/TestingFramework.framework'
  s.resource_bundles = {
    'TestingFramework' => ['TestingFramework/Sources/Assets/*.png']
}

end
