Pod::Spec.new do |s|
  s.name             = 'AwaitKit'
  s.version          = '5.0.1'
  s.license          = 'MIT'
  s.summary          = 'The ES8 Async/Await control flow for Swift '
  s.homepage         = 'https://github.com/yannickl/AwaitKit.git'
  s.social_media_url = 'https://twitter.com/yannickloriot'
  s.authors          = { 'Yannick Loriot' => 'contact@yannickloriot.com' }
  s.source           = { :git => 'https://github.com/yannickl/AwaitKit.git', :tag => s.version }
  s.screenshot       = 'http://yannickloriot.com/resources/AwaitKit-Arista-Banner.png'

  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.11'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target    = '9.0'

  s.ios.framework = 'Foundation'

  s.dependency 'PromiseKit', '~> 6'

  s.source_files = 'Sources/**/*.swift'
  s.requires_arc = true
end
