

Pod::Spec.new do |s|

 

  s.name         = "RYNetWorkManager"
  s.version      = "0.0.1"
  s.summary      = “The RYNetWorkManager. to help check the iPhone internet is good work”

  
  s.description  = <<-DESC

	it’s only work with iOS 
                   DESC

  s.homepage     = "https://github.com/pengleelove/RYNetWorkManager"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


 
  s.license      = "MIT"
 
  s.author             = { "bfforeverli" => "lipengios@163.com" }
 
 
   s.platform     = :ios, “7.0”

  #  When using multiple platforms
  s.ios.deployment_target = “7.0”
 

  s.source       = { :git => "https://github.com/pengleelove/RYNetWorkManager.git", :tag => "0.0.1" }

  s.source_files  = “RYReachability”, "RYReachability/RYReachability/RYReachability/*.{h,m}”
 # s.exclude_files = "Classes/Exclude"

   s.frameworks = “UIKit”, “CoreTelephony”,”Foundation”

 

   s.requires_arc = true

end
