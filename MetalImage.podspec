Pod::Spec.new do |s|
  s.name             = 'MetalImage'
  s.version          = '0.0.3'
  s.summary          = 'MetalImage use to camera.'
  s.homepage         = 'https://github.com/zhangsirong/MetalImage'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhangsr' => 'lpzsrong@gamil.com' }
  s.source           = { :git => 'https://github.com/zhangsirong/MetalImage.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'MetalImage/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MetalImage' => ['MetalImage/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Metal', 'MetalKit', 'UIKit', 'MobileCoreServices', 'ImageIO', 'CoreMotion', 'Foundation', 'CoreGraphics', 'AVFoundation', 'QuartzCore', 'CoreFoundation', 'CoreMedia'
  s.requires_arc = true

end
