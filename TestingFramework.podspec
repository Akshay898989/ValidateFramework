Pod::Spec.new do |s|
  s.name             = "TestingFramework"
  s.version          = "0.0.2"
  s.summary          = "The SurveySensum Mobile Feedback SDK for iOS"
  s.homepage         = "https://github.com/Akshay898989/ValidateFramework"
  s.license          = 'MIT'
  s.author           = { "Akshay Gupta" => "akshay@neurosensum.com" }
  s.source           = { :http => 'https://github.com/Akshay898989/ValidateFramework/releases/download/0.0.2/TestingFramework.zip' }
  s.ios.deployment_target = '12.0'
  s.swift_version    = '5.0'
  s.requires_arc     = true
  s.ios.vendored_frameworks = 'TestingFramework.xcframework'
end
