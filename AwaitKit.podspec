Pod::Spec.new do |s|
  s.name             = 'AwaitKit'
  s.version          = '1.0.0'
  s.license          = 'MIT'
  s.summary          = 'The ES7 Async/Await control flow for Swift '
  s.homepage         = 'https://github.com/yannickl/AwaitKit.git'
  s.social_media_url = 'https://twitter.com/yannickloriot'
  s.authors          = { 'Yannick Loriot' => 'contact@yannickloriot.com' }
  s.source           = { :git => 'https://github.com/yannickl/AwaitKit.git', :tag => s.version }
  s.screenshot       = 'http://yannickloriot.com/resources/AwaitKit-Arista-Banner.png'

  s.ios.deployment_target = '8.0'

  s.ios.framework = 'Foundation'

  s.dependency 'PromiseKit', '~> 3.2'

  s.source_files = 'Sources/**/*.swift'
  s.requires_arc = true
end
