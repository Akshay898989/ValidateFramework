Pod::Spec.new do |s|
  s.name             = "TestingFramework"
  s.version          = "0.0.1"
  s.summary          = "Feedback SDK for mobile apps"
  s.homepage         = "https://github.com/Akshay898989/ValidateFramework"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Akshay" => "akshay.gupta8989@gmail.com" }
  s.source           = { :git => "https://github.com/Akshay898989/ValidateFramework.git", :branch => 'feature/akshay' }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  s.requires_arc = true
  s.source_files = 'TestingFramework/Sources/**/*.{h,m,swift}' # Path to source files
  #s.vendored_frameworks = 'TestingFramework.framework' # Path to the compiled framework
  s.resource_bundles = {
    'TestingFramework' => ['TestingFramework/Sources/Assets/*.png'] # Path to resource files
  }

end

