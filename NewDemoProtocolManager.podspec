#
# Be sure to run `pod lib lint NewDemoProtocolManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NewDemoProtocolManager'
  s.version          = '0.4.7'
  s.summary          = 'A short description of NewDemoProtocolManager.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!



  s.homepage         = 'https://github.com/only-einsteined/NewDemoProtocolManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'only-einsteined' => 'oieinstein@yeah.net' }
  s.source           = { :git => 'https://github.com/only-einsteined/NewDemoProtocolManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'NewDemoProtocolManager/Classes/*{h,m}'
  
  # s.resource_bundles = {
  #   'NewDemoProtocolManager' => ['NewDemoProtocolManager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
