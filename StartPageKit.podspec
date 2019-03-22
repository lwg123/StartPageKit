
Pod::Spec.new do |s|

  s.name         = "StartPageKit"
  s.version      = "0.0.2"
  s.summary      = "这是一个用于启动页的组件"

  s.description  = <<-DESC
这是一个用于启动页的组件,这是一个cocoapod库
                   DESC

  s.homepage     = "https://github.com/lwg123/StartPageKit"
  s.license      = { :type => "MIT" }
  s.author             = { "liweiguang@duia.com" => "weiguang.li@changhong.com" }

  s.platform     = :ios
  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/lwg123/StartPageKit.git", :tag => s.version.to_s}

  s.source_files  = 'StartPageKit/**/*.{h,m}'
  s.frameworks  = "UIKit","Foundation","ImageIO"

  s.dependency 'SDWebImage'
end
