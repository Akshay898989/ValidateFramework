Pod::Spec.new do |s|
  s.name             = "TestingFramework"
  s.version          = "0.0.1"
  s.summary          = "Feedback SDK for mobile apps"
  s.homepage         = "https://github.com/Akshay898989/ValidateFramework"
  #s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Akshay" => "akshay.gupta8989@gmail.com" }
  #s.source           = { :git => "https://github.com/Akshay898989/ValidateFramework.git", :tag => #s.version.to_s }
  s.source           = { :path => /Users/akshaygupta/TestingFramework' }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  s.requires_arc = true
  s.source_files = 'Sources/**/*.{h,m,swift}' # Path to the source files
  s.vendored_frameworks = 'TestingFramework.framework' # If you are using a precompiled framework
  s.resource_bundles = {
    'TestingFramework' => ['TestingFramework/SourcesAssets/*.png'] # Path to resource files
  }

  # Any additional information or custom attributes can be added here
end
