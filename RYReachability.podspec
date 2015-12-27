Pod::Spec.new do |s|
  s.name         = "RYNetWorkManager"
  s.version      = "0.0.1"
  s.summary      = "we can check the current network is work"
  s.description  = <<-DESC
                   DESC

  s.homepage     = "https://github.com/pengleelove/RYNetWorkManager"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = "MIT"

  s.author             = { "bfforeverli" => "lipengios@163.com" }

  s.platform     = :ios, "7.0"

  #  When using multiple platforms
   s.ios.deployment_target = "7.0"



  s.source       = { :git => "https://github.com/pengleelove/RYNetWorkManager.git", :commit => "" }

  s.source_files  ="RYReachability/RYReachability/RYReachability/*.{h,m}"

 s.frameworks = "CoreTelephony", "UIKit","Foundation"





  s.requires_arc = true

end
