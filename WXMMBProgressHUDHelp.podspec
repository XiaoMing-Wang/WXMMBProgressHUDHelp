Pod::Spec.new do |s|
  s.name         = "WXMMBProgressHUDHelp" 
  s.version      = "1.0.0"        
  s.license      = "MIT"
  s.summary      = "mbhud"

  s.homepage     = "https://github.com/XiaoMing-Wang/WXMMBProgressHUDHelp" 
  s.source       = { :git => "https://github.com/XiaoMing-Wang/WXMMBProgressHUDHelp.git", :tag => "#{s.version}" }
  s.source_files = "WXMMBProgressHUDHelp/Classes/**/*"
  s.requires_arc = true 
  s.platform     = :ios, "9.0" 
  # s.frameworks   = "UIKit", "Foundation" 
  # s.dependency   = "AFNetworking" 
  s.author             = { "wq" => "347511109@qq.com" } 
end