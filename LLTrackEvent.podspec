
Pod::Spec.new do |s|
s.name         = "LLTrackEvent"
  s.version      = "1.0.3"
  s.summary      = "A track event upload sdk."
  s.homepage     = "https://github.com/zhangweili450326/LLTrackEvent"
  s.license      = "MIT"
  s.platform     = :ios, "8.0"
  s.author             = { "admin" => "362870113@qq.com" }
  s.source       = { :git => "https://zhangweili450326/LLTrackEvent.git", :tag => "1.0.3" }
  s.source_files  = "LLTrackEvent/*.{h,m}"
  s.dependency 'AFNetworking','~> 3.2.0'
  s.dependency 'FMDB'
  s.dependency 'Reachability'
  s.requires_arc = true
end
