Pod::Spec.new do |s|
  s.name         = "PWEngagement"
  s.version      = "3.4.5"
  s.summary      = "Phunware Mobile Engagement SDK"
  s.homepage     = "http://phunware.github.io/maas-engagement-ios-sdk/"
  s.author       = { 'Phunware, Inc.' => 'http://www.phunware.com' }
  s.social_media_url = 'https://twitter.com/Phunware'

  s.platform     = :ios, '9.0'
  s.source       = { :git => "https://github.com/phunware/maas-engagement-ios-sdk.git", :tag => 'v3.4.5' }
  s.license      = { :type => 'Copyright', :text => 'Copyright 2016 by Phunware Inc. All rights reserved.' }

  s.ios.vendored_frameworks = 'Framework/PWEngagement.framework'
  s.xcconfig      = { 'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/PWEngagement/**"'}

  s.ios.dependency 'PWCore', '>= 3.6.0'
  s.ios.dependency 'FMDB'
  s.ios.dependency 'MistSDK', '1.1.2'
                        
  s.library = 'sqlite3', 'z'
  s.ios.frameworks = 'CoreLocation'
  s.requires_arc  = true

end
