Pod::Spec.new do |s|
  s.name         = "PWEngagement"
  s.version      = "3.1.0"
  s.summary      = "Phunware Mobile Engagement SDK"
  s.homepage     = "http://phunware.github.io/maas-engagement-ios-sdk/"
  s.author       = { 'Phunware, Inc.' => 'http://www.phunware.com' }
  s.social_media_url = 'https://twitter.com/Phunware'

  s.platform     = :ios, '9.0'
  s.source       = { :git => "https://github.com/phunware/maas-engagement-ios-sdk.git", :tag => 'v3.1.0' }
  s.license      = { :type => 'Copyright', :text => 'Copyright 2016 by Phunware Inc. All rights reserved.' }

  s.ios.vendored_frameworks = 'Framework/PWEngagement.framework'
  s.xcconfig      = { 'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/PWEngagement/**"'}
  
  s.dependency 'PWCore'
  s.dependency 'FMDB'
  
  s.library = 'sqlite3', 'z'
  s.ios.frameworks = 'CoreLocation'
  s.requires_arc  = true
  
end