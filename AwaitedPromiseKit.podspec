Pod::Spec.new do |s|
  s.name             = 'AwaitedPromiseKit'
  s.version          = '1.0.0'
  s.license          = 'MIT'
  s.summary          = 'Async/Await control flow for Swift'
  s.homepage         = 'https://github.com/yannickl/AwaitedPromiseKit.git'
  s.social_media_url = 'https://twitter.com/yannickloriot'
  s.authors          = { 'Yannick Loriot' => 'contact@yannickloriot.com' }
  s.source           = { :git => 'https://github.com/yannickl/AwaitedPromiseKit.git', :tag => s.version }
  s.screenshot       = 'http://yannickloriot.com/resources/dynamicbutton.gif'

  s.ios.deployment_target = '8.0'

  s.ios.framework = 'Foundation'

  s.dependency 'PromiseKit', '~> 3'

  s.source_files = 'Sources/**/*.swift'
  s.requires_arc = true
end
