
Pod::Spec.new do |s|

  s.name         = "testPodKit"
  s.version      = "0.0.2"
  s.summary      = "这是一个测试cocoapod库的例子"

  s.description  = <<-DESC
这是一个测试cocoapod库的例子，试试怎么样哈哈
                   DESC

  s.homepage     = "https://github.com/lwg123/testPodKit"
  s.license      = { :type => "MIT" }
  s.author             = { "liweiguang@duia.com" => "weiguang.li@changhong.com" }

  s.platform     = :ios
  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/lwg123/testPodKit.git", :tag => s.version.to_s}

  s.source_files  = 'testPodKit/**/*.{h,m}'
  s.framework  = "UIKit"

end
